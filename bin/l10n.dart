import 'package:args/args.dart';
import 'package:kappa/cli/commander.dart';
import 'package:kappa/cli/generator.dart';
import 'package:kappa/cli/kappa_config.dart';
import 'package:path/path.dart' as p;

/// A command-line tool for setting up localization in a Flutter project.
///
/// This script handles:
/// - Generation of ARB files for supported locales
/// - Configuration of l10n.yaml settings
/// - Updates iOS Info.plist with supported languages
/// - Updates pubspec.yaml with required localization dependencies
/// - Generates Flutter localization files
///
/// Usage: dart run kappa:l10n [-f|--force]
Future<void> main(List<String> args) async {
  try {
    await Commander.info('------------------- Setup app localizations ---------------------');
    ArgParser argumentsParser = ArgParser();
    argumentsParser.addFlag('force', abbr: 'f');
    final result = argumentsParser.parse(args);

    /// Load configs
    KappaConfig configs = await Generator.readYaml('kappa.yaml');

    for (String locale in configs.appLocale.supported) {
      await Generator.generateFromStub(
        p.join(configs.appLocale.path, 'app_$locale.arb'),
        'l10n.stub',
        force: result['force'] as bool,
        params: {'locale': locale},
      );
    }

    await Generator.generateYaml(
      'l10n.yaml',
      {
        'arb-dir': configs.appLocale.path,
        'template-arb-file': 'app_${configs.appLocale.defaultLocale}.arb',
        'output-localization-file': 'app_localizations.dart',
        'use-escaping': true,
      },
      force: result['force'] as bool,
    );

    await Generator.updateInfoPlist(
      plistPath: 'ios/Runner/Info.plist',
      localizations: configs.appLocale.supported,
    );

    await Generator.updatePubspecYaml(
      modifiedYamlCallback: (modifiedYamlMap) {
        Map<String, dynamic> modifiedYaml = Map<String, dynamic>.from(modifiedYamlMap);
        modifiedYaml['flutter'] = Map<String, dynamic>.from(modifiedYaml['flutter'] as Map);
        modifiedYaml['flutter']['generate'] = true;
        // Add dev_dependencies
        modifiedYaml['dependencies'] = Map<String, dynamic>.from(modifiedYaml['dependencies'] as Map);
        modifiedYaml['dependencies']['flutter_localizations'] = {'sdk': 'flutter'};
        modifiedYaml['dependencies']['intl'] = '^0.19.0';
        // Add dev_dependencies
        modifiedYaml['dev_dependencies'] = Map<String, dynamic>.from(modifiedYaml['dev_dependencies'] as Map);
        modifiedYaml['dev_dependencies']['build_runner'] = '^2.4.9';
        return modifiedYaml;
      },
    );

    await Commander.flutter('pub', ['get']);
    await Commander.flutter('gen-l10n', []);

    await Commander.info('------------ Setup app localizations successfully! --------------');
  } catch (e) {
    await Commander.info('[${e.runtimeType}] ${e.toString()}');
  }
}
