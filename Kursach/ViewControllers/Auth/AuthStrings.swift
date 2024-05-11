//

enum AuthStrings: String {
    case emailPlaceholder = "EmailPlaceholder"
    case passwordPlaceholder = "PasswordPlaceholder"
    case logInButton = "LogInButton"
    case registrationButton = "RegisterButton"
}

extension AuthStrings {
    var localizedString: String {
        LocalizationProvider.localizedString(forKey: rawValue)
    }
}
