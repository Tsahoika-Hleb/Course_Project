//

enum AuthStrings: String {
    case emailPlaceholder = "EmailPlaceholder"
    case passwordPlaceholder = "PasswordPlaceholder"
    case logInButton = "LogInButton"
    case registrationButton = "RegisterButton"
    case emptyFieldsAlert = "EmptyFieldsAlert"
    case usernamePlaceholder = "UsernamePlaceholder"
    case confirmPasswordPlaceholder = "ConfirmPasswordPlaceholder"
    case passwordMismatchAlert = "PasswordMismatchAlert"
}

extension AuthStrings {
    var localizedString: String {
        LocalizationProvider.localizedString(forKey: rawValue)
    }
}
