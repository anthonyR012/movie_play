

protocol GetGenresUseCase {
    func execute() -> AnyPublisher<Genres, Error> 
}

class GetGenresUseCaseImpl: GetGenresUseCase {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func execute(lenguage: String) -> AnyPublisher<Genres, Error>  {
        return apiClient.fetchGenders(lenguage:lenguage)    
    }
}
