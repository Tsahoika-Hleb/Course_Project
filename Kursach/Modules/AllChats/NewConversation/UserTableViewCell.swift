import UIKit

final class UserTableViewCell: UITableViewCell {
    
    // Создаем картинку для аватарки
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20  // Закругляем углы для аватарки
        imageView.image = UIImage(systemName: "person.circle")
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // Создаем метку для имени пользователя
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Добавляем элементы в contentView ячейки
        contentView.addSubview(avatarImageView)
        contentView.addSubview(userNameLabel)
        
        // Настраиваем Constraints (ограничения) для элементов
        NSLayoutConstraint.activate([
            // Настройка Constraints для avatarImageView
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 40),
            avatarImageView.heightAnchor.constraint(equalToConstant: 40),
            
            // Настройка Constraints для userNameLabel
            userNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10),
            userNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            userNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with user: ChatUser) {
//        self.avatarImageView.image = user.image
        self.userNameLabel.text = user.username
    }
}
