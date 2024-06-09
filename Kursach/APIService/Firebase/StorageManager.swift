import FirebaseStorage

final class StorageManager {
    
    static let shared = StorageManager()
    private let storage = Storage.storage().reference()
    
    /// Upload profile picture
    func uploadProfilePicture(data: Data, completion: @escaping (Result<String, Error>) -> Void) {
        let ref = storage.child("profile_pictures/\(CurrentUser.safeEmail)")
        
        ref.putData(data, metadata: nil) { metadata, error in
            if let error {
                completion(.failure(error))
                return
            }
            
            ref.downloadURL { url, error in
                if let error {
                    completion(.failure(error))
                    return
                }
                
                guard let url else {
                    fatalError()
                }
                
                let urlString = url.absoluteString
                
                completion(.success(urlString))
            }
        }
    }
    
    /*
    /// Fetch profile picture for user
//    func fetchProfilePicture(userEmail: String, completion: @escaping (Result<Data, Error>) -> Void) {
//        let ref = storage.child("profile_pictures/\(userEmail)")
//        
//        ref.downloadURL { url, error in
//            guard error == nil else {
//                print(error)
//                return
//            }
//            guard let url else {
//                completion(.failure(StorageError.noImage))
//                return
//            }
//            
//            self.fetchImage(from: url, completion: completion)
//        }
//    }
//
//    private func fetchImage(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            guard let data else {
//                completion(.failure(NSError(domain: "DataError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to load image data."])))
//                return
//            }
//            
//            completion(.success(data))
//        }
//        
//        task.resume()
//    }
     */
    func fetchImage(from url: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let imageUrl = URL(string: url) else {
            completion(.failure(NSError(domain: "InvalidURL", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL string."])))
            return
        }
        
        let task = URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "DataError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to load image data."])))
                return
            }
            
            completion(.success(data))
        }
        
        task.resume()
    }
}

enum StorageError: Error {
    case noImage
}
