import UIKit
import SnapKit

private enum LayoutConstants {
    static let defaultInsets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    static let navBarHeight: CGFloat = 44
    static let textViewHeight: CGFloat = 150
}

final class ViewController: UIViewController {
    
    // MARK: - Properties
    private var viewModel : ApiViewModel
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "Toxicity - a rude, disrespectful, or unreasonable comment that is likely to make someone leave a discusion\n\nType some text:"
        
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .black
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    private lazy var messageTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.layer.cornerRadius = 15
        textView.layer.borderWidth = 0.7
        textView.backgroundColor = .white
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
        
        return textView
    }()
    
    private lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "result:"
        
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .black
        
        return label
    }()
    
    private lazy var navBar: UINavigationBar = {
        let navBar = UINavigationBar()
        let navItem = UINavigationItem(title: "Text Toxicity analyzer")
        navBar.setItems([navItem], animated: false)
        navBar.setBackgroundImage(UIImage(), for: .default)
        navBar.shadowImage = UIImage()
        navBar.isTranslucent = true
        return navBar
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.setupLAyouts()
        self.bindViews()
    }
    
    init(viewModel: ApiViewModel = ApiViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setup() {
        self.view.backgroundColor = .white
    }
    
    private func bindViews() {
        self.viewModel.bindEmployeeViewModelToController = {
            let toxity = (self.viewModel.empData?.attributeScores["TOXICITY"]?.summaryScore.value ?? -1) * 100
            self.resultLabel.text = "result: " + String(format: "%.2f", toxity) + "%"
            
            let color: UIColor = toxity < 25 ? .green : toxity < 50 ? UIColor.systemYellow : toxity < 75 ? .orange : toxity < 100 ? .red : .black
            self.messageTextView.textColor = color
        }
    }
    
    private func setupLAyouts() {
        self.view.addSubview(infoLabel)
        self.view.addSubview(messageTextView)
        self.view.addSubview(resultLabel)
        self.view.addSubview(navBar)
        
        navBar.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(LayoutConstants.navBarHeight)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(LayoutConstants.defaultInsets)
            make.bottom.equalTo(messageTextView.snp.top).inset(-LayoutConstants.defaultInsets.bottom)
        }
        
        messageTextView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(LayoutConstants.defaultInsets)
            make.height.equalTo(LayoutConstants.textViewHeight)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(messageTextView.snp.bottom).offset(LayoutConstants.defaultInsets.top)
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(LayoutConstants.defaultInsets)
        }
    }
    
    // MARK: - Methodes
    private func proccessText(text: String) {
        self.viewModel.callAPI(text: text)
    }
    
    // MARK: - Actions
    @objc private func tapDone(sender: Any) {
        let text = messageTextView.text ?? ""
        self.view.endEditing(true)
        if !text.isEmpty {
            self.proccessText(text: text)
        }
    }
}

