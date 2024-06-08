import Foundation

final class ChatViewModel {
    
    // MARK: - Properties
    var chatName: String
    
    var messages: [Message] = [] {
        didSet {
            updateMessages()
        }
    }
    
    var updateMessages : (() -> ()) = {}
    
    // MARK: - Private properties
    private let databaseManager = DatabaseManager.shared
    private var id: String?
    private var chatUsersEmail: [String] = []
    
    // MARK: - Initialization
    init(chatName: String, id: String) {
        self.chatName = chatName
        self.id = id
        fetchUsers()
    }
    
    init(chatName: String, with chatUsersEmail: [String]) {
        self.chatName = chatName
        self.chatUsersEmail = chatUsersEmail
    }
    
    // MARK: - Private methods
    private func fetchUsers() {
        guard let id else { return }
        databaseManager.fetchUsers(in: id) { result in
            switch result {
            case let .success(users):
                self .chatUsersEmail = users
            case let .failure(error):
                print(error)
            }
        }
    }
    
    private func sendMessage(message: Message, id: String, completion: @escaping (Bool) -> Void) {
        messages.insert(message, at: 0)
        
        databaseManager.sendMessage(
            message,
            chatId: id,
            userEmails: chatUsersEmail,
            completion: completion
        )
    }
    
    // MARK: - Iternal properties
    func listenMessages() {
        guard let id else { return }
        databaseManager.getAllMessages(for: id) { result in
            switch result {
            case let .success(messages):
                self.messages = messages.sorted { $0.timestamp > $1.timestamp }
            case let .failure(error):
                print(error.localizedDescription)
                fatalError()
            }
        }
    }
    
    func sendMessage(_ text: String) {
        let message = Message(
            text: text,
            senderEmail: CurrentUser.safeEmail,
            timestamp: Date(),
            isRead: false
        )
        
        if let id {
            sendMessage(message: message, id: id, completion: { success in
                if !success {
                    fatalError()
                }
            })
        } else {
            let newChatId = UUID().uuidString
            id = newChatId
            sendMessage(message: message, id: newChatId, completion: { success in
                if success {
                    self.listenMessages()
                }
            })
        }
    }
}
