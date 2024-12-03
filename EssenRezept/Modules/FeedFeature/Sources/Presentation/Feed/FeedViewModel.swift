import UIKit
import Combine

enum FeedViewState {
    case loading
    case success(recipes: [Recipe])
    case error(message: String)
}

protocol FeedViewModelProtocol {
    var state: AnyPublisher<FeedViewState, Never> { get }
    var cachedRecipes: [Recipe] { get }
    
    func viewDidLoad()
    func refreshRecipes()
}

final class FeedViewModel: FeedViewModelProtocol {
    private let repository: RecipeRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    private let statePublisher = CurrentValueSubject<FeedViewState, Never>(.loading)
    
    private(set) var cachedRecipes: [Recipe] = []
    
    var state: AnyPublisher<FeedViewState, Never> {
        statePublisher.eraseToAnyPublisher()
    }
    
    init(repository: RecipeRepositoryProtocol) {
        self.repository = repository
    }
    
    func viewDidLoad() {
        repository.loadCachedRecipes()
    }
    
    func refreshRecipes() {
        statePublisher.send(.loading)
        repository.fetchRecipes()
    }
}

extension FeedViewModel: RecipeRepositoryDelegate {
    func repositoryDidFetch(_ recipes: [Recipe]) {
        cachedRecipes = recipes
        statePublisher.send(.success(recipes: recipes))
    }
    
    func repositoryDidFailWith(_ error: Error) {
        statePublisher.send(.error(message: error.localizedDescription))
    }
}
