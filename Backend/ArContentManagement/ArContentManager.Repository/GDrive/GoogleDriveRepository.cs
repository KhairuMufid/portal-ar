using Google.Apis.Auth.OAuth2;
using Google.Apis.Drive.v3;
using Google.Apis.Drive.v3.Data;
using Google.Apis.Services;
using Microsoft.AspNetCore.Http;

namespace ArContentManager.Repository.GDrive
{
    public class GoogleDriveRepository
    {
        private readonly DriveService _driveService;

        public GoogleDriveRepository(string credentialsPath)
        {
            GoogleCredential credential;
            using (var stream = new FileStream(credentialsPath, FileMode.Open, FileAccess.Read))
            {
                credential = GoogleCredential.FromStream(stream)
                    .CreateScoped(DriveService.Scope.DriveFile);
            }

            _driveService = new DriveService(new BaseClientService.Initializer()
            {
                HttpClientInitializer = credential,
                ApplicationName = "ArContentManager"
            });
        }

        public async Task<string> CreateFolderAsync(string folderName, string parentFolderId)
        {
            var fileMetadata = new Google.Apis.Drive.v3.Data.File()
            {
                Name = folderName,
                MimeType = "application/vnd.google-apps.folder",
                Parents = new List<string> { parentFolderId }
            };

            var request = _driveService.Files.Create(fileMetadata);
            request.Fields = "id";
            var file = await request.ExecuteAsync();
            return file.Id;
        }

        public async Task<string> UploadFileAsync(IFormFile file, string parentFolderId)
        {
            var fileMetadata = new Google.Apis.Drive.v3.Data.File()
            {
                Name = file.FileName,
                Parents = [parentFolderId]
            };

            FilesResource.CreateMediaUpload request;
            using (var stream = file.OpenReadStream())
            {
                request = _driveService.Files.Create(fileMetadata, stream, file.ContentType);
                request.Fields = "id";

                var uploadResult = await request.UploadAsync();

                if (uploadResult.Status != Google.Apis.Upload.UploadStatus.Completed)
                {
                    throw new InvalidOperationException($"File upload failed with status: {uploadResult.Status}. Exception: {uploadResult.Exception?.Message}");
                }
            }

            var fileId = request.ResponseBody?.Id;
            if (string.IsNullOrEmpty(fileId))
            {
                throw new InvalidOperationException("File upload failed. No file ID was returned.");
            }

            var permissions = new Permission
            {
                Role = "reader",
                Type = "anyone"
            };
            await  _driveService.Permissions.Create(permissions, fileId).ExecuteAsync();

            return $"https://drive.google.com/uc?export=download&id={fileId}";
        }
    }
}