using ArContentManager.Models.Models;
using MongoDB.Driver;

namespace ArContentManager.Repository.Repositories
{
    public class AssetRepository(IMongoDatabase database, string collectionName) : IAssetRepository
    {
        private readonly IMongoCollection<Asset> _assetCollection = database.GetCollection<Asset>(collectionName);

        public async Task<List<Asset>> GetAllAsync()
        {
            return await _assetCollection.Find(_ => true).ToListAsync();
        }

        public async Task AddAsync(Asset asset)
        {
            await _assetCollection.InsertOneAsync(asset);
        }
    }
}