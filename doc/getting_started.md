# Getting Started with Kappa Framework

Welcome to the Kappa Framework! This guide will help you set up your project and start developing powerful Flutter applications quickly.

## 1. Installation

Ensure you have Flutter SDK installed and configured. If not, follow the official Flutter installation guide: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)

Clone your project that utilizes the Kappa Framework:

```bash
git clone your-kappa-project.git
cd your-kappa-project
```

Then, get the dependencies:

```bash
flutter pub get
```

## 2. Initial Setup

The Kappa Framework provides a command-line interface (CLI) to help you set up and generate code.

To generate the initial `kappa.yaml` configuration file:

```bash
dart run kappa:generate
```

If you need to regenerate it and overwrite any existing file, use the `--force` flag:

```bash
dart run kappa:generate --force
```

## 3. Environment Configuration

Kappa uses `.env` files for environment-specific configurations.

*   Create `.env` files (e.g., `.env.develop`, `.env.production`) in your project root.
*   Define variables like `BASE_URL`, `API_KEY`, `ENABLE_ANALYTICS`.

Example `.env.develop`:

```dotenv
BASE_URL=http://dev.api.yourdomain.com
API_KEY=dev_api_key_123
ENABLE_ANALYTICS=false
```

Your `main.dart` should be configured to load the Kappa framework. Refer to `lib/kappa.dart` documentation for `Kappa.ensureInitialized` usage.

## 4. Generating New Features

The Kappa CLI can scaffold entire features, following the Clean Architecture pattern.

To generate a new feature (e.g., named "auth"):

```bash
dart run kappa:generate feature -n auth
```

This will create a structured directory within `lib/src/features/auth` including `data`, `domain`, and `presentation` layers with boilerplate code.

## 5. Generating Models

You can also generate individual models:

```bash
dart run kappa:generate model -n product
```

This will create `lib/src/data/models/product/product.dart` with boilerplate for JSON serialization (`json_annotation`) and a `copyWith` method.

## What's Next?

*   Explore the [Architecture Overview](architecture_overview.md) to understand the project structure.
*   Learn about [Configuration Management](configuration.md) for advanced settings.
*   Dive into specific CLI commands in [CLI Usage](cli_usage.md).
*   Start implementing your business logic within the generated feature modules!
