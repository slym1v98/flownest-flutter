import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'kappa_method_channel.dart';

abstract class KappaPlatform extends PlatformInterface {
  /// Constructs a KappaPlatform.
  KappaPlatform() : super(token: _token);

  static final Object _token = Object();

  static KappaPlatform _instance = MethodChannelKappa();

  /// The default instance of [KappaPlatform] to use.
  ///
  /// Defaults to [MethodChannelKappa].
  static KappaPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [KappaPlatform] when
  /// they register themselves.
  static set instance(KappaPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
