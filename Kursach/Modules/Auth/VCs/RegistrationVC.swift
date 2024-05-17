import UIKit
import SnapKit

// MARK: - UI Constants
private enum UIConstants {
    static let textFieldHeight: CGFloat = 50
    static let buttonHeight: CGFloat = 50
    static let loginButtonHeight: CGFloat = 30
    
    static let topInset: CGFloat = 80
    static let horizontalInset: CGFloat = 20
    static let verticalSpacing: CGFloat = 20
    static let buttonTopSpacing: CGFloat = 40
    static let loginButtonBottomInset: CGFloat = 20
}

final class RegistrationViewController: UIViewController {
    
    //MARK: - Private properties
    private let viewModel: AuthViewModel?
    private let coordinator: AuthNavigationCoordinator?
    
    // MARK: - UI Elements
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = AuthStrings.usernamePlaceholder.localizedString
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.returnKeyType = .next
        return textField
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = AuthStrings.emailPlaceholder.localizedString
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.returnKeyType = .next
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = AuthStrings.passwordPlaceholder.localizedString
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.returnKeyType = .next
        return textField
    }()
    
    private let confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = AuthStrings.confirmPasswordPlaceholder.localizedString
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.returnKeyType = .done
        return textField
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(AuthStrings.registrationButton.localizedString, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .blue
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var loginButton: UIButton = {
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.blue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let attributeString = NSMutableAttributedString(
            string: AuthStrings.logInButton.localizedString,
            attributes: textAttributes
        )
        
        let button = UIButton(type: .system)
        button.setAttributedTitle(attributeString, for: .normal)
        button.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life Cycle
    init(viewModel: AuthViewModel, coordinator: AuthNavigationCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        navigationItem.hidesBackButton = true
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(usernameTextField)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(confirmPasswordTextField)
        view.addSubview(registerButton)
        view.addSubview(loginButton)
        
        usernameTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(UIConstants.topInset)
            make.leading.trailing.equalToSuperview().inset(UIConstants.horizontalInset)
            make.height.equalTo(UIConstants.textFieldHeight)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(usernameTextField.snp.bottom).offset(UIConstants.verticalSpacing)
            make.leading.trailing.equalToSuperview().inset(UIConstants.horizontalInset)
            make.height.equalTo(UIConstants.textFieldHeight)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(UIConstants.verticalSpacing)
            make.leading.trailing.equalToSuperview().inset(UIConstants.horizontalInset)
            make.height.equalTo(UIConstants.textFieldHeight)
        }
        
        confirmPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(UIConstants.verticalSpacing)
            make.leading.trailing.equalToSuperview().inset(UIConstants.horizontalInset)
            make.height.equalTo(UIConstants.textFieldHeight)
        }
        
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(UIConstants.buttonTopSpacing)
            make.leading.trailing.equalToSuperview().inset(UIConstants.horizontalInset)
            make.height.equalTo(UIConstants.buttonHeight)
        }
        
        loginButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-UIConstants.loginButtonBottomInset)
            make.centerX.equalTo(view.snp.centerX)
            make.height.equalTo(UIConstants.loginButtonHeight)
        }
    }
    
    // MARK: - Actions
    @objc private func didTapLoginButton() {
        coordinator?.showLogInScreen()
    }
    
    @objc private func didTapRegisterButton() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let username = usernameTextField.text, !username.isEmpty,
              let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty
        else {
            UIAlertController.showError(message: AuthStrings.emptyFieldsAlert.localizedString,in: self)
            return
        }
        
        guard confirmPassword == password else {
            UIAlertController.showError(message: AuthStrings.passwordMismatchAlert.localizedString,in: self)
            return
        }

        viewModel?.register(username: username, email: email, password: password) { result in
            switch result {
            case .success(let user):
                print("User registered: \(user.email ?? "")")
                // TODO: Go to chat screen
            case .failure(let error):
                UIAlertController.showError(message: error.localizedDescription, in: self)
            }
        }
    }
}
