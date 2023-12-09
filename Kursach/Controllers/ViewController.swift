import UIKit
import SnapKit

private enum LayoutConstants {
    static let messageTextFieldHeight: CGFloat = 40
    static let messageTextFieldInsets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
}

final class ViewController: UIViewController {
    
    // MARK: - Properties
    private var viewModel : ApiViewModel
    
    private lazy var messageTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.placeholder = "Type any message..."
        
        textField.returnKeyType = .done
        textField.layer.borderWidth = 0.5
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.borderStyle = .roundedRect
        
        textField.delegate = self
        textField.autocapitalizationType = .none
        
        return textField
    }()
    
    private lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "result:"
        
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .green
        
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .gray
        self.setup()
        self.viewModel.bindEmployeeViewModelToController = {
            let toxity = self.viewModel.empData?.attributeScores["TOXICITY"]?.summaryScore.value ?? -1
            self.resultLabel.text = "result: "
            + String(format: "%.3f", toxity)
        }
    }
    
    init(viewModel: ApiViewModel = ApiViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layouts setup
    private func setup() {
        self.view.addSubview(messageTextField)
        self.view.addSubview(resultLabel)
        
        messageTextField.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide).inset(LayoutConstants.messageTextFieldInsets)
            make.height.equalTo(LayoutConstants.messageTextFieldHeight)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(view.safeAreaLayoutGuide).inset(LayoutConstants.messageTextFieldInsets)
            make.height.equalTo(LayoutConstants.messageTextFieldHeight)
        }
    }
    
    // MARK: - Methodes
    private func proccessText(text: String) {
        self.viewModel.callAPI(text: text)
    }
}

//MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            textField.resignFirstResponder()
            self.proccessText(text: text)
            return true
        } else {
            return false
        }
    }
}
