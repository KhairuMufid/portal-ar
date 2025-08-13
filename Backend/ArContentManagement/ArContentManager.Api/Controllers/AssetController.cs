using ArContentManager.Api.DTOs;
using ArContentManager.Models.Models;
using ArContentManager.Service.Services;
using Microsoft.AspNetCore.Mvc;

namespace ArContentManager.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AssetController(IAssetService assetService) : ControllerBase
    {
        private readonly IAssetService _assetService = assetService;

        [HttpPost]
        [RequestSizeLimit(100 * 1024 * 1024)]
        public async Task<IActionResult> CreateAsset([FromForm] AssetCreateDTO dto)
        {
            if (dto.AssetFile == null || dto.ThumnailFile == null)
            {
                return BadRequest("Asset file and thumbnail are required.");
            }

            var asset = new Asset
            {
                AppName = dto.AppName,
                Description = dto.Description,
                AssetSize = dto.AssetSize,
                Category = dto.Category
            };

            var assetId = await _assetService.CreateAndUploadAssetAsync(
                asset,
                dto.AssetFile,
                dto.ThumnailFile,
                dto.Images ?? new List<IFormFile>()
            );

            return Ok(new { Id = assetId });

        }

        [HttpGet]
        public async Task<IActionResult> GetAllAsset()
        {
            var result = await _assetService.GetAllAssetAsync();

            return Ok(result);
        }

    }
}