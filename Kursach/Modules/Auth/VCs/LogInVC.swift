import UIKit
import SnapKit

// MARK: - UI Constants
private enum UIConstants {
    static let textFieldHeight: CGFloat = 50
    static let buttonHeight: CGFloat = 50
    static let registerButtonHeight: CGFloat = 30
    
    static let topInset: CGFloat = 80
    static let horizontalInset: CGFloat = 20
    static let verticalSpacing: CGFloat = 20
    static let buttonTopSpacing: CGFloat = 40
    static let registerButtonBottomInset: CGFloat = 20
}

final class LoginViewController: UIViewController {
    
    //MARK: - Private properties
    private let viewModel: AuthViewModel?
    private let coordinator: AuthNavigationCoordinator?
    
    // MARK: - UI Components
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = AuthStrings.emailPlaceholder.localizedString
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.returnKeyType = .next
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = AuthStrings.passwordPlaceholder.localizedString
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.returnKeyType = .done
        return textField
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(AuthStrings.logInButton.localizedString, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .blue
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var registerButton: UIButton = {
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.blue,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let attributeString = NSMutableAttributedString(
            string: AuthStrings.registrationButton.localizedString,
            attributes: textAttributes
        )
        
        let button = UIButton(type: .system)
        button.setAttributedTitle(attributeString, for: .normal)
        button.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Lifecycle
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
        setupViews()
        setupConstraints()
        navigationItem.hidesBackButton = true
    }
    
    // MARK: - Setup
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(registerButton)
    }
    
    private func setupConstraints() {
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(UIConstants.topInset)
            make.leading.equalTo(view).offset(UIConstants.horizontalInset)
            make.trailing.equalTo(view).offset(-UIConstants.horizontalInset)
            make.height.equalTo(UIConstants.textFieldHeight)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(UIConstants.verticalSpacing)
            make.leading.equalTo(emailTextField.snp.leading)
            make.trailing.equalTo(emailTextField.snp.trailing)
            make.height.equalTo(UIConstants.textFieldHeight)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(UIConstants.buttonTopSpacing)
            make.leading.equalTo(emailTextField.snp.leading)
            make.trailing.equalTo(emailTextField.snp.trailing)
            make.height.equalTo(UIConstants.buttonHeight)
        }
        
        registerButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-UIConstants.registerButtonBottomInset)
            make.centerX.equalTo(view.snp.centerX)
            make.height.equalTo(UIConstants.registerButtonHeight)
        }
    }
    
    // MARK: - Actions
    @objc private func didTapLoginButton() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty
        else {
            UIAlertController.showError(message: AuthStrings.emptyFieldsAlert.localizedString,in: self)
            return
        }

        viewModel?.logIn(email: email, password: password) { result in
            switch result {
            case .success(let user):
                print("User: \(user.email ?? "")")
                // TODO: Go to chat screen
            case .failure(let error):
                UIAlertController.showError(message: error.localizedDescription, in: self)
            }
        }
    }
    
    @objc private func didTapRegisterButton() {
        coordinator?.showRegistrationScreen()
    }
}
