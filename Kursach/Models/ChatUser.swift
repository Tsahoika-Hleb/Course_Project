import FirebaseAuth

public class CurrentUser {
    static let email = FirebaseAuth.Auth.auth().currentUser?.email
    static var safeEmail: String {
        var safeEmail = CurrentUser.email ?? ""
        safeEmail = safeEmail.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}

struct ChatUser {
    let username: String
    let email: String
//    let pictureUrl: String?
    let profileImage: Data?
    // TODO: Add picture & UUID
    
    var safeEmail: String {
        var safeEmail = email
        safeEmail = safeEmail.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}
