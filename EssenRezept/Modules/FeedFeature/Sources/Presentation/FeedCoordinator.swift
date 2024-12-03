import UIKit
import Navigation
import APIClient
import Persistence

/*
 Building screens (vc + vm) should be done in a Builder
 */
public final class FeedCoordinator: @preconcurrency Coordinator {
    public weak var parentCoordinator: Coordinator?
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    @MainActor public func start() {
        let vm = FeedViewModel(
            repository: RecipeRepository(
                apiClient: APIClient.shared,
                persistenceService: PersistenceService.shared
            )
        )
        let vc = FeedViewController(viewModel: vm)

        // This is new root, swipe away everything else.
        navigationController.setViewControllers([vc], animated: false)
    }
}
