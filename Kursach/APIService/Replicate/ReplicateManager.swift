//import Replicate
//
//let securedToken = "r8_dgkF0IXlLeaf1xxH4S0XnUeMdrOlLkv3YUbnl"
//
//final class ReplicateManager {
//    
//    static let shared = ReplicateManager()
//    
//    private let replicate = Replicate.Client(token: securedToken)
//    
//    func runLlama(with input: String) async throws -> String {
//        do {
//            print("before run")
//            let output = try await replicate.run(
//                "meta/llama-2-70b-chat",
//                input: ["prompt" : input]
//            )
//            
//            print("after run")
//            print(output)
//            
//            guard let textOutput = output?.stringValue else {
//                fatalError()
//            }
//            
//            print("text: \(textOutput)")
//            return textOutput
//            
//        } catch {
//            throw(error)
//        }
//    }
//}
