# Architecture Overview

The Kappa Framework is built upon a clean, layered architecture designed for maintainability, scalability, and testability. It strictly adheres to the principles of Clean Architecture, separating concerns into distinct layers with clear dependency rules.

## Core Principles

*   **Separation of Concerns:** Each layer has a specific responsibility, preventing intertwined logic.
*   **Dependency Rule:** Dependencies always flow inwards. Inner layers have no knowledge of outer layers. This means the `Domain` layer is independent of `Data` and `Presentation`.
*   **Testability:** Each layer can be tested in isolation, making unit and integration testing straightforward.
*   **Framework Agnostic:** Business rules (Domain layer) are independent of UI frameworks (Flutter) and databases/APIs.

## Layered Structure

The project follows a standard Clean Architecture pattern, organized into four primary layers:

1.  **Core (`lib/src/core/`)**
    *   **Responsibility:** Contains cross-cutting concerns, shared utilities, interfaces (abstractions), and fundamental definitions used across the entire application. This layer is crucial for defining the "contracts" that other layers will adhere to.
    *   **Contents:**
        *   `config/`: Centralized application configuration (`AppConfig`).
        *   `network/`: Network client interfaces (`IHttpClient`) and implementations (`DioHttpClient`).
        *   `storage/`: Local and secure storage interfaces (`ILocalStorage`, `ILocalSecureStorage`) and implementations.
        *   `logging/`: Logging interface (`ILogger`) and implementations.
        *   `exceptions/`: Custom exception classes.
        *   `app_enum.dart`, `app_flavor.dart`: Application-wide enumerations and flavor definitions.
        *   `injector.dart`: Dependency Injection setup using GetIt.
    *   **Dependency Rule:** No external dependencies beyond Dart/Flutter SDK. Other layers depend on `Core`.

2.  **Domain (`lib/src/domain/`)**
    *   **Responsibility:** Contains the core business logic and enterprise-wide rules. This is the most central part of the application and should be pure, stable, and independent.
    *   **Contents:**
        *   `entities/`: Plain Dart objects representing the core business concepts (e.g., `UserEntity`, `ProductEntity`). They contain business rules and data.
        *   `repositories/`: Abstract interfaces (contracts) that define how data should be retrieved and persisted. These are implemented by the `Data` layer.
        *   `usecases/` (or `interactors`): Classes that encapsulate specific business operations. They orchestrate entities and repositories to perform a task (e.g., `GetUserUseCase`, `AddProductUseCase`).
    *   **Dependency Rule:** Depends only on the `Core` layer and other `Domain` components. It has no knowledge of `Data` or `Presentation`.

3.  **Data (`lib/src/data/`)**
    *   **Responsibility:** Implements the contracts defined in the `Domain` layer, handling data retrieval, storage, and manipulation. It bridges the gap between the `Domain` and external data sources.
    *   **Contents:**
        *   `datasources/`: Implementations for interacting with external services (APIs, databases). This includes `remote_data_sources` (e.g., fetching from REST APIs) and `local_data_sources` (e.g., reading from local database, shared preferences).
        *   `models/`: Data Transfer Objects (DTOs) that mirror the structure of data received from external sources (e.g., API responses). These models are responsible for converting data to/from `Entities`.
        *   `repositories/`: Concrete implementations of the abstract repository interfaces defined in the `Domain` layer. They combine data from various data sources and convert `Models` to `Entities`.
    *   **Dependency Rule:** Depends on `Core` and `Domain` layers. It should NOT depend on the `Presentation` layer.

4.  **Presentation (`lib/src/presentation/`)**
    *   **Responsibility:** Handles the user interface (UI) and user interactions. It presents data to the user and translates user input into actions that the `Domain` layer can execute.
    *   **Contents:**
        *   `pages/` (or `screens`): Top-level UI widgets that compose smaller widgets.
        *   `widgets/`: Reusable UI components.
        *   `bloc/` (or `cubit`): State management logic, translating events (user actions) into states (UI updates) using `Usecases` from the `Domain` layer.
        *   `theme/`: Application theming (colors, fonts, etc.).
        *   `utils/`, `extensions/`: Presentation-specific utilities.
    *   **Dependency Rule:** Depends on `Core`, `Domain`, and `Data` layers. It has no dependencies flowing outwards (e.g., `Domain` must not depend on `Presentation`).

## Dependency Flow (Inward Only)

```
       +-----------------+
       |   Presentation  |
       +-----------------+
               ^
               | (depends on)
       +-----------------+
       |      Data       |
       +-----------------+
               ^
               | (depends on)
       +-----------------+
       |     Domain      |
       +-----------------+
               ^
               | (depends on)
       +-----------------+
       |      Core       |
       +-----------------+
```

By adhering to this structure, the Kappa Framework ensures that business logic remains decoupled from UI and data handling specifics, leading to highly adaptable and maintainable applications.
