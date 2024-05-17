import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
//        window = UIWindow(windowScene: windowScene)
////        let viewController = ViewController()
//        let viewController = LoginViewController()
////        let viewController = RegistrationViewController()
//        window?.rootViewController = viewController
//        window?.makeKeyAndVisible()
        
        
        let navigationController = UINavigationController()
        let viewModel = AuthViewModel()
        let coordinator = AuthNavigationCoordinator(navigationController: navigationController, viewModel: viewModel)
        coordinator.showLogInScreen()

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

    }
}
