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
        loadChats()
        
        databaseManager.fetchAllUsers { users in
            self.allUsers = users
        }
    }
    
    var bindChats : (() -> ()) = {}
    var bindSearchedUser : (() -> ()) = {}
    
    private func loadChats() {
        databaseManager.getAllChats { result in
            switch result {
            case let .success(chats):
                self.allChats = chats
            case let .failure(error):
                self.allChats = []
                print(error)
            }
        }
    }
    
    func findUsers(with namePrefix: String) {
        searchedUsers = allUsers.filter({ user in
            user.username.lowercased().hasPrefix(namePrefix.lowercased())
        })
    }
    
}
