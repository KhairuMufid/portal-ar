using ArContentManager.Models.Models;

namespace ArContentManager.Repository.Repositories
{
    public interface IAssetRepository
    {
        Task<List<Asset>> GetAllAsync();
        Task AddAsync(Asset asset);
    }
}