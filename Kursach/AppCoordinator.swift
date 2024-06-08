import UIKit

final class AppCoordinator {
    
    weak var navigationController: UINavigationController?
    private var authViewModel: AuthViewModel
    private var allChatsViewModel: ChatsViewModel
    private var profileSettingsViewModel: ProfileSettingsVM

    init(
        navigationController: UINavigationController,
        authViewModel: AuthViewModel,
        allChatsViewModel: ChatsViewModel,
        profileSettingsViewModel: ProfileSettingsVM
    ) {
        self.navigationController = navigationController
        self.authViewModel = authViewModel
        self.allChatsViewModel = allChatsViewModel
        self.profileSettingsViewModel = profileSettingsViewModel
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
    
    func showChatScreen(with user: ChatUser, animated: Bool) {
        let currentUser = CurrentUser.safeEmail
        let vm = ChatViewModel(chatName: user.username, with: [user.safeEmail, currentUser])
        showChatScreen(vm: vm, animated: animated)
    }
    
    func showСhatScreen(name: String, chatId: String, animated: Bool) {
        let vm = ChatViewModel(chatName: name, id: chatId)
        showChatScreen(vm: vm, animated: animated)
    }
    
    private func showChatScreen(vm: ChatViewModel, animated: Bool) {
        let vc = ChatViewController(viewModel: vm)
        navigationController?.pushViewController(vc, animated: animated)
    }
    
    func showProfileSettingsScreen() {
        let vc = ProfileSettingsViewController(
            viewModel: profileSettingsViewModel,
            coordinator: self
        )
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func signout() {
        navigationController?.viewControllers = []
        authViewModel = AuthViewModel()
        allChatsViewModel = ChatsViewModel()
        profileSettingsViewModel = ProfileSettingsVM()
        showLogInScreen()
    }
}
