import Foundation

class ApiViewModel: NSObject {
    
    private var networkManager: NetworkManager
    
    private(set) var empData : APIResponse? {
        didSet {
            self.bindEmployeeViewModelToController()
        }
    }
    
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
        
    var bindEmployeeViewModelToController : (() -> ()) = {}
    
    func callAPI(text: String) {
        networkManager.request(config: .processText(text: text),
                               responseHandler: DefaultResponseHandler()) { [weak self] (result: Result<APIResponse, Error>) in
            switch result {
            case .success(let success):
                self?.empData = success
            case .failure(let failure):
                fatalError(failure.localizedDescription)
            }
        }
    }
}
