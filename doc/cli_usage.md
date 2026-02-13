# CLI Usage

The Kappa Framework provides a powerful Command Line Interface (CLI) to automate common development tasks, including project setup, code generation, and configuration management.

## 1. Kappa Generate Command (`dart run kappa:generate`)

This command is central to scaffolding and configuring your Kappa project.

### 1.1. Generate Kappa Configuration (`kappa.yaml`)

This is the default behavior when no subcommand is specified. It creates or updates the `kappa.yaml` configuration file in your project root.

```bash
dart run kappa:generate
```

*   **Options:**
    *   `-f`, `--force`: Force regeneration, overwriting an existing `kappa.yaml` file.

    ```bash
    dart run kappa:generate --force
    ```

### 1.2. Generate Feature Module (`kappa generate feature`)

This subcommand helps you scaffold a new feature module following the Clean Architecture pattern (Data, Domain, Presentation layers).

*   **Usage:**
    ```bash
    dart run kappa:generate feature -n <feature_name>
    ```
    Replace `<feature_name>` with the desired name for your feature (e.g., `auth`, `product_list`).

*   **Options:**
    *   `-n`, `--name <feature_name>`: **(Required)** The name of the feature to generate.
    *   `-f`, `--force`: Force overwrite existing files within the feature directory.

*   **Example:**
    ```bash
    dart run kappa:generate feature -n user_profile
    ```
    This will create the following structure:
    ```
    lib/src/features/user_profile/
    ├── data/
    │   ├── datasources/
    │   │   ├── user_profile_remote_data_source.dart
    │   │   └── user_profile_local_data_source.dart
    │   ├── models/
    │   │   └── user_profile_model.dart
    │   └── repositories/
    │       └── user_profile_repository_impl.dart
    ├── domain/
    │   ├── entities/
    │   │   └── user_profile_entity.dart
    │   ├── repositories/
    │   │   └── user_profile_repository.dart
    │   └── usecases/
    │       └── get_user_profile_usecase.dart
    └── presentation/
        ├── bloc/
        │   ├── user_profile_bloc.dart
        │   ├── user_profile_event.dart
        │   └── user_profile_state.dart
        └── pages/
            └── user_profile_page.dart
    ```

### 1.3. Generate Model (`kappa generate model`)

This subcommand generates a new model file, typically for data serialization, using `json_annotation` and including a `copyWith` method.

*   **Usage:**
    ```bash
    dart run kappa:generate model -n <model_name>
    ```
    Replace `<model_name>` with the desired name for your model (e.g., `product`, `order`).

*   **Options:**
    *   `-n`, `--name <model_name>`: **(Required)** The name of the model to generate.
    *   `-f`, `--force`: Force overwrite the existing model file.

*   **Example:**
    ```bash
    dart run kappa:generate model -n notification
    ```
    This will create `lib/src/data/models/notification/notification.dart` with the model boilerplate.

## 2. Other Kappa Commands (`dart run kappa:<command>`)

The Kappa CLI also includes other utility commands.

### 2.1. Environment Generation (`dart run kappa:env`)

This command generates environment-related configuration files.

```bash
dart run kappa:env 
  --appName kappa
  --supportedLocales en
  --supportedLocales vi
  --appLocalePath l10n
  --appLocale vi
  --fallbackLocale en
  -f
```

### 2.2. Build Flavors Generation (`dart run kappa:flavor`)

This command sets up configuration for different build flavors (e.g., develop, staging, product).

```bash
dart run kappa:flavor 
  --appName kappa
  --applicationId tech.metalbox
  --bundleId tech.metalbox
  --flavorId
  -f
```

### 2.3. Localization Files Generation (`dart run kappa:l10n`)

This command generates localization-related files.

```bash
dart run kappa:l10n 
  --supportedLocales en
  --supportedLocales vi
  --appLocalePath l10n
  --appLocale vi
  --fallbackLocale en
  -f
```

*   **Supported locales:**
    *   English (en)
    *   Español (es)
    *   Français (fr)
    *   日本語 (ja)
    *   한국어 (ko)
    *   Tiếng Việt (vi)
    *   中文 (zh)
