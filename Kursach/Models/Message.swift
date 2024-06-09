import Foundation

struct Message {
    let text: String
    let senderEmail: String
    let timestamp: Date
    let isRead: Bool
    let toxicity: Double
    
    var timestampString: String {
        let formater = DateFormatter()
        formater.dateStyle = .medium
        formater.timeStyle = .long
        formater.locale = .current
        return formater.string(from: timestamp)
    }
}

extension String {
    
    func dateFromTimestampString() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateFormat = "d MMMM yyyy г., HH:mm:ss 'GMT'Z"
        
        return dateFormatter.date(from: self)
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .long
//        formatter.locale = .current
//        
//        return formatter.date(from: self)
    }
}
