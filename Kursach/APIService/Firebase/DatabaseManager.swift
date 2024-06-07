import Foundation
import FirebaseDatabase

enum DatabaseError: Error {
    case noChatWith(id: String)
}

extension DatabaseError {
    var localizedDescription: String {
        switch self {
        case let .noChatWith(id: id):
            return "Database doesn't contain chat with id: \(id)"
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
    
    /*
     func createNewChat(
     with user: ChatUser,
     firstMessage: Message,
     complition: @escaping (Bool) -> Void
     ) {
     let ref = database.child(CurrentUser.safeEmail)
     
     ref.observeSingleEvent(of: .value) { snapshot  in
     guard var userNode = snapshot.value as? [String:Any] else {
     complition(false)
     print("User not found")
     fatalError()
     }
     
     let newChatData = [
     "id": UUID().uuidString,
     "with_user_email": user.safeEmail,
     "latest_message": [
     "date": firstMessage.timestampString,
     "is_read": false,
     "text": firstMessage.text
     ]
     ]
     
     userNode["chat"] = [
     newChatData
     ]
     
     ref.setValue(userNode) { error, _ in
     guard error != nil else {
     print(error)
     complition(true)
     return
     }
     complition(false)
     }
     }
     }
     */
    
    /// Fetches all chats for current user
    func getAllChats(completion: @escaping (Result<[Chat], Error>) -> Void) {
        let currentUser = CurrentUser.safeEmail
        let userRef = database.child(currentUser)
        let chatsRef = database.child("chats")
        
        let group = DispatchGroup()
        var chats = [Chat]()
        
        userRef.child("chats").observeSingleEvent(of: .value) { snapshot in
            guard snapshot.exists(), let chatIDsData = snapshot.value as? [String: Any] else {
                return
            }
            
            let chatIDs = chatIDsData.keys.map { $0 }
            
            //            for (chatID, chatData) in chatIDsData {
            //                if let lastMessageData = chatData["lastMessage"] as? [String: Any],
            //                   let isRead = lastMessageData["is_read"] as? Bool,
            //                   let text = lastMessageData["text"] as? String,
            //                   let timestamp = lastMessageData["timestamp"] as? String {
            //                    lastMessage = text
            //                    timestamp = timestamp.dateFromTimestampString()
            //                }
            //            }
            
            for chatID in chatIDs {
                group.enter()
                var lastMessage = ""
                var timestamp = Date()
                
                chatsRef.child(chatID).child("users").observeSingleEvent(of: .value) { chatSnapshot in
                    guard snapshot.exists(), let usersData = snapshot.value as? [String] else {
                        fatalError()
                        return
                    }
                    
                    let users = usersData
                    let chatWith = users.first(where: { $0 != currentUser })
                    
                    guard let chatWith else {
                        fatalError()
                    }
                    
                    self.fetchUsername(userID: chatWith) { result in
                        switch result {
                        case let .success(username):
                            let chat = Chat(
                                id: chatID,
                                name: username,
                                lastMessage: lastMessage,
                                timestamp: timestamp,
                                unreadMessagesCount: 0 // TODO: Count unread messages
                            )
                            chats.append(chat)
                        case let .failure(error):
                            completion(.failure(error))
                        }
                        group.leave()
                    }
                }
            }
            
            group.notify(queue: .main) {
                completion(.success(chats))
            }
        }
    }
    
    // Function to fetch username
    func fetchUsername(userID: String, completion: @escaping (Result<String, Error>) -> Void) {
        database.child(userID).child("username").observeSingleEvent(of: .value) { snapshot in
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
        let ref = database.child("chats").child(chatId)
        
        ref.observeSingleEvent(of: .value) { snapshot in
            guard snapshot.exists(), let messagesData = snapshot.value as? [String: [String: Any]] else {
                completion(.failure(DatabaseError.noChatWith(id: chatId)))
                return
            }
            
            var messages: [Message] = []
            
            for (_, messageData) in messagesData.sorted(by: { $0.key < $1.key }) {
                if let isRead = messageData["is_read"] as? Bool,
                   let sender = messageData["sender"] as? String,
                   let text = messageData["text"] as? String,
                   let timestamp = messageData["timestamp"] as? String {
                    let message = Message(
                        text: text,
                        senderEmail: sender,
                        timestamp: timestamp.dateFromTimestampString() ?? Date(),
                        isRead: isRead
                    )
                    messages.append(message)
                }
            }
            
            completion(.success(messages))
        }
        
        /*
         ref.observeSingleEvent(of: .value) { snapshot in
         guard snapshot.exists() else {
         complition(.failure(DatabaseError.noChatWith(id: chatId)))
         return
         }
         guard let messageCollection = snapshot.value as? [[String:Any]] else {
         fatalError()
         }
         
         for message in messageCollection {
         if let sender = message["sender"],
         let text = message["text"],
         let timestamp = message["timestamp"],
         let isRead = message["is_read"] {
         messages.append(Message(
         text: text,
         senderEmail: sender,
         timestamp: timestamp.dateFromTimestampString() ?? Date(),
         isRead: isRead
         ))
         }
         }
         }*/
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
        
        ref.observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                let messageCount = snapshot.childrenCount
                ref.child("\(messageCount)").setValue(messageData) { error, _ in
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
                self.createChat(
                    id: chatId,
                    with: messageData,
                    userEmails: userEmails,
                    completion: completion
                )
                /// Add chat for all users
                for userEmail in userEmails {
                    let chatData: [String: Any] = [
                        "lastMessage": [
                            "is_read": false,
                            "text": message.text,
                            "timestamp": message.timestampString
                        ]
                    ]
                    self.addChatToUser(user: userEmail, chatId: chatId, chatData: chatData)
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
        ref.child("0").setValue(messageData) { error, _ in
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


/*
 let ref = database.child("chats")
 
 ref.observeSingleEvent(of: .value) { snapshot in
 guard var chatCollection = snapshot.value as? [[String:[String:Any]]] else {
 // Создаем структуру "chats" если ее нет
 ref.setValue([chatId : messageData]) { error, _ in
 guard let error else {
 complition(false)
 return
 }
 print(error)
 fatalError()
 }
 return
 }
 
 // Проверяем существует ли чат с переданным id
 let isChatExist = chatCollection.contains { collection in
 collection.contains { chatDict in
 chatDict.key == chatId
 }
 }
 
 if isChatExist {
 //                chatCollection.
 //                var chatMessagesCollection = chatCollection[chatId]
 chatCollection.first { collection in
 collection.first { chatDict in
 chatDict.key == chatId
 }
 }
 } else {
 // Создаем чат и добавляем в коллекция
 chatCollection.append([chatId : messageData])
 ref.setValue([chatId : messageData]) { error, _ in
 guard let error else {
 complition(false)
 return
 }
 print(error)
 fatalError()
 }
 }
 }
 
 
 
 //        database.child(chatId).observeSingleEvent(of: .value) { snapshot   in
 //            // if chat exists
 //            if var chatNode = snapshot.value as? [String:[String : Any]] {
 //                chatNode.append(contentsOf: messageData)
 //                database.child(chatId).setValue(chatNode)
 //            } else {
 //                self.createChat(
 //                    with: chatId,
 //                    with: message,
 //                    complition: complition
 //                )
 //            }
 //        }
 */
