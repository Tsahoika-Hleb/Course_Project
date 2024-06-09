import Foundation

final class ProfileSettingsVM {
    
    // MARK: - Private properties
    
    private let databaseManager = DatabaseManager.shared
    private let storageManager = StorageManager.shared
    private let authManager = AuthManager.shared
    
    // MARK: - Iternal properties
    
    var currentUser: ChatUser? {
        didSet {
            updateFields()
        }
    }
    
    var updateFields : (() -> ()) = {}
    
    // MARK: - Iternal methods
    
    func setupChildMode(isOn: Bool) {
        UserDefaults.standard.set(isOn, forKey: "childMode")
    }
    
    func uploadImage(imageData: Data) {
        storageManager.uploadProfilePicture(data: imageData) { result in
            switch result {
            case let .success(pictureUrl):
                self.databaseManager.setUserImage(
                    pictureUrl: pictureUrl,
                    userMail: CurrentUser.safeEmail) { uploaded in
                        if !uploaded {
                            print("Picture didn't upload")
                        }
                    }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func setCurrentUser() {
        databaseManager.fetchUserInfo(userMail: CurrentUser.safeEmail) { result in
            switch result {
            case let .success(user):
                self.currentUser = user
                self.fetchImage()
            case let .failure(error):
                print(error)
                fatalError()
            }
        }
    }
    
    private func fetchImage() {
        guard let currentUser else { return }
        databaseManager.fetchUserImage(userMail: currentUser.safeEmail) { result in
            switch result {
            case let .success(imageUrl):
                guard !imageUrl.isEmpty else { return }
                self.storageManager.fetchImage(from: imageUrl) { result in
                    switch result {
                    case let .success(imageData):
                        let curUser = currentUser
                        self.currentUser = ChatUser(
                            username: curUser.username,
                            email: curUser.email,
                            profileImage: imageData
                        )
                    case .failure(let failure):
                        print(failure)
                    }
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func signOut(completion: @escaping (Result<Void, any Error>) -> Void) {
        authManager.signOut { result in
            completion(result)
        }
    }
}
