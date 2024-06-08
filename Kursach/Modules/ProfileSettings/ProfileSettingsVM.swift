import Foundation

final class ProfileSettingsVM {
    
    // MARK: - Private properties
    
    private let databaseManager = DatabaseManager.shared
    private let authManager = AuthManager.shared
    
    // MARK: - Iternal properties
    
    var currentUser: ChatUser? {
        didSet {
            updateFields()
        }
    }
    
    var updateFields : (() -> ()) = {}
    
    // MARK: - Iternal methods
    
    func setCurrentUser() {
        databaseManager.fetchUsername(userMail: CurrentUser.safeEmail) { result in
            switch result {
            case let .success(username):
                self.currentUser = ChatUser(username: username, email: CurrentUser.email ?? "")
            case let .failure(error):
                print(error)
                fatalError()
            }
        }
    }
    
    func signOut(completion: @escaping (Result<Void, any Error>) -> Void) {
        authManager.signOut { result in
            completion(result)
        }
    }
}
