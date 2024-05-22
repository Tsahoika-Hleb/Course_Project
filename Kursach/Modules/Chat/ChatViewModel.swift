import Foundation

final class ChatViewModel {
    
    var messages = [
        Message(text: "Привет!", sendBy: .init(username: "test1", email: "test1"), timestamp: Date()),
        Message(text: "Привет! Как дела?", sendBy: .init(username: "test2", email: "test2"), timestamp: Date().addingTimeInterval(100)),
        Message(text: "Все отлично, а у тебя? Куча куча текста здесь. \nПроверка на объемный текст", sendBy: .init(username: "test1", email: "test1"), timestamp: Date().addingTimeInterval(400))
    ]
}
