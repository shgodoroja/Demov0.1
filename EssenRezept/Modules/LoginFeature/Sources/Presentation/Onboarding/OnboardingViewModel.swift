import Foundation
import Navigation

protocol OnboardingViewModelProtocol {
    var coordinator: LoginCoordinator? { get set }

    func getStartedTapped()
}

class OnboardingViewModel: @preconcurrency OnboardingViewModelProtocol {
    weak var coordinator: LoginCoordinator?

    init(coordinator: LoginCoordinator) {
        self.coordinator = coordinator
    }

    @MainActor func getStartedTapped() {
        coordinator?.showLogin()
    }
}
