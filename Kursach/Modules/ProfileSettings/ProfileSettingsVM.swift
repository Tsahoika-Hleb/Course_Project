import Foundation

final class ProfileSettingsVM {
    
    private let databaseManager = DatabaseManager.shared
    private let authManager = AuthManager.shared
    
    func signOut(completion: @escaping (Result<Void, any Error>) -> Void) {
        authManager.signOut { result in
            completion(result)
        }
    }
}
