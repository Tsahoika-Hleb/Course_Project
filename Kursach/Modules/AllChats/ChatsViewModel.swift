import UIKit

final class ChatsViewModel {
    
    // MARK: - Private properties
    
    private let databaseManager = DatabaseManager.shared
    private let storageManager = StorageManager.shared
    
    private var allChats: [Chat] = [] {
        didSet {
            bindChats()
        }
    }
    private var allUsers: [ChatUser] = []
    
    // MARK: - Internal properties
    
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
    
    var bindChats : (() -> ()) = {}
    var bindSearchedUser : (() -> ()) = {}
    
    // MARK: - Private methods
    
    private func loadChats() {
        databaseManager.getAllChats { result in
            switch result {
            case let .success(chats):
                self.allChats = chats
                print("fetchImages")
                self.fetchImages()
            case let .failure(error):
                self.allChats = []
                print(error)
            }
        }
    }
    
    private func fetchImages() {
        for i in 0..<allChats.count {
            print(allChats[i])
            databaseManager.fetchUsers(in: allChats[i].id) { result in
                switch result {
                case let .success(users):
                    let withUser = users.first(where: { $0 != CurrentUser.safeEmail }) ?? ""
                    self.databaseManager.fetchUserImage(userMail: withUser) { result in
                        switch result {
                        case let .success(imageUrl):
                            guard !imageUrl.isEmpty else { return }
                            self.storageManager.fetchImage(from: imageUrl) { result in
                                switch result {
                                case let .success(imageData):
                                    print(i)
                                    let chatInAllChats = self.allChats[i]
                                    self.allChats[i] = Chat(
                                        id: chatInAllChats.id,
                                        name: chatInAllChats.name,
                                        lastMessage: chatInAllChats.lastMessage,
                                        timestamp: chatInAllChats.timestamp,
                                        unreadMessagesCount: chatInAllChats.unreadMessagesCount,
                                        image: imageData
                                    )
                                case let .failure(error):
                                    print(error)
                                }
                            }
                        case let .failure(error):
                            print(error)
                        }
                    }
                case let .failure(error):
                    print(error)
                }
            }
        }
    }
    
    // MARK: - Internal methods
    func fetchAllData() {
        loadChats()
        
        databaseManager.fetchAllUsers { users in
            self.allUsers = users
            
            let group = DispatchGroup()
            
            var resultUsers: [ChatUser] = []
            for user in users {
                group.enter()
                let mail = user.safeEmail
                self.databaseManager.fetchUserImage(userMail: mail) { result in
                    switch result {
                    case let .success(imageUrl):
                        guard !imageUrl.isEmpty else {
                            resultUsers.append(user)
                            group.leave()
                            return
                        }
                        
                        self.storageManager.fetchImage(from: imageUrl) { result in
                            switch result {
                            case let .success(imageData):
                                resultUsers.append(ChatUser(
                                    username: user.username,
                                    email: user.email,
                                    profileImage: imageData
                                ))
                            case let .failure(error):
                                print(error)
                            }
                            group.leave()
                        }
                        
                    case let .failure(error):
                        print(error)
                        group.leave()
                    }
                }
            }
            
            group.notify(queue: .main) {
                self.allUsers = resultUsers
            }
        }
    }
    
    func findUsers(with namePrefix: String) {
        searchedUsers = allUsers.filter({ user in
            user.username.lowercased().hasPrefix(namePrefix.lowercased())
        })
    }
}
