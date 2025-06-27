import 'dart:io';

import 'package:kappa/src/core/app_enum.dart';
import 'package:kappa/src/core/app_flavor.dart';
import 'package:path/path.dart' as p;
import 'package:args/args.dart';
import 'package:kappa/cli/commander.dart';
import 'package:kappa/cli/generator.dart';
import 'package:kappa/cli/kappa_config.dart';

/// A command-line tool for setting up environment configurations in a Flutter project.
///
/// This script handles:
/// - Generation of environment files (.env) for different flavors
/// - Creation and management of .gitignore for env files
/// - Updates pubspec.yaml to include env directory in assets
/// - Supports force flag (-f) to regenerate environment files
/// - Reads configuration from kappa.yaml
///
/// Usage: dart run kappa:env [-f|--force]
Future<void> main(List<String> args) async {
  try {
    await Commander.info('---------------------- Setup environments -----------------------');

    ArgParser argumentsParser = ArgParser();
    argumentsParser.addFlag('force', abbr: 'f');
    final result = argumentsParser.parse(args);

    if (result['force'] == true) {
      final directory = Directory(AppEnum.envDir);
      if (directory.existsSync()) {
        directory.deleteSync(recursive: true);
      }
    }

    /// Load configs
    KappaConfig configs = await Generator.readYaml('kappa.yaml');

    bool fileExisted = AppFlavor.toList().fold(
      true,
      (result, flavor) => result && File(p.join(AppEnum.envDir, '.env.$flavor')).existsSync(),
    );

    /// If env file is existed and not force generate.
    if (fileExisted && result['force'] == false) {
      await Commander.info('--------------- Setup environments successfully! ----------------');
      return;
    }

    await Generator.generateFromStub(
      p.join(AppEnum.envDir, '.env'),
      'env.stub',
      force: result['force'] as bool,
      params: {
        'appName': configs.appName,
        'appKey': "",
        ...configs.appLocale.toStringMap(),
      },
    );
    await Generator.generateFromStub(
      p.join(AppEnum.envDir, '.env.example'),
      'env.stub',
      force: result['force'] as bool,
      params: {
        'appName': configs.appName,
        'appKey': "",
        ...configs.appLocale.toStringMap(),
      },
    );
    for (String flavor in AppFlavor.toList()) {
      await Generator.generateFromStub(
        p.join(AppEnum.envDir, '.env.$flavor'),
        'env.stub',
        force: result['force'] as bool,
        params: {
          'appName': configs.appName,
          'appKey': Generator.generateAppKey(),
          ...configs.appLocale.toStringMap(),
        },
      );
    }

    /// Ignore env files
    await Generator.generateFromStub(
      '.gitignore',
      'gitignore.stub',
      force: true,
    );

    await Generator.updatePubspecYaml(
      modifiedYamlCallback: (modifiedYamlMap) {
        Map<String, dynamic> modifiedYaml = Map<String, dynamic>.from(modifiedYamlMap);

        // Assets
        modifiedYaml['flutter'] = Map<String, dynamic>.from(modifiedYaml['flutter'] as Map);
        List<String> assets = List<String>.from(modifiedYaml['flutter']['assets'] as List);

        assets.removeWhere((asset) => asset == '${AppEnum.envDir}/');
        assets.add('${AppEnum.envDir}/');

        modifiedYaml['flutter']['assets'] = assets;

        return modifiedYaml;
      },
    );
    await Commander.flutter('pub', ['get']);

    await Commander.info('--------------- Setup environments successfully! ----------------');
  } catch (e) {
    await Commander.info('[${e.runtimeType}] ${e.toString()}');
  }
}
