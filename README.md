# Movie Play

A sample app that uses TMDb API (https://www.themoviedb.org) to show popular, top rated movies and 
search for movies by titles.

#### Pre-requisites to run the project
* Create an account on TMDb and generate an API_KEY,
then replace the token environment variable on SCHEME
* Add BASE_URL_MOVIES and BASE_URL_IMAGES to SCHEME as well.

#### Architecture and Libraries

This project follows the Clean Architecture pattern, aiming to separate concerns and enhance the maintainability of the codebase. The architecture ensures a clear separation between different layers of the application, which enhances testability and modularity.

### Architecture Overview

The architecture is divided into the following main layers:

1. **Presentation Layer**: Handles user interface logic and user interactions. This layer consists of `ViewControllers` and `Views`, which are responsible for displaying data and receiving user input. `ViewControllers` are connected to `ViewModels` to handle user interactions and update the UI.

2. **Domain Layer**: Contains business logic and application-specific rules. It includes `UseCases` that implement the core functionality of the application.

3. **Data Layer**: Manages data sources, including network and local storage. This layer is responsible for data retrieval, storage, and management. It includes `Repositories` and `Data Sources`.

### Libraries

### Clean Architecture Principles

The Clean Architecture pattern is based on the following principles:

1. **Separation of Concerns**: Each layer has a distinct responsibility, which helps in maintaining and testing individual components independently.

2. **Dependency Rule**: Dependencies point inwards, meaning that inner layers do not depend on outer layers. This ensures that changes in outer layers do not affect the core business logic.

3. **Testability**: Each layer can be tested independently, and the separation of concerns facilitates writing unit tests for business logic and data management.

4. **Scalability**: The modular structure of Clean Architecture makes it easier to scale the application by adding new features or modifying existing ones without affecting other parts of the codebase.

### Benefits

- **Encapsulation**: The business logic and data transformation are well-encapsulated within the domain layer, keeping the presentation layer clean and focused on UI.

- **Testability**: The architecture facilitates unit testing of each layer independently, improving test coverage and reliability.

- **Maintainability**: With clear separation between layers, the codebase is easier to maintain, understand, and refactor.



## Building with 🛠️

- [SWIFT](https://www.apple.com/co/swift/#:~:text=Swift%20es%20un%20lenguaje%20r%C3%A1pido,la%20experiencia%20con%20las%20apps.) - Lenguage
- [SWIFTUI](https://developer.apple.com/xcode/swiftui/) - Framework

## Thank's for you attention 🎁

- Developer by Anthony :) Merci [Anthony](https://www.linkedin.com/in/anthony-rubio-48995b1b3/)