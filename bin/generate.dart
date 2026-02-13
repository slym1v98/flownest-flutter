import 'package:args/args.dart';
import 'package:kappa/cli/commander.dart';
import 'package:kappa/cli/generator.dart';

/// A command-line tool for generating initial Kappa configuration files or new features.
///
/// This script:
/// - Creates kappa.yaml configuration file from template (default behavior)
/// - Generates a new feature module with its layered architecture (using 'feature' subcommand)
///
/// Usage:
///   dart run kappa:generate [-f|--force]
///   dart run kappa:generate feature -n <feature_name> [-f|--force]
Future<void> main(List<String> args) async {
  try {
    final ArgParser parser = ArgParser();
    parser.addCommand('feature', _featureCommandParser());
    parser.addCommand('model', _modelCommandParser()); // Add model command
    // Add other commands here later (e.g., 'model')

    final ArgResults argResults = parser.parse(args);

    if (argResults.command != null) {
      // Dispatch to subcommand handler
      switch (argResults.command!.name) {
        case 'feature':
          await _handleFeatureCommand(argResults.command!);
          break;
        case 'model': // Handle model command
          await _handleModelCommand(argResults.command!);
          break;
        // case 'model':
        //   await _handleModelCommand(argResults.command!);
        //   break;
        default:
          await Commander.info('Unknown command: ${argResults.command!.name}');
          print(parser.usage);
      }
    } else {
      // Handle the default 'generate' behavior (kappa.yaml)
      parser.addFlag('force', abbr: 'f', help: 'Force regeneration of kappa.yaml');
      final defaultResults = parser.parse(args); // Reparse for default flags

      await Commander.info('---------------- Generate setup configurations ------------------');
      await Generator.generateFromStub(
        'kappa.yaml',
        'kappa.stub',
        force: defaultResults['force'] as bool,
      );
      await Commander.info('--------------- Generated setup configurations ------------------');
    }
  } catch (e) {
    await Commander.info('[${e.runtimeType}] ${e.toString()}');
    Commander.info(parser.usage); // Show usage on error
  }
}

ArgParser _featureCommandParser() {
  final ArgParser parser = ArgParser();
  parser.addOption(
    'name',
    abbr: 'n',
    help: 'Name of the feature to generate (e.g., "auth", "product_list")',
    mandatory: true,
  );
  parser.addFlag('force', abbr: 'f', help: 'Force overwrite existing files');
  return parser;
}

Future<void> _handleFeatureCommand(ArgResults command) async {
  final String featureName = command['name'] as String;
  final bool force = command['force'] as bool;

  await Commander.info('---------------- Generate Feature: $featureName ------------------');
  await Generator.generateFeature(featureName, force: force); // Call new generator method
  await Commander.info('--------------- Feature: $featureName Generated ------------------');
}

ArgParser _modelCommandParser() { // New: Model command parser
  final ArgParser parser = ArgParser();
  parser.addOption(
    'name',
    abbr: 'n',
    help: 'Name of the model to generate (e.g., "user", "product")',
    mandatory: true,
  );
  parser.addFlag('force', abbr: 'f', help: 'Force overwrite existing files');
  return parser;
}

Future<void> _handleModelCommand(ArgResults command) async { // New: Model command handler
  final String modelName = command['name'] as String;
  final bool force = command['force'] as bool;

  await Commander.info('---------------- Generate Model: $modelName ------------------');
  await Generator.generateModel(modelName, force: force); // Call new generator method
  await Commander.info('--------------- Model: $modelName Generated ------------------');
}

// Define _modelCommandParser and _handleModelCommand here when needed

