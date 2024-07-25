import Foundation
import Combine

protocol GetImageUseCase {
    func execute(url: String) -> AnyPublisher<Data, Error> 
}

class GetImageUseCaseImpl: GetImageUseCase {
    private let apiClient: APIClientDatasource
    
    init(apiClient: APIClientDatasource) {
        self.apiClient = apiClient
    }
    
    func execute(url: String) -> AnyPublisher<Data, Error>  {
        return apiClient.fetchImage(url)        
    }
}
