from pydantic import BaseModel
from pathlib import Path

class BackupConfig(BaseModel):
    months_to_keep: int

class Backup(BaseModel):
    webViewLink: str
    createdTime: str
    id: str
    name: str

    @staticmethod
    def get_fields():
        return 'id, name, webViewLink, createdTime'

class BackupRemoteItem(BaseModel):
    name: str
    backups: list[Backup] = []

class BackupLocalConfig(BaseModel):
    name: str
    output_path: Path
    config: BackupConfig = BackupConfig(months_to_keep=1)

class BackupsLocalList(BaseModel):
    items: list[BackupLocalConfig] = []

class BackupsRemoteList(BaseModel):
    items: list[BackupRemoteItem] = []
