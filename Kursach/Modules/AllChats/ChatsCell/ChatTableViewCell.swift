import UIKit
import SnapKit

private enum Constants {
    static let profileImageSize: CGFloat = 50.0
    static let profileImageCornerRadius: CGFloat = 25.0
    static let labelFontSize: CGFloat = 16.0
    static let lastMessageFontSize: CGFloat = 14.0
    static let timestampFontSize: CGFloat = 12.0
    static let unreadMessagesLabelFontSize: CGFloat = 12.0
    static let unreadMessagesLabelCornerRadius: CGFloat = 12.5
    static let padding: CGFloat = 15.0
    static let spacing: CGFloat = 5.0
}

final class ChatTableViewCell: UITableViewCell {
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = Constants.profileImageCornerRadius
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "person.circle")
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Constants.labelFontSize)
        return label
    }()
    
    private let lastMessageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.lastMessageFontSize)
        label.textColor = .gray
        return label
    }()
    
    private let timestampLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.timestampFontSize)
        label.textColor = .gray
        return label
    }()
    
    private let unreadMessagesCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.unreadMessagesLabelFontSize)
        label.textColor = .white
        label.backgroundColor = .systemBlue
        label.textAlignment = .center
        label.layer.cornerRadius = Constants.unreadMessagesLabelCornerRadius
        label.clipsToBounds = true
        return label
    }()
    
    // MARK: - Lyfecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func setupViews() {
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(lastMessageLabel)
        addSubview(timestampLabel)
        addSubview(unreadMessagesCountLabel)
        
        profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Constants.padding)
            make.centerY.equalToSuperview()
            make.size.equalTo(Constants.profileImageSize)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(Constants.padding)
            make.top.equalToSuperview().inset(Constants.padding)
            make.trailing.equalTo(unreadMessagesCountLabel.snp.leading).offset(-Constants.padding)
        }
        
        lastMessageLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(Constants.spacing)
            make.trailing.equalToSuperview().inset(Constants.padding)
        }
        
        timestampLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(Constants.padding)
            make.top.equalTo(nameLabel)
        }
        
        unreadMessagesCountLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(Constants.padding)
            make.bottom.equalToSuperview().inset(Constants.padding)
            make.size.equalTo(Constants.profileImageSize / 2)
        }
    }
    
    // MARK: - Configure
    func configure(with chat: Chat) {
        nameLabel.text = chat.name
        lastMessageLabel.text = chat.lastMessage
        timestampLabel.text = DateFormatter.localizedString(
            from: chat.timestamp,
            dateStyle: .short,
            timeStyle: .short
        )
        unreadMessagesCountLabel.text = chat.unreadMessagesCount > 0 ? "\(chat.unreadMessagesCount)" : nil
        unreadMessagesCountLabel.isHidden = chat.unreadMessagesCount == 0
    }
}
