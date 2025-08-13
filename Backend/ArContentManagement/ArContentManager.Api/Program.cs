using ArContentManager.Repository.GDrive;
using ArContentManager.Repository.Repositories;
using ArContentManager.Service.Services;
using MongoDB.Driver;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();

builder.Services.AddSingleton(sp =>
{
    var connectionString = builder.Configuration.GetSection("MongoDbSettings:ConnectionString").Value;
    var dbName = builder.Configuration.GetSection("MongoDbSettings:DatabaseName").Value;
    if (string.IsNullOrEmpty(connectionString) || string.IsNullOrEmpty(dbName))
    {
        throw new InvalidOperationException("MongoDB configuration is missing.");
    }

    var client = new MongoClient(connectionString);
    return client.GetDatabase(dbName);
});

builder.Services.AddSingleton(sp =>
{
    var credentialsFileName = builder.Configuration.GetSection("GoogleDriveSettings:CredentialPath").Value ?? "cred.json";
    var credentialsPath = Path.Combine(Directory.GetCurrentDirectory(), credentialsFileName);
    return new GoogleDriveRepository(credentialsPath);
});

builder.Services.AddScoped<IAssetRepository>(sp =>
{
    var database = sp.GetRequiredService<IMongoDatabase>();
    var collectionName = builder.Configuration.GetSection("MongoDbSettings:CollectionName").Value;

    if (string.IsNullOrEmpty(collectionName))
    {
        throw new InvalidOperationException("MongoDB Collection Name is not configured.");
    }

    return new AssetRepository(database, collectionName);
});

builder.Services.AddScoped<IAssetService, AssetService>();

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.MapControllers();

app.Run();
