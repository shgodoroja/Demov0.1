import Foundation
import Navigation

protocol LoginViewModelProtocol {
    var coordinator: LoginCoordinator? { get set }

    func loginTapped(email: String?, password: String?)
    func registerTapped()
}

final class LoginViewModel: @preconcurrency LoginViewModelProtocol {
    weak var coordinator: LoginCoordinator?

    init(coordinator: LoginCoordinator) {
        self.coordinator = coordinator
    }

    func loginTapped(email: String?, password: String?) {
        coordinator?.finish()
    }
    
    @MainActor func registerTapped() {
        coordinator?.showRegister()
    }


}
