import UIKit
import Navigation

public protocol LoginCoordinatorDelegate: AnyObject {
    func loginCoordinatorDidFinishLogin(_ coordinator: LoginCoordinator)
}

public final class LoginCoordinator: @preconcurrency Coordinator {
    public weak var parentCoordinator: Coordinator?
    public var navigationController: UINavigationController
    public var childCoordinators: [Coordinator] = []
    public weak var delegate: LoginCoordinatorDelegate?

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    @MainActor public func start() {
        showOnboarding()
    }

    @MainActor
    func showOnboarding() {
        let viewModel = OnboardingViewModel(coordinator: self)
        let viewController = OnboardingViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: false)
    }

    @MainActor
    func showLogin() {
        let viewModel = LoginViewModel(coordinator: self)
        let viewController = LoginViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }

    @MainActor
    func showRegister() {
        let viewModel = RegisterViewModel(coordinator: self)
        let viewController = RegisterViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }

    public func finish() {
        delegate?.loginCoordinatorDidFinishLogin(self)
    }
}
