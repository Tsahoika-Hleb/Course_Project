struct ChatUser {
    let username: String
    let email: String
    // TODO: Add picture & UUID
    
    var safeEmail: String {
        var safeEmail = email
        safeEmail = safeEmail.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}
