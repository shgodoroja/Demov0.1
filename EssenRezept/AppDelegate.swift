import UIKit
import Navigation
import FeedFeature
import LoginFeature

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var coordinator: AppCoordinator?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        coordinator = AppCoordinator(window: window!)
        coordinator?.start()

        return true
    }
}

