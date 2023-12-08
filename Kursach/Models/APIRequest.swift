import Foundation

struct CommentAnalyzerRequest: Codable {
    let comment: CommentDetails
    let requestedAttributes: RequestedAttributes
    
    struct CommentDetails: Codable {
        let text: String
    }
    
    struct RequestedAttributes: Codable {
        let toxicity: [String: String]
        
        init() {
            self.toxicity = [:]
        }
    }
}
