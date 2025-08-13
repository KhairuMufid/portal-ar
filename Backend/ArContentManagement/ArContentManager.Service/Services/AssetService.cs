using ArContentManager.Models.Models;
using ArContentManager.Repository.GDrive;
using ArContentManager.Repository.Repositories;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;

namespace ArContentManager.Service.Services
{
    public class AssetService(IAssetRepository assetRepository, GoogleDriveRepository googleDriveRepository, IConfiguration configuration) : IAssetService
    {
        private readonly IAssetRepository _assetRepository = assetRepository;
        private readonly GoogleDriveRepository _googleDriveRepository = googleDriveRepository;
        private readonly string _rootFolderId = configuration.GetSection("GoogleDriveSettings:RootFolderId").Value ??
                                                throw new InvalidOperationException("Google Drive Root Folder ID is not configured.");

        public async Task<string> CreateAndUploadAssetAsync(
            Asset newAsset,
            IFormFile assetFile,
            IFormFile thumnailFile,
            List<IFormFile> images
            )
        {
            var newFolderId = await _googleDriveRepository.CreateFolderAsync(newAsset.AppName, _rootFolderId);

            newAsset.AssetUrl = await _googleDriveRepository.UploadFileAsync(assetFile, newFolderId);

            newAsset.ThumbnailUrl = await _googleDriveRepository.UploadFileAsync(thumnailFile, newFolderId);

            if (images != null && images.Count > 0)
            {
                if (images.Count > 0) newAsset.ImgUrl1 = await _googleDriveRepository.UploadFileAsync(images[0], newFolderId);
                if (images.Count > 1) newAsset.ImgUrl2 = await _googleDriveRepository.UploadFileAsync(images[1], newFolderId);
                if (images.Count > 2) newAsset.ImgUrl3 = await _googleDriveRepository.UploadFileAsync(images[2], newFolderId);
                if (images.Count > 3) newAsset.ImgUrl4 = await _googleDriveRepository.UploadFileAsync(images[3], newFolderId);
            }

            newAsset.CreatedAt = DateTime.UtcNow;
            await _assetRepository.AddAsync(newAsset);

            return newAsset.Id;
        }

        public async Task<List<Asset>> GetAllAssetAsync()
        {
            return await _assetRepository.GetAllAsync();
        }
    }
}