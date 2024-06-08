import Foundation
import FirebaseDatabase

enum DatabaseError: Error {
    case noChatWith(id: String)
    case invalidDataFormat
}

extension DatabaseError {
    var localizedDescription: String {
        switch self {
        case let .noChatWith(id: id):
            return "Database doesn't contain chat with id: \(id)"
        case .invalidDataFormat:
            return "Invalid data format"
        }
    }
}


final class DatabaseManager {
    
    static let shared = DatabaseManager()
    private let database = Database.database().reference()
}

// MARK: - Account managment

extension DatabaseManager {
    
    /// Checks if the user already exists
    func userExists(with user: ChatUser,
                    complition: @escaping ((Bool) -> Void)) {
        database.child(user.safeEmail).observeSingleEvent(of: .value) { snapshot in
            guard snapshot.value as? String != nil else {
                complition(false)
                return
            }
            
            // Found same email
            complition(true)
        }
    }
    
    /// Insert user into database
    func insert(user: ChatUser) {
        
        ///
        database.child(user.safeEmail).setValue([
            "username": user.username,
            "chats": [:]
        ])
        
        /// Insert into all users collection
        let userNode: [[String: String]] = [
            [
                "username": user.username,
                "email": user.safeEmail
            ]
        ]
        database.child("users").observeSingleEvent(of: .value) { snapshot in
            if var userCollection = snapshot.value as? [[String:String]] {
                userCollection.append(contentsOf: userNode)
                self.database.child("users").setValue(userCollection)
            } else {
                self.database.child("users").setValue(userNode)
            }
        }
    }
    
    func fetchAllUsers(complition: @escaping (([ChatUser]) -> Void)) {
        var users = [ChatUser]()
        
        database.child("users").observeSingleEvent(of: .value) { snapshot in
            if let userCollection = snapshot.value as? [[String:String]] {
                for user in userCollection {
                    if let name = user["username"], let email = user["email"] {
                        users.append(ChatUser(
                            username: name,
                            email: email)
                        )
                    }
                }
                complition(users)
            } else {
                fatalError()
            }
        }
    }
}

// MARK: - Messages&Chats managment

extension DatabaseManager {
    
    /// Fetches all chats for current user
    func getAllChats(completion: @escaping (Result<[Chat], Error>) -> Void) {
        let currentUser = CurrentUser.safeEmail
        let userRef = database.child(currentUser)
        
        userRef.child("chats").observe(.value) { snapshot in
            var chats = [Chat]()
            
            guard snapshot.exists(), let chatsData = snapshot.value as? [String: [String: Any]] else {
                return
            }
            
            for (chatId, chatData) in chatsData {
                if let name = chatData["name"] as? String,
                   let lastMessageDict = chatData["lastMessage"] as? [String: Any],
                   let isRead = lastMessageDict["is_read"] as? Bool,
                   let text = lastMessageDict["text"] as? String,
                   let timestamp = lastMessageDict["timestamp"] as? String {
                    let chat = Chat(
                        id: chatId,
                        name: name,
                        lastMessage: text,
                        timestamp: timestamp.dateFromTimestampString() ?? Date(),
                        unreadMessagesCount: isRead ? 1 : 0
                    )
                    chats.append(chat)
                } else {
                    fatalError()
                }
            }
            completion(.success(chats))
        }
    }
    
    func fetchUsers(in chatID: String, completion: @escaping (Result<[String], Error>) -> Void) {
        let ref = database.child("chats")
        ref.child(chatID).child("users").observe(.value) { snapshot in
            guard snapshot.exists(), let usersData = snapshot.value as? [String] else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No users"])))
                return
            }
            
            let users = usersData
            
            completion(.success(users))
        }
    }
    
    /// Function to fetch username
    func fetchUsername(userMail: String, completion: @escaping (Result<String, Error>) -> Void) {
        database.child(userMail).child("username").observeSingleEvent(of: .value) { snapshot in
            guard snapshot.exists(), let username = snapshot.value as? String else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Username not found"])))
                return
            }
            completion(.success(username))
        }
    }
    
    /// Fetches all messages for chat with some user
    func getAllMessages(
        for chatId: String,
        completion: @escaping (Result<[Message], Error>) -> Void
    ) {
        let ref = database.child("chats").child(chatId).child("messages")
        
        ref.observe(.value) { snapshot in
            var messages: [Message] = []
            
            for child in snapshot.children {
                guard let childSnapshot = child as? DataSnapshot,
                      let messageData = childSnapshot.value as? [String: Any],
                      let text = messageData["text"] as? String,
                      let sender = messageData["sender"] as? String,
                      let timestamp = messageData["timestamp"] as? String,
                      let isRead = messageData["is_read"] as? Bool else {
                    fatalError()
                }
                
                guard let timestamp = timestamp.dateFromTimestampString() else {
                    print(timestamp)
                    fatalError()
                }
                
                let message = Message(
                    text: text,
                    senderEmail: sender,
                    timestamp: timestamp,
                    isRead: isRead
                )
                messages.append(message)
            }
            
            print("Provide messages")
            completion(.success(messages))
        }
    }
    
    func sendMessage(
        _ message: Message,
        chatId: String,
        userEmails: [String],
        completion: @escaping (Bool) -> Void
    ) {
        var messageData: [String : Any] = [
            "timestamp": message.timestampString,
            "text": message.text,
            "is_read": message.isRead,
            "sender": message.senderEmail
        ]
        
        let ref = database.child("chats").child(chatId)
        
        ref.child("messages").observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                let messageCount = snapshot.childrenCount
                ref.child("messages").child("\(messageCount)").setValue(messageData) { error, _ in
                    if let error = error {
                        print("Failed to add message: \(error)")
                        completion(false)
                    } else {
                        completion(true)
                    }
                }
                /// Update last message in chat for all users
                let lastMessageData: [String: Any] = [
                    "is_read": false,
                    "text": message.text,
                    "timestamp": message.timestampString
                ]
                for userEmail in userEmails {
                    self.updateLastMessage(
                        user: userEmail,
                        chatId: chatId,
                        lastMessageData: lastMessageData
                    )
                }
            } else {
                /// Add chat for all users
                for userEmail in userEmails {
                    let chatWith = userEmails.first(where: { $0 != userEmail })
                    guard let chatWith else {
                        fatalError()
                    }
                    self.fetchUsername(userMail: chatWith) { result in
                        switch result {
                        case let .success(username):
                            let chatData: [String: Any] = [
                                "name": username,
                                "lastMessage": [
                                    "is_read": false,
                                    "text": message.text,
                                    "timestamp": message.timestampString
                                ]
                            ]
                            self.addChatToUser(user: userEmail, chatId: chatId, chatData: chatData)
                        case let .failure(error):
                            print(error)
                        }
                    }
                }
                /// Add users to chat
                let usersData = [
                    "users": userEmails
                ]
                ref.setValue(usersData) { error, _ in
                    if let error = error {
                        print("Error adding users to chat chat: \(error.localizedDescription)")
                    } else {
                        print("Users added successfully to chat")
                    }
                }
                self.createChat(
                    id: chatId,
                    with: messageData,
                    userEmails: userEmails,
                    completion: completion
                )
            }
        }
    }
    
    private func createChat(
        id: String,
        with messageData: [String : Any],
        userEmails: [String],
        completion: @escaping (Bool) -> Void
    ) {
        let ref = database.child("chats").child(id)
        
        /// Add new chat to all chats
        ref.child("messages").child("0").setValue(messageData) { error, _ in
            if let error = error {
                print("Failed to create chat: \(error)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    /// Add chat to user structer
    private func addChatToUser(
        user: String,
        chatId: String,
        chatData: [String: Any]
    ) {
        database.child(user).child("chats").child(chatId).setValue(chatData) { error, _ in
            if let error = error {
                print("Error adding chat: \(error.localizedDescription)")
            } else {
                print("Chat added successfully")
            }
        }
    }
    
    private func updateLastMessage(
        user: String,
        chatId: String,
        lastMessageData: [String: Any]
    ) {
        database.child(user).child("chats").child(chatId).child("lastMessage").updateChildValues(lastMessageData) { error, _ in
            if let error = error {
                print("Error updating last message: \(error.localizedDescription)")
            } else {
                print("Last message updated successfully")
            }
        }
    }
}
