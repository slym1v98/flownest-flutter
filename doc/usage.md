### Usage

### To generate the project

```bash
dart run kappa:install 
  --appName kappa
  --applicationId tech.metalbox
  --bundleId tech.metalbox
  --supportedLocales en
  --supportedLocales vi
  --appLocalePath l10n
  --appLocale vi
  --fallbackLocale en
  -f
  --flavorId
```

Install will generate simple `main.dart` in the lib folder, let's modify it:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kappa/kappa.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'src/core/core_exporter.dart';
import 'src/presentation/presentation_exporter.dart';
import 'src/injector.dart';

Future<void> main() async {
  await Kappa.ensureInitialized(
    designSize: const Size(390, 844),
    routerDelegate: AppRoutes().delegate(),
    routeInformationParser: AppRoutes().defaultRouteParser(),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    onInitServices: () async {
      await initServices();
    },
    providers: [
      // BlocProvider(create: (context) => SL.call<AnyInjectableBloc>()),
    ],
  );
}
```

Note:

- `--appName` is the name of the app.
- `--applicationId` is the android application id of the app.
- `--bundleId` is the ios, macos bundle id of the app.
- `--supportedLocales` is the supported locales of the app.
- `--appLocale` is the default locale of the app.
- `--fallbackLocale` is the fallback locale of the app.
- `-f` is the flag to force overwrite the existing files.
- `--flavorId` is the flavor id of the app. It will generate the flavor on application id, bundle id
  like `com.example.dev` and `com.example.stg`.

### Run build runner

```bash
// For watch mode
flutter pub run build_runner watch --delete-conflicting-outputs

// For build mode
flutter pub run build_runner build --delete-conflicting-outputs
```