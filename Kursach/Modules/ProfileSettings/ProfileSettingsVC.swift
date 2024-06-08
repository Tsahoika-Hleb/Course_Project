import UIKit
import SnapKit

// MARK: - Constants

private enum Constants {
    static let profileImageSize: CGFloat = 100
    static let topMargin: CGFloat = 20
    static let smallMargin: CGFloat = 10
    static let bigMargin: CGFloat = 20
    static let sideMargin: CGFloat = 20
    static let bottomMargin: CGFloat = 30
    static let buttonHeight: CGFloat = 50
    static let buttonCornerRadius: CGFloat = 10
}

class ProfileSettingsViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: ProfileSettingsVM
    private let coordinator: AppCoordinator
    
    // MARK: - UI Elements
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = Constants.profileImageSize / 2
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray // Placeholder background color
        return imageView
    }()
    
    private lazy var changePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change Photo", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemCyan
        button.layer.cornerRadius = Constants.buttonCornerRadius
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        button.addTarget(self, action: #selector(changePhotoTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.textColor = .black
        return label
    }()
    
    private lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        return textField
    }()
    
//    private lazy var passwordLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Password"
//        label.textColor = .black
//        return label
//    }()
    
//    private lazy var passwordTextField: UITextField = {
//        let textField = UITextField()
//        textField.borderStyle = .roundedRect
//        textField.isSecureTextEntry = true
//        return textField
//    }()
    
    private lazy var childModeLabel: UILabel = {
        let label = UILabel()
        label.text = "Child mode"
        label.textColor = .black
        return label
    }()
    
    private lazy var childModeSwitch: UISwitch = {
        let childSwitch = UISwitch()
        return childSwitch
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save Changes", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemCyan
        button.layer.cornerRadius = Constants.buttonCornerRadius
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViews()
        setupFields()
    }

    init(viewModel: ProfileSettingsVM, coordinator: AppCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupFields() {
        viewModel.setCurrentUser()
        
        viewModel.updateFields = { [weak self] in
            guard let self else { return }
            usernameTextField.text = viewModel.currentUser?.username
        }
        
        // TODO: Child mode
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Profile"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Back",
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        
        let quitButton = UIBarButtonItem(
            image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
            style: .done,
            target: self,
            action: #selector(quitButtonPressed)
        )
        quitButton.tintColor = .systemRed
        navigationItem.rightBarButtonItem = quitButton

    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(profileImageView)
        view.addSubview(changePhotoButton)
        view.addSubview(usernameLabel)
        view.addSubview(usernameTextField)
//        view.addSubview(passwordLabel)
//        view.addSubview(passwordTextField)
        view.addSubview(childModeLabel)
        view.addSubview(childModeSwitch)
        view.addSubview(saveButton)
        
        makeConstraints()
    }
    
    private func makeConstraints() {
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Constants.topMargin)
            make.centerX.equalTo(view)
            make.size.equalTo(Constants.profileImageSize)
        }
        
        changePhotoButton.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(Constants.smallMargin)
            make.centerX.equalTo(view)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(changePhotoButton.snp.bottom).offset(Constants.bigMargin)
            make.leading.equalTo(view).offset(Constants.sideMargin)
        }
        
        usernameTextField.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(Constants.smallMargin)
            make.leading.equalTo(view).offset(Constants.sideMargin)
            make.trailing.equalTo(view).offset(-Constants.sideMargin)
        }
        
//        passwordLabel.snp.makeConstraints { make in
//            make.top.equalTo(usernameTextField.snp.bottom).offset(Constants.bigMargin)
//            make.leading.equalTo(view).offset(Constants.sideMargin)
//        }
//        
//        passwordTextField.snp.makeConstraints { make in
//            make.top.equalTo(passwordLabel.snp.bottom).offset(Constants.smallMargin)
//            make.leading.equalTo(view).offset(Constants.sideMargin)
//            make.trailing.equalTo(view).offset(-Constants.sideMargin)
//        }
        
        childModeLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameTextField.snp.bottom).offset(Constants.bigMargin * 2)
            make.leading.equalTo(view).offset(Constants.sideMargin)
        }
        
        childModeSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(childModeLabel)
            make.leading.equalTo(childModeLabel.snp.trailing).offset(Constants.smallMargin)
            make.trailing.equalTo(view).offset(-Constants.sideMargin)
        }
        
        saveButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-Constants.bottomMargin)
            make.leading.equalTo(view).offset(Constants.sideMargin)
            make.trailing.equalTo(view).offset(-Constants.sideMargin)
            make.height.equalTo(Constants.buttonHeight)
        }
    }
    
    // MARK: - Actions
    
    @objc private func changePhotoTapped() {
        // Handle change photo action
    }
    
    @objc private func saveButtonTapped() {
        // Handle save button action
    }
    
    @objc private func backButtonTapped() {
        // Handle back button action
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func quitButtonPressed() {
        let alertController = UIAlertController(
            title: "Sign Out",
            message: "Are you sure you want to sign out",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.viewModel.signOut { result in
                switch result {
                case .success:
                    self.coordinator.signout()
                case let .failure(error):
                    UIAlertController.showError(message: error.localizedDescription, in: self)
                }
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(okAction)
        alertController.addAction(cancel)
        
        self.present(alertController, animated: true)
    }
}
