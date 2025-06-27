import 'dart:io';

import 'package:args/args.dart';
import 'package:kappa/cli/commander.dart';
import 'package:kappa/cli/generator.dart';
import 'package:kappa/cli/kappa_config.dart';
import 'package:kappa/src/core/app_enum.dart';
import 'package:kappa/src/core/app_flavor.dart';

/// A command-line tool to set up build flavors for a Flutter project.
///
/// This script:
/// - Generates flavor configurations in flavorizr.yaml
/// - Sets up platform-specific flavor configurations for iOS, Android and optionally macOS
/// - Configures build settings, app icons, and launch screens for each flavor
/// - Updates XCConfig files with correct Flutter target paths
/// - Creates IntelliJ IDEA run configurations for each flavor
///
/// Usage: dart run kappa:flavor [-f|--force]
Future<void> main(List<String> args) async {
  try {
    await Commander.info('--------------------- Setup build flavors -----------------------');
    ArgParser argumentsParser = ArgParser();
    argumentsParser.addFlag('force', abbr: 'f');
    final result = argumentsParser.parse(args);

    /// Load configs
    KappaConfig configs = await Generator.readYaml('kappa.yaml');

    Map<String, dynamic> flavors = {};

    flavors.addEntries(AppFlavor.toList().map((flavor) {
      String tag = '';
      if (flavor != Flavor.product.name) {
        tag = '[${AppFlavor.nameTag(flavor).toUpperCase()}] ';
      }

      var flavorMap = {
        'app': {
          'name': '$tag${configs.appName}',
        },
        'android': {
          'applicationId': configs.appFlavor.applicationId,
        },
        'ios': {
          'bundleId': configs.appFlavor.bundleId,
        },
      };
      if (configs.appFlavor.macosSupported == true) {
        flavorMap['macos'] = {
          'bundleId': configs.appFlavor.bundleId,
        };
      }
      return MapEntry(
        flavor,
        flavorMap,
      );
    }));

    Map<String, dynamic> yamlData = {
      'flavors': flavors,
    };
    await Generator.generateYaml(
      'flavorizr.yaml',
      yamlData,
      force: result['force'] as bool,
    );

    var flavorizr = [
      'assets:download',
      'assets:extract',
      'android:androidManifest',
      'android:dummyAssets',
      'android:buildGradle',
      'android:icons',
      'ios:podfile',
      'ios:xcconfig',
      'ios:buildTargets',
      'ios:schema',
      'ios:dummyAssets',
      'ios:icons',
      'ios:plist',
      'ios:launchScreen',
      'google:firebase',
      'huawei:agconnect',
      'assets:clean',
    ];

    if (configs.appFlavor.macosSupported == true) {
      flavorizr.add('macos:podfile');
      flavorizr.add('macos:xcconfig');
      flavorizr.add('macos:configs');
      flavorizr.add('macos:buildTargets');
      flavorizr.add('macos:schema');
      flavorizr.add('macos:dummyAssets');
      flavorizr.add('macos:icons');
      flavorizr.add('macos:plist');
    }

    await Commander.dart('run', [
      'flutter_flavorizr',
      '-p',
      flavorizr.join(','),
    ]);

    final directory = Directory('.idea/runConfigurations');
    if (directory.existsSync()) {
      directory.deleteSync(recursive: true);
    }
    for (String flavor in AppFlavor.toList()) {
      for (String type in ['Debug', 'Profile', 'Release']) {
        await Generator.updateXcconfigFile(
          'ios/Flutter/$flavor$type.xcconfig',
          {
            'FLUTTER_TARGET': '${AppEnum.libDir}/main.dart',
          },
        );
        if (configs.appFlavor.macosSupported == true) {
          await Generator.updateXcconfigFile(
            'macos/Runner/Configs/$flavor$type.xcconfig',
            {
              'FLUTTER_TARGET': '${AppEnum.libDir}/main.dart',
            },
          );
        }
      }

      await Generator.generateIdeaRunConfigurations(
        '.idea/runConfigurations/main_${flavor}_dart.xml',
        flavor,
      );
    }

    await Commander.info('-------------- Setup build flavors successfully! ----------------');
  } catch (e) {
    await Commander.info('[${e.runtimeType}] ${e.toString()}');
  }
}
