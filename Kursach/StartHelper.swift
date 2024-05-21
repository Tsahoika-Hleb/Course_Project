import UIKit
import FirebaseAuth

final class StartHelper {
    
    weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController? = nil) {
        self.navigationController = navigationController
    }
    
    func startApp() {
        guard let navigationController else { return }
        
        let authViewModel = AuthViewModel()
        let allChatsViewModel = ChatsViewModel()
        let coordinator = AppCoordinator(
            navigationController: navigationController,
            authViewModel: authViewModel,
            allChatsViewModel: allChatsViewModel
        )
        
        if FirebaseAuth.Auth.auth().currentUser == nil {
            coordinator.showLogInScreen()
        } else {
            coordinator.showAllChatsScreen()
            // TODO: Delete this
//            do {
//                try FirebaseAuth.Auth.auth().signOut()
//            } catch {
//                print(error)
//            }
        }
    }
}
