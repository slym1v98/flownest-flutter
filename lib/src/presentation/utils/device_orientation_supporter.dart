import 'package:flutter/services.dart';

enum DeviceOrientationType {
  all,
  portrait,
  landscape,
  portraitUp,
  portraitDown,
  landscapeLeft,
  landscapeRight,
  portraitLandscapeLeft,
  portraitLandscapeRight,
  portraitUpLandscape,
  portraitDownLandscape,
}

class DeviceOrientationSupporter {
  static List<DeviceOrientation> fromType(DeviceOrientationType type) {
    return switch (type) {
      DeviceOrientationType.all => [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ],
      DeviceOrientationType.portrait => [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ],
      DeviceOrientationType.landscape => [
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ],
      DeviceOrientationType.portraitUp => [
          DeviceOrientation.portraitUp,
        ],
      DeviceOrientationType.portraitDown => [
          DeviceOrientation.portraitDown,
        ],
      DeviceOrientationType.landscapeLeft => [
          DeviceOrientation.landscapeLeft,
        ],
      DeviceOrientationType.landscapeRight => [
          DeviceOrientation.landscapeRight,
        ],
      DeviceOrientationType.portraitLandscapeLeft => [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeLeft,
        ],
      DeviceOrientationType.portraitLandscapeRight => [
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeRight,
        ],
      DeviceOrientationType.portraitUpLandscape => [
          DeviceOrientation.portraitUp,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ],
      DeviceOrientationType.portraitDownLandscape => [
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ],
    };
  }
}
