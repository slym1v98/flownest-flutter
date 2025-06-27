import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'kappa_platform_interface.dart';

/// An implementation of [KappaPlatform] that uses method channels.
class MethodChannelKappa extends KappaPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('kappa');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
