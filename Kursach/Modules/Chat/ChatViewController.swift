import UIKit
import SnapKit

private enum Constraints {
    static let messageInputContainerHeight: CGFloat = 50
    static let buttonDimension: CGFloat = 40
    static let buttonOffset: CGFloat = 8
}

final class ChatViewController: UIViewController {
    
    // MARK: - Private Properties
    private let viewModel: ChatViewModel
    
    // MARK: - UI Properties
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.backgroundColor = .white
        
        tableView.register(MessageCell.self, forCellReuseIdentifier: "MessageCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        return tableView
    }()
    
    private var messageInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .chatBarsColor
        return view
    }()
    
    private var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите сообщение..."
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        return button
    }()
    
    private lazy var attachButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "paperclip")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(attachImage), for: .touchUpInside)
        return button
    }()
    
    private lazy var interlocutorAvatar: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "person.circle")
        return imageView
    }()
    
    // MARK: LyfeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private methods
    private func setup() {
        
        // TODO: Bind with vm
        
        navigationItem.title = "Имя Человека"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(goBack)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: interlocutorAvatar)

        view.backgroundColor = .chatBarsColor
        
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        view.addSubview(messageInputContainerView)
        
        messageInputContainerView.addSubview(inputTextField)
        messageInputContainerView.addSubview(sendButton)
        messageInputContainerView.addSubview(attachButton)
    }

    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.bottom.equalTo(messageInputContainerView.snp.top)
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
        }
        
        messageInputContainerView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(Constraints.messageInputContainerHeight)
        }
        
        attachButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Constraints.buttonOffset)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(Constraints.buttonDimension)
        }
        
        sendButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-Constraints.buttonOffset)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(Constraints.buttonDimension)
        }
        
        inputTextField.snp.makeConstraints { make in
            make.left.equalTo(attachButton.snp.right).offset(Constraints.buttonOffset)
            make.right.equalTo(sendButton.snp.left).offset(-Constraints.buttonOffset)
            make.centerY.equalToSuperview()
        }
    }

    
    @objc private func sendMessage() {
        print("Сообщение отправлено: \(inputTextField.text ?? "")")
        inputTextField.text = ""
        
        viewModel.messages.insert(
            Message(
                text: "Привет! Как дела?",
                sendBy: .init(username: "test2", email: "test2"),
                timestamp: Date().addingTimeInterval(450)
            ),
            at: 0 
        )
        tableView.reloadData()
    }
    
    @objc private func attachImage() {
        print("Прикрепить изображение")
    }
    
    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }
}
 
// MARK: - UITableViewDelegate & UITableViewDataSource

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "MessageCell",
            for: indexPath
        ) as? MessageCell else {
            return UITableViewCell()
        }
        let message = viewModel.messages[indexPath.row]
        cell.configure(with: message)
        
        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        return cell
    }
}
