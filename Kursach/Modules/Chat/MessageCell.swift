import UIKit
import SnapKit

private enum Constants {
    static let bubbleCornerRadius: CGFloat = 12
    static let messageFontSize: CGFloat = 16
    static let timeFontSize: CGFloat = 12
    static let bubbleMaxWidth: CGFloat = 300
    static let bubblePadding: CGFloat = 16
    static let cellPadding: CGFloat = 8
    static let timeLabelTopOffset: CGFloat = 4
    static let timeLabelTrailingOffset: CGFloat = 16
}

final class MessageCell: UITableViewCell {
    
    // MARK: - UI Properties
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: Constants.messageFontSize)
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: Constants.timeFontSize)
        //        label.text = "00:00"
        label.textColor = .gray
        return label
    }()
    
    private lazy var bubbleBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = Constants.bubbleCornerRadius
        view.layer.masksToBounds = true
        return view
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    private func setup() {
        contentView.addSubview(bubbleBackgroundView)
        bubbleBackgroundView.addSubview(messageLabel)
        bubbleBackgroundView.addSubview(timeLabel)
        
        bubbleBackgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.cellPadding)
            make.bottom.equalToSuperview().offset(-Constants.cellPadding)
            make.width.lessThanOrEqualTo(Constants.bubbleMaxWidth)
        }

        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(bubbleBackgroundView).offset(Constants.bubblePadding)
            make.leading.equalTo(bubbleBackgroundView).offset(Constants.bubblePadding)
            make.trailing.equalTo(bubbleBackgroundView).offset(-Constants.bubblePadding)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(Constants.timeLabelTopOffset)
            make.trailing.equalTo(bubbleBackgroundView).offset(-Constants.timeLabelTrailingOffset)
            make.bottom.equalTo(bubbleBackgroundView).offset(-Constants.bubblePadding)
        }
    }
    
    // MARK: - Internal
    func configure(with message: Message) {
        messageLabel.text = message.text
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        timeLabel.text = dateFormatter.string(from: message.timestamp)
        
        let currentUser = ChatUser.init(username: "test2", email: "test2")
        
        if message.sendBy.email == currentUser.email {
            bubbleBackgroundView.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
            messageLabel.textColor = .black
            bubbleBackgroundView.snp.remakeConstraints { make in
                make.top.equalToSuperview().offset(Constants.cellPadding)
                make.bottom.equalToSuperview().offset(-Constants.cellPadding)
                make.width.lessThanOrEqualTo(Constants.bubbleMaxWidth)
                make.trailing.equalToSuperview().offset(-Constants.cellPadding)
                make.leading.greaterThanOrEqualToSuperview().offset(100)
            }
        } else {
            bubbleBackgroundView.backgroundColor = UIColor(red: 0.8, green: 0.9, blue: 1.0, alpha: 1.0)
            messageLabel.textColor = .black
            bubbleBackgroundView.snp.remakeConstraints { make in
                make.top.equalToSuperview().offset(Constants.cellPadding)
                make.bottom.equalToSuperview().offset(-Constants.cellPadding)
                make.width.lessThanOrEqualTo(Constants.bubbleMaxWidth)
                make.leading.equalToSuperview().offset(Constants.cellPadding)
                make.trailing.lessThanOrEqualToSuperview().offset(-100)
            }
        }
    }
}
