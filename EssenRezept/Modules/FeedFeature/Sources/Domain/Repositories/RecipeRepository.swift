import Foundation
import Persistence
import APIClient

protocol RecipeRepositoryProtocol {
    var delegate: RecipeRepositoryDelegate? { get set }
    
    func fetchRecipes()
    func loadCachedRecipes()
}

protocol RecipeRepositoryDelegate: AnyObject {
    func repositoryDidFetch(_ recipes: [Recipe])
    func repositoryDidFailWith(_ error: Error)
}

/*
 Generally a repository should own logic which decides
 what is the source of truth and they way of loading data for i.e
 loads from cache and in background retrieves data from service;
 get data via service, persist data on disk and fetch it from disk and
 send it to interested party
 */

final class RecipeRepository: RecipeRepositoryProtocol {
    weak var delegate: RecipeRepositoryDelegate?
    
    private let apiClient: APIClientProtocol
    private let persistenceService: PersistenceServiceProtocol
    private let cacheFileName = "recipes_cache.json"
    private let apiKey = "API_KEY"
    
    init(apiClient: APIClientProtocol, persistenceService: PersistenceServiceProtocol) {
        self.apiClient = apiClient
        self.persistenceService = persistenceService
    }
    
    func fetchRecipes() {
        guard let url = URL(string: "https://api.spoonacular.com/recipes/complexSearch?apiKey=\(apiKey)&number=20&addRecipeInformation=true") else {
            delegate?.repositoryDidFailWith(APIClientError.invalidURL)
            return
        }
        
        // 1. Call apiClient.get(from: url)
        // 2.1 If successful - persist response to disk and report to delegate with data
        // 2.2 If failed - report to delegate about error
    }
    
    func loadCachedRecipes() {
        guard persistenceService.fileExists(cacheFileName) else {
            fetchRecipes()
            return
        }
        
        do {
            let data = try persistenceService.load(from: cacheFileName)
            let decoder = JSONDecoder()
            let recipes = try decoder.decode([Recipe].self, from: data)
            
            delegate?.repositoryDidFetch(recipes)
        } catch {
            delegate?.repositoryDidFailWith(error)
        }
    }
}
