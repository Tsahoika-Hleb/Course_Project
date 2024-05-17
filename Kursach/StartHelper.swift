import UIKit
import FirebaseAuth

final class StartHelper {
    
    weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController? = nil) {
        self.navigationController = navigationController
    }
    
    func startApp() {
        guard let navigationController else { return }
        
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let viewModel = AuthViewModel()
            let coordinator = AuthNavigationCoordinator(
                navigationController: navigationController,
                viewModel: viewModel
            )
            coordinator.showLogInScreen()
        } else {
            // TODO: Show chat screen
            do {
                try FirebaseAuth.Auth.auth().signOut()
            } catch {
                print(error)
            }
        }
    }
}
