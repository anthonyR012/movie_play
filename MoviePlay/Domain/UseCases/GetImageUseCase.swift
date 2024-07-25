import Foundation
import Combine

protocol GetImageUseCase {
    func execute(url: String) -> AnyPublisher<Data, Error> 
}

class GetImageUseCaseImpl: GetImageUseCase {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func execute(url: String) -> AnyPublisher<Data, Error>  {
        return apiClient.fetchImage(url)        
    }
}
