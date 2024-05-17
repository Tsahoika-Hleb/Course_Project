import FirebaseAuth

class AuthViewModel {
    
    private let authManager = AuthManager.shared
    private let databaseManager = DatabaseManager.shared
    
    func logIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        authManager.logIn(email: email, password: password, completion: completion)
    }
    
    func register(
        username: String,
        email: String,
        password: String,
        completion: @escaping (Result<User, Error>) -> Void
    ) {
        let chatUser = ChatUser(username: username, email: email)
        databaseManager.userExists(with: chatUser) { isExist in
            if isExist {
                completion(.failure(AuthErrors.userAlreadyExists))
                return
            } else {
                self.registerNewUser(
                    chatUser: chatUser,
                    password: password,
                    completion: completion
                )
            }
        }
    }
    
    private func registerNewUser(
        chatUser: ChatUser,
        password: String,
        completion: @escaping (Result<User, Error>) -> Void
    ) {
        authManager.register(email: chatUser.email, password: password) { result in
            switch result {
            case .success(let user):
                self.databaseManager.insert(user: chatUser)
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

enum AuthErrors: Error {
    case userAlreadyExists
}

extension AuthErrors {
    var localizedDescription: String {
        switch self {
        case .userAlreadyExists:
            AuthStrings.userAlreadyExistError.localizedString
        }
    }
}
