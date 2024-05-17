import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    private let database = Database.database().reference()
}
 

// MARK: - Account managment

extension DatabaseManager {
    
    /// Checks if the user already exists
    func userExists(with email: String,
                    complition: @escaping ((Bool) -> Void)) {
        database.child(email).observeSingleEvent(of: .value) { snapshot in
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
        database.child(user.email).setValue([
            "username": user.username
        ])
    }
}
