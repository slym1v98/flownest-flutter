import 'package:flutter_test/flutter_test.dart';
import 'package:kappa/kappa.dart';
import 'package:kappa/kappa_platform_interface.dart';
import 'package:kappa/kappa_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockKappaPlatform
    with MockPlatformInterfaceMixin
    implements KappaPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final KappaPlatform initialPlatform = KappaPlatform.instance;

  test('$MethodChannelKappa is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelKappa>());
  });

  test('getPlatformVersion', () async {
    Kappa kappaPlugin = Kappa();
    MockKappaPlatform fakePlatform = MockKappaPlatform();
    KappaPlatform.instance = fakePlatform;

    expect(await kappaPlugin.getPlatformVersion(), '42');
  });
}
