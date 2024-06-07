import Foundation

final class ChatViewModel {
    
    // MARK: - Properties
    var messages: [Message] = []
    
    // MARK: - Private properties
    private let databaseManager = DatabaseManager.shared
    private var id: String?
    private var chatUsersEmail: [String] = []
    
    // MARK: - Initialization
    init(id: String) {
        self.id = id
        // TODO: Fetch chat users
    }
    
    init(with chatUsersEmail: [String]) {
        self.chatUsersEmail = chatUsersEmail
    }
    
    // MARK: - Private methods
    private func loadMessages() {
        guard let id else { return }
        databaseManager.getAllMessages(for: id) { result in
            switch result {
            case let .success(messages):
                self.messages = messages
            case let .failure(error):
                print(error.localizedDescription)
                fatalError()
            }
        }
    }
    
    private func sendMessage(message: Message, id: String) {
        messages.insert(message, at: 0)
        
        databaseManager.sendMessage(
            message,
            chatId: id,
            userEmails: chatUsersEmail
        ) { wasSent in
            if !wasSent {
                print("Some error")
            }
        }
    }
    
    // MARK: - Iternal properties
    func sendMessage(_ text: String) {
        let message = Message(
            text: text,
            senderEmail: CurrentUser.safeEmail,
            timestamp: Date(),
            isRead: false
        )
        
        if let id {
            sendMessage(message: message, id: id)
        } else {
            let newChatId = UUID().uuidString
            id = newChatId
            sendMessage(message: message, id: newChatId)
        }
    }
}


//    var messages = Array([
//        Message(text: "Привет!", sendBy: .init(username: "test1", email: "test1"), timestamp: Date(), isRead: true),
//        Message(text: "Привет! Как дела?", sendBy: .init(username: "test2", email: "test2"), timestamp: Date().addingTimeInterval(100), isRead: true),
//        Message(text: "Все отлично, а у тебя? Куча куча текста здесь. \nПроверка на объемный текст", sendBy: .init(username: "test1", email: "test1"), timestamp: Date().addingTimeInterval(400), isRead: true)
//    ].reversed())
