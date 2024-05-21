import Foundation
import FirebaseDatabase

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
        database.child(user.safeEmail).setValue([
            "username": user.username
        ])
        
        
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
