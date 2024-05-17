import UIKit

extension UIAlertController {
    
    static func showError(message: String, in viewController: UIViewController) {
        let alertController = UIAlertController(title: LocalizationProvider.localizedString(forKey: "Error"), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}
