import argparse
import io
from pathlib import Path
from typing import Annotated
import rich
import glob
from g_drive_service import GDriveBackupManager
from schemas import Backup, BackupRemoteItem, BackupsRemoteList, BackupsLocalList
from googleapiclient.http import MediaFileUpload, MediaIoBaseDownload
from pydantic import BaseModel
import typer

ROOT_PATH = Path('/home/asanchez/GIT/Ordiso-Server')

cli = typer.Typer(
    help=f"""
Package for backing up files to Google Drive

Version: 0.1.0
""",
)

class BackupManager:

    def __init__(self, backup_local_list: Path):
        self.backup_local_list = BackupsLocalList.model_validate_json(backup_local_list.read_text())
        self.gdrive = GDriveBackupManager()

    def backup(self, name: str, artifact: Path):
        # Check if valid backup group name
        if name not in [item.name for item in self.backup_local_list.items]:
            rich.print(f"Backup {name} not found in backup config list.")
            return
        
        # Get remote backup list
        backup_remote_list = self.gdrive.getRemoteBackupList()
        local_item = next((x for x in self.backup_local_list.items if x.name == name), None)
        remote_item = next((x for x in backup_remote_list.items if x.name == name), None)

        # Check if remote item exists else create it
        if not remote_item:
            remote_item = BackupRemoteItem(name=name)
            backup_remote_list.items.append(remote_item)

        # Check if file already exists in remote item
        if artifact.name in [backup.name for backup in remote_item.backups]:
            rich.print(f"Backup {artifact.name} already exists in remote item {remote_item.name}. Updating it.")
            
            # Upload file
            file = self.gdrive.uploadFile(artifact)
        else:
            rich.print(f"Backup {artifact.name} does not exist in remote item {remote_item.name}. Creating it.")
            # Upload file
            file = self.gdrive.uploadFile(artifact)
            remote_item.backups.append(file)

        # Update backup register in GDrive
        backup_register_data = backup_remote_list.model_dump_json(indent=4)
        with open('backup_register.json', 'w') as json_file:
            json_file.write(backup_register_data)

        self.gdrive.uploadFile(Path('backup_register.json'))
        Path('backup_register.json').unlink()

    def initialize(self, output_folder: Path):

        backup_remote_list = self.gdrive.getRemoteBackupList()

        for local_item in self.backup_local_list.items:
            # Get same item from remote list
            remote_item = next((x for x in backup_remote_list.items if x.name == local_item.name), None)
            if remote_item:
                # Check if there are backups
                if remote_item.backups:
                    sorted_backups = sorted(remote_item.backups, key=lambda backup: backup.createdTime, reverse=True)
                    last_backup = sorted_backups[0]
                    backup_id = last_backup.id
                    backup_name = last_backup.name

                    output_path = output_folder / local_item.output_path / Path(backup_name)
                    output_path.parent.mkdir(parents=True, exist_ok=True)
                    rich.print(output_path)
                    self.gdrive.downloadFile(backup_id, output_path)

    def cleanup(self):
        pass

    def list(self):
        backups = self.gdrive.list()
        for backup in backups:
            rich.print(backup)

    def remove(self, file_id: str):
        self.gdrive.delete(file_id)


@cli.command()    
def initialize(
    config_file: Annotated[
        Path,
        typer.Argument(
            help="Configuration file",
            file_okay=True,
            dir_okay=False,
        ),
    ],
    output_folder: Annotated[
        Path,
        typer.Argument(
            help="Output folder",
            file_okay=False,
            dir_okay=True,
        ),
    ]
):
    BackupManager(config_file).initialize(output_folder)


@cli.command()
def backup(
    name: Annotated[str, typer.Argument(help="Backup name")],
    config_file: Annotated[
        Path,
        typer.Argument(
            help="Configuration file",
            file_okay=True,
            dir_okay=False,
        ),
    ],
    artifact: Annotated[
        Path,
        typer.Argument(
            help="Artifact to backup",
            file_okay=True,
            dir_okay=False,
        ),
    ]
    ):
    BackupManager(config_file).backup(name, artifact)


@cli.command()
def list(
    config_file: Annotated[
        Path,
        typer.Argument(
            help="Configuration file",
            file_okay=True,
            dir_okay=False,
        ),
    ]
):
    BackupManager(config_file).list()


@cli.command()
def reset_all(
    config_file: Annotated[
        Path,
        typer.Argument(
            help="Configuration file",
            file_okay=True,
            dir_okay=False,
        ),
    ]
):
    list_files = BackupManager(config_file).list()
    for file in list_files:
        BackupManager(config_file).remove(file.id)


@cli.command()
def remove(
    config_file: Annotated[
        Path,
        typer.Argument(
            help="Configuration file",
            file_okay=True,
            dir_okay=False,
        ),
    ],
    file_id: Annotated[str, typer.Argument(help="File id")]
):
    BackupManager(config_file).remove(file_id)


if __name__ == "__main__":
    cli()