import UIKit

final class ChatsViewModel {
    
    private var chats: [Chat] = []
    
    var sortedChats: [Chat] {
        chats.sorted { chat1, chat2 in
            chat1.timestamp > chat2.timestamp
        }
    }
    
    func loadChats() {
        // Загружаете чаты из источника данных (Firebase, API, локальные данные и т.д.)
        // Пример заполненных данных:
        chats = [
            Chat(id: "1", name: "John Doe", lastMessage: "Hey, how are you?", timestamp: Date(), unreadMessagesCount: 2),
            Chat(id: "2", name: "Jane Smith", lastMessage: "Let's catch up later", timestamp: Date(), unreadMessagesCount: 0)
        ]
    }
    
    
}
