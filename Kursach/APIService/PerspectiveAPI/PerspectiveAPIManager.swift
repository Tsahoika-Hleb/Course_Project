final class PerspectiveAPIManager {
    
    // Делаем Singleton
    static let shared = PerspectiveAPIManager()
    
    private var networkManager: NetworkManager
    
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func countToxity(
        in text: String,
        complition: @escaping (Result<Double, Error>) -> Void)
    {
        networkManager.request(
            config: .analyzeComment(text: text),
            responseHandler: DefaultResponseHandler())
        { [self] (result: Result<APIResponse, Error>) in
            switch result {
            case let .success(success):
                let toxity = self.parseResponse(success)
                complition(.success(toxity))
            case let .failure(error):
                complition(.failure(error))
            }
        }
    }
    
    private func parseResponse(_ response: APIResponse) -> Double {
        guard let attributeScores = response.attributeScores["TOXICITY"] else {
            return 0
        }
        let summaryScore = attributeScores.summaryScore
        
        return summaryScore.value
    }
}
