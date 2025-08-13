using ArContentManager.Models.Models;
using Microsoft.AspNetCore.Http;

namespace ArContentManager.Service.Services
{
    public interface IAssetService
    {
        Task<string> CreateAndUploadAssetAsync(
            Asset newAsset,
            IFormFile assetFile,
            IFormFile thumnailFile,
            List<IFormFile> images
            );
        Task<List<Asset>> GetAllAssetAsync();
    }
}