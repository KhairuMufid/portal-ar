namespace ArContentManager.Api.DTOs
{
    public class AssetCreateDTO
    {
        public string AppName { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public string Category { get; set; } = string.Empty;
        public float AssetSize { get; set; }
        public required IFormFile AssetFile { get; set; }
        public required IFormFile ThumnailFile { get; set; }
        public List<IFormFile>? Images { get; set; }
    }
}