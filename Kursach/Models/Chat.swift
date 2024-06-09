import Foundation

struct Chat {
    let id: String
    let name: String
    let lastMessage: String
    let timestamp: Date
    let unreadMessagesCount: Int
    let image: Data?
}
