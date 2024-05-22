import UIKit

final class AppCoordinator {
    
    weak var navigationController: UINavigationController?
    private let authViewModel: AuthViewModel
    private let allChatsViewModel: ChatsViewModel

    init(
        navigationController: UINavigationController,
        authViewModel: AuthViewModel,
        allChatsViewModel: ChatsViewModel
    ) {
        self.navigationController = navigationController
        self.authViewModel = authViewModel
        self.allChatsViewModel = allChatsViewModel
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
        let loginViewController = LoginViewController(viewModel: authViewModel, coordinator: self)
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
        let registrationViewController = RegistrationViewController(viewModel: authViewModel, coordinator: self)
        navigationController?.pushViewController(registrationViewController, animated: false)
    }
    
    func showAllChatsScreen() {
        let allChatsVC = ChatsViewController(viewModel: allChatsViewModel, coordinator: self)
        navigationController?.setViewControllers([allChatsVC], animated: false)
    }
    
    func showChatScreen(with user: ChatUser) {
        let vm = ChatViewModel()
        let vc = ChatViewController(viewModel: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showProfileSettingsScreen() {
        let vc = ProfileSettingsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
