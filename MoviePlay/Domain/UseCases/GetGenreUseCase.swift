

protocol GetGenresUseCase {
    func execute() -> AnyPublisher<Genres, Error> 
}

class GetGenresUseCaseImpl: GetGenresUseCase {
    private let apiClient: APIClientDatasource
    
    init(apiClient: APIClientDatasource) {
        self.apiClient = apiClient
    }
    
    func execute(lenguage: String) -> AnyPublisher<Genres, Error>  {
        return apiClient.fetchGenders(lenguage:lenguage)    
    }
}
