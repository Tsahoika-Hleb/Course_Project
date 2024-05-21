import UIKit

final class ChatsViewModel {
    
    private let databaseManager = DatabaseManager.shared
    
    private var allChats: [Chat] = [] {
        didSet {
            bindChats()
        }
    }
    private var allUsers: [ChatUser] = []
    
    var sortedChats: [Chat] {
        allChats.sorted { chat1, chat2 in
            chat1.timestamp > chat2.timestamp
        }
    }
    var searchedUsers: [ChatUser] = [] {
        didSet {
            bindSearchedUser()
        }
    }
    
    func fetchAllData() {
        // TODO: Set all chats
        loadChats()
        
        databaseManager.fetchAllUsers { users in
            self.allUsers = users
        }
    }
    
    var bindChats : (() -> ()) = {}
    var bindSearchedUser : (() -> ()) = {}
    
    private func loadChats() {
        // Загружаете чаты из источника данных (Firebase, API, локальные данные и т.д.)
        // Пример заполненных данных:
        allChats = [
            Chat(id: "1", name: "John Doe", lastMessage: "Hey, how are you?", timestamp: Date(), unreadMessagesCount: 2),
            Chat(id: "2", name: "Jane Smith", lastMessage: "Let's catch up later", timestamp: Date(), unreadMessagesCount: 0)
        ]
    }
    
    func findUsers(with namePrefix: String) {
        searchedUsers = allUsers.filter({ user in
            user.username.lowercased().hasPrefix(namePrefix.lowercased())
        })
    }
    
}
