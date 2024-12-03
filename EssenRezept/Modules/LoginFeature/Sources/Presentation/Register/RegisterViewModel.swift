import Foundation
import Navigation

protocol RegisterViewModelProtocol {
    var coordinator: LoginCoordinator? { get set }
    func registerTapped(email: String?, password: String?, confirmPassword: String?)
}

final class RegisterViewModel: RegisterViewModelProtocol {
    weak var coordinator: LoginCoordinator?

    init(coordinator: LoginCoordinator?) {
        self.coordinator = coordinator
    }

    func registerTapped(email: String?, password: String?, confirmPassword: String?) {
        // Validation logic should be executed first
        coordinator?.finish()
    }
}
