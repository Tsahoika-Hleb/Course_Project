import UIKit

final class AuthNavigationCoordinator {
    
    weak var navigationController: UINavigationController?
    private let viewModel: AuthViewModel

    init(navigationController: UINavigationController, viewModel: AuthViewModel) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }
    
    func showLogInScreen() {
        if let viewControllers = navigationController?.viewControllers {
            for viewController in viewControllers {
                if let loginVC = viewController as? LoginViewController {
                    navigationController?.popToViewController(loginVC, animated: false)
                    return
                }
            }
        }
        let loginViewController = LoginViewController(viewModel: viewModel, coordinator: self)
        navigationController?.pushViewController(loginViewController, animated: false)
    }
    
    func showRegistrationScreen() {
        if let viewControllers = navigationController?.viewControllers {
            for viewController in viewControllers {
                if let registrationVC = viewController as? RegistrationViewController {
                    navigationController?.popToViewController(registrationVC, animated: false)
                    return
                }
            }
        }
        let registrationViewController = RegistrationViewController(viewModel: viewModel, coordinator: self)
        navigationController?.pushViewController(registrationViewController, animated: false)
    }
}
