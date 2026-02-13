# Project Structure

Kappa promotes a Clean Architecture structure for your Flutter projects. When you use the Kappa CLI to generate features, it will follow this organized layout.

## 1. Directory Overview

A typical project using Kappa will have the following structure within the `lib/` directory:

```text
lib/
├── main.dart                  # Entry point (configured with Kappa)
├── kappa.yaml                 # Kappa CLI configuration
├── src/
│   ├── core/                  # App-wide configurations, constants, and utilities
│   ├── data/                  # Data layer: Models, Repositories, DataSources
│   ├── domain/                # Domain layer: Entities, UseCases, Repository interfaces
│   ├── features/              # Feature-based modules
│   │   └── <feature_name>/    # Individual feature with its own Clean Architecture layers
│   └── presentation/          # Global UI components, themes, and Bloc/State management
└── l10n/                      # Localization files (.arb)
```

## 2. Layer Details

### Core (`lib/src/core/`)
Contains shared code used across all layers. This includes:
*   `config/`: `AppConfig` for environment variables.
*   `network/`: HTTP client configurations.
*   `storage/`: Local storage services.
*   `utils/` & `extensions/`: Common helper functions.

### Domain (`lib/src/domain/`)
The business logic layer.
*   **Entities**: Pure data classes.
*   **UseCases**: Individual business actions.
*   **Repositories**: Abstract interfaces defining data operations.

### Data (`lib/src/data/`)
The implementation layer for data retrieval.
*   **Models**: Data Transfer Objects (DTOs) with JSON serialization.
*   **DataSources**: Remote (API) and Local (Database) data fetching.
*   **Repositories**: Concrete implementations of Domain repositories.

### Presentation (`lib/src/presentation/`)
Everything related to the UI.
*   **Blocs/Cubits**: State management logic.
*   **Pages/Screens**: Full UI pages.
*   **Widgets**: Reusable UI components.
*   **Theme**: App-wide styling and colors.

## 3. Localization
Localization files are stored in `lib/l10n/`. Kappa supports multiple languages out of the box and provides a CLI command to manage them.

---

For more details on each layer, see:
*   [Data Layer Details](project_structure/data.md)
*   [Domain Layer Details](project_structure/domain.md)
*   [Presentation Layer Details](project_structure/presentation.md)
