# Kappa Flutter Framework

The Kappa Flutter Framework is a powerful and opinionated boilerplate designed to accelerate Flutter application development. It provides a predefined clean architecture structure, robust configuration management, and a comprehensive Command Line Interface (CLI) for code generation.

## Features

*   **Clean Architecture:** Built with a layered architecture (Core, Domain, Data, Presentation) for scalability, maintainability, and testability.
*   **Dependency Injection:** Centralized service locator (GetIt) for managing dependencies.
*   **State Management:** Integrates Bloc/Cubit for reactive state management.
*   **Networking:** Abstracted HTTP client using Dio.
*   **Local Storage:** Abstracted local and secure storage using Shared Preferences and Flutter Secure Storage.
*   **Configuration Management:** Centralized environment configuration using `.env` files and `AppConfig`.
*   **Code Generation CLI:** Command-line tools to scaffold features and models, reducing boilerplate.
*   **Localization & Build Flavors:** Pre-configured support for multi-language applications and environment-specific builds.
*   **App Lifecycle Management:** Built-in handling for app foreground/background states and upgrade alerts.
*   **Comprehensive Logging:** Abstracted logging interface for flexible log output.

## Documentation

Dive deeper into the Kappa Framework:

*   [Getting Started](doc/getting_started.md): How to set up and start using the framework.
*   [Architecture Overview](doc/architecture_overview.md): Understand the layered architecture and core principles.
*   [CLI Usage](doc/cli_usage.md): Detailed guide on using the `kappa generate` commands for code scaffolding.
*   [Configuration Management](doc/configuration.md): Learn about environment variables and `AppConfig`.

### Author

- [Slym175](https://gitlab.com/slym175)

