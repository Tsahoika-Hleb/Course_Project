import Foundation

// URL http method type.
enum HTTPMethod: String {
    case delete = "DELETE"
    case get = "GET"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
}

protocol APIEndpoint {
    var baseURL: String { get }
    var path: String { get }
    var port: Int? { get }
    var parameters: [URLQueryItem] { get }
    var method: HTTPMethod { get }
    var authToken: String? { get }
    var body: Data { get }
}

enum APIModel: APIEndpoint, Equatable {
    case analyzeComment(text: String)
    
    var baseURL: String {
        switch self {
        case .analyzeComment:
            return "commentanalyzer.googleapis.com"
        }
    }

    var path: String {
        switch self {
        case .analyzeComment:
            return "/v1alpha1/comments:analyze"
        }
    }

    var port: Int? {
        nil
    }

    var parameters: [URLQueryItem] {
        switch self {
        case .analyzeComment:
            return [
                URLQueryItem(name: "key",
                             value: "AIzaSyBoC5t3tYIZ5_mOMYy9B50uJQHzvl41thY")
            ]
        }
    }

    var method: HTTPMethod {
        switch self {
        case .analyzeComment:
            return .post
        }
    }

    var authToken: String? {
        nil
    }
    
    var body: Data {
        switch self {
        case .analyzeComment(let text):
            let analyzeRequest = [
                "comment": ["text": text],
                "requestedAttributes": ["TOXICITY": [:]]
            ]
            var data = Data()
            do {
                data = try JSONSerialization.data(withJSONObject: analyzeRequest, options: [])
            } catch {
                debugPrint("Error serializing JSON: \(error)")
            }
            return data
        }
    }
}
