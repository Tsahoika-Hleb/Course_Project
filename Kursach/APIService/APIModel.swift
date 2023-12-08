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
    case processText(text: String)
    
    var baseURL: String {
        switch self {
        case .processText:
            return "commentanalyzer.googleapis.com"
        }
    }

    var path: String {
        switch self {
        case .processText:
            return "/v1alpha1/comments:analyze"
        }
    }

    var port: Int? {
        nil
    }

    var parameters: [URLQueryItem] {
        switch self {
        case .processText:
            return [
                URLQueryItem(name: "key",
                             value: "AIzaSyBoC5t3tYIZ5_mOMYy9B50uJQHzvl41thY")
            ]
        }
    }

    var method: HTTPMethod {
        switch self {
        case .processText:
            return .post
        }
    }

    var authToken: String? {
        nil
    }
    
    var body: Data {
        switch self {
        case .processText(let text):
            let analyzeRequest = CommentAnalyzerRequest(
                comment: CommentAnalyzerRequest.CommentDetails(text: text),
                requestedAttributes: CommentAnalyzerRequest.RequestedAttributes()
            )
            var data = Data()
            do {
                data = try JSONEncoder().encode(analyzeRequest)
                print("place 1")
                
            } catch {
                print("Error serializing JSON: \(error)")
            }
            print("place 2")
            return data
        }
    }
}
