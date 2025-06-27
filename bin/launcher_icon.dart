import 'dart:io';

import 'package:args/args.dart';
import 'package:kappa/cli/commander.dart';
import 'package:kappa/cli/generator.dart';
import 'package:kappa/cli/kappa_config.dart';

/// A command-line tool for configuring launcher icons in a Flutter project.
///
/// This script handles:
/// - Validation of launcher icon file existence
/// - Updates pubspec.yaml with flutter_launcher_icons dependency
/// - Generates flutter_launcher_icons.yaml configuration
/// - Generates platform-specific launcher icons
///
/// Usage: dart run kappa:launcher_icon [-f|--force]
Future<void> main(List<String> args) async {
  try {
    await Commander.info('--------------------- Setup launcher icon -----------------------');
    ArgParser argumentsParser = ArgParser();
    argumentsParser.addFlag('force', abbr: 'f');
    final result = argumentsParser.parse(args);

    /// Load configs
    KappaConfig configs = await Generator.readYaml('kappa.yaml');
    if (!File(configs.launcherIcon).existsSync()) {
      await Commander.info('Launcher icon is not exists!');
      return;
    }

    await Generator.updatePubspecYaml(
      modifiedYamlCallback: (modifiedYamlMap) {
        Map<String, dynamic> modifiedYaml = Map<String, dynamic>.from(modifiedYamlMap);
        // Add dev_dependencies
        modifiedYaml['dev_dependencies'] = Map<String, dynamic>.from(modifiedYaml['dev_dependencies'] as Map);
        modifiedYaml['dev_dependencies']['flutter_launcher_icons'] = '^0.14.2';
        return modifiedYaml;
      },
    );
    await Generator.generateFromStub(
      'flutter_launcher_icons.yaml',
      'flutter_launcher_icons.stub',
      force: result['force'] as bool,
      params: {"launcherIcon": configs.launcherIcon},
    );
    await Commander.flutter('pub', ['get']);
    await Commander.dart('run', ['flutter_launcher_icons']);

    await Commander.info('-------------- Setup launcher icon successfully! ----------------');
  } catch (e) {
    await Commander.info('[${e.runtimeType}] ${e.toString()}');
  }
}
