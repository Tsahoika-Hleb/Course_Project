import Replicate

let securedToken = "r8_57N4XI9T7scrsVuBhRnti7UNmfcHfQn3FMGIK"

final class ReplicateManager {
    
    static let shared = ReplicateManager()
    
    private let replicate = Replicate.Client(token: securedToken)
    
    func runLlama(with input: String) async throws -> String {
        do {
            let output = try await replicate.run(
                "meta/llama-2-70b-chat",
                input: input
            )
            
            guard let textOutput = output?.stringValue else {
                fatalError()
            }
            
            return textOutput
            
        } catch {
            throw(error)
        }
    }
}
