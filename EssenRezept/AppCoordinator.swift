import UIKit
import Navigation
import FeedFeature
import LoginFeature

final class AppCoordinator: @preconcurrency Coordinator {
    let window: UIWindow
    var navigationController: UINavigationController

    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []

    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    @MainActor
    func start() {
        showLogin()
    }

    @MainActor
    private func showLogin() {
        let coordinator = LoginCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)

        coordinator.delegate = self

        coordinator.start()
    }

    @MainActor
    private func showFeed() {
        let coordinator = FeedCoordinator(navigationController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.start()
    }

    private func remove(_ coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
}

extension AppCoordinator: @preconcurrency LoginCoordinatorDelegate {
    @MainActor
    func loginCoordinatorDidFinishLogin(_ coordinator: LoginCoordinator) {
        remove(coordinator)
        showFeed()
    }
}
