### Presentation Layer

The presentation layer is responsible for displaying the data to the user and handling user interactions. It consists of the following components:

```dart
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:kappa/kappa.dart';
import 'package:lottie/lottie.dart';

import '../../core/core_exporter.dart';
import '../presentation_exporter.dart';

@RoutePage()
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen(
      useImmersiveMode: true,
      backgroundColor: Colors.white,
      splashScreenBody: Center(
        child: Lottie.asset(
          "assets/splash_lottie_animation.json",
          repeat: true,
        ),
      ),
      onInit: () async {
        // SL.call<AuthenticatedBloc>().add(const EnsureAuthenticated());
        // Load all the necessary data here
      },
      onEnd: () {
        // if (SL.call<AuthenticatedBloc>().state is! AuthenticatedSuccess) {
        //   context.router.pushNamed(AppRoutePaths.login);
        //   context.router.removeLast();
        //   return;
        // }
        context.router.pushNamed(AppRoutePaths.main);
        context.router.removeLast();
      },
    );
  }
}

```