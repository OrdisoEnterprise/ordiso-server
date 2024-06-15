import os
from googleapiclient.discovery import build
from oauth2client.service_account import ServiceAccountCredentials
import io
from pathlib import Path
import rich
from schemas import Backup, BackupsRemoteList
from googleapiclient.http import MediaFileUpload, MediaIoBaseDownload

class GoogleDriveService:
    def __init__(self):
        self._SCOPES=['https://www.googleapis.com/auth/drive']

        _base_path = os.path.dirname(__file__)
        _credential_path=os.path.join(_base_path, 'data/credential.json')
        os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = _credential_path

    def build(self):
        creds = ServiceAccountCredentials.from_json_keyfile_name(os.getenv("GOOGLE_APPLICATION_CREDENTIALS"), self._SCOPES)
        service = build('drive', 'v3', credentials=creds)

        return service
    

class GDriveBackupManager:

    backups_register_name: str = 'backup_register.json'
    backups_register: Backup = None

    def __init__(self):
        self.g_drive_service = GoogleDriveService().build()

    def _create_backup_register(self) -> str:

        backup_register = BackupsRemoteList()
        backup_register_data = backup_register.model_dump_json(indent=4)
        # Save backup_register_data to a temporary JSON file
        with open(self.backups_register_name, 'w') as json_file:
            json_file.write(backup_register_data)
        
        file_metadata = {
            'name': self.backups_register_name,
            'parents': ['1-M5m228rrmRNn9zKWap6bV0Qy2nD-Q9R'],
            'mimeType': 'application/json',
            'description': 'Backup register'
        }
        
        media_body = MediaFileUpload('backup_register.json', mimetype='application/json') 
        file = self.g_drive_service.files().create(body=file_metadata, media_body=media_body, fields='id').execute()
        # Remove temporary JSON file
        self.backups_register = Backup(**file)
        Path('backup_register.json').unlink()
        return backup_register

    def _get_backups_register(self) -> BackupsRemoteList:

        file_list = self.list()
        # Check if backup_register.json exists in GDrive
        backup_register = next((x for x in file_list if x.name == self.backups_register_name), None)
        
        if backup_register:
            self.backups_register = backup_register
            rich.print("Backup register exists. Using it.")
            backup_register_id = backup_register.id
            request = self.g_drive_service.files().get_media(fileId=backup_register_id)
            # Parse as BackupsRemoteList
            data = io.BytesIO()
            downloader=MediaIoBaseDownload(data, request)
            done=False
            while done is False:
                status, done=downloader.next_chunk()
            data.seek(0)
            json_data = data.read().decode('utf-8')
            backup_register = BackupsRemoteList.model_validate_json(json_data)
            return backup_register
        else:
            rich.print("Backup register does not exist. Creating it.")
            return self._create_backup_register()

    def _update_backups_register(self, backups_register: BackupsRemoteList):
        rich.print("Updating backup register")
        backup_register_data = backups_register.model_dump_json(indent=4)
        with open('backup_register.json', 'w') as json_file:
            json_file.write(backup_register_data)
        
        media_body = MediaFileUpload('backup_register.json', mimetype='application/json') 
        if self.backups_register is not None:
            print("Updating backup register")
            file = self.g_drive_service.files().update(fileId=self.backups_register.id, media_body=media_body, fields='id').execute()

        Path('backup_register.json').unlink()
        return backups_register
    
    # CRUDL operations

    def create(self, file_path: Path) -> Backup:
        file_metadata={
            'name':file_path.name,
            'parents':['1-M5m228rrmRNn9zKWap6bV0Qy2nD-Q9R'],
            'mimeType':'application/octet-stream',
            'description':'Backup de logs de la aplicacion de finanzas'
            }
        media_body=MediaFileUpload(file_path)
        file=self.g_drive_service.files().create(body=file_metadata, media_body=media_body, fields=Backup.get_fields()).execute()
        return Backup(**file)

    def read(self, file_id: str) -> Backup:
        file = self.g_drive_service.files().get(fileId=file_id, fields=Backup.get_fields()).execute()
        return Backup(**file)
    
    def update(self, file_id: str, file_path: Path):
        """Overwrite file with file_id with file_path."""
        media_body=MediaFileUpload(file_path)
        file=self.g_drive_service.files().update(fileId=file_id, media_body=media_body, fields=Backup.get_fields()).execute()
        return Backup(**file)

    def delete(self, file_id: str):
        backups_register = self._get_backups_register()
        try:
            file = self.g_drive_service.files().delete(fileId=file_id).execute()
        except Exception as e:
            rich.print(e)
            return
        
        # Remove file from backups_register
        for item in backups_register.items:
            for backup in item.backups:
                if backup.id == file_id:
                    item.backups.remove(backup)
                    break
        # Update backups_register
        self._update_backups_register(backups_register)
        return

    def list(self) -> list[Backup]:
        selected_fields="files(id,name,webViewLink,createdTime)"
        list_file=self.g_drive_service.files().list(fields=selected_fields).execute()
        files: list[Backup] = [Backup(**file) for file in list_file.get("files")]
        return files

    # Custom operations

    def downloadFile(self, file_id: str, file_path: Path):
        request=self.g_drive_service.files().get_media(fileId=file_id)
        fh=Path(file_path).open('wb')
        downloader=MediaIoBaseDownload(fh, request)
        done=False
        while done is False:
            status, done=downloader.next_chunk()

    def uploadFile(self, file_path: Path) -> Backup:
        if not file_path.exists():
            raise FileNotFoundError(f"File {file_path} not found.")
        
        files_list = self.list()
        if file_path.name in [file.name for file in files_list]:
            rich.print(f"File {file_path.name} exists in GDrive. Updating it.")
            file_id = next((x.id for x in files_list if x.name == file_path.name), None)
            return self.update(file_id, file_path)
        else:
            rich.print(f"File {file_path.name} does not exist in GDrive. Creating it.")
            return self.create(file_path)

    def getRemoteBackupList(self) -> BackupsRemoteList:
        return self._get_backups_register()
