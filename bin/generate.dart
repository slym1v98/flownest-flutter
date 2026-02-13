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
    parser.addCommand('model', _modelCommandParser());
    parser.addCommand('interactive', ArgParser()); // New interactive command

    final ArgResults argResults = parser.parse(args);

    if (argResults.command != null) {
      // Dispatch to subcommand handler
      switch (argResults.command!.name) {
        case 'feature':
          await _handleFeatureCommand(argResults.command!);
          break;
        case 'model':
          await _handleModelCommand(argResults.command!);
          break;
        case 'interactive':
          await _handleInteractiveCommand();
          break;
        default:
          await Commander.info('Unknown command: ${argResults.command!.name}');
          print(parser.usage);
      }
    } else {
      // Handle the default 'generate' behavior (kappa.yaml)
      parser.addFlag('force', abbr: 'f', help: 'Force regeneration of kappa.yaml');
      final defaultResults = parser.parse(args); // Reparse for default flags

      await Commander.info('---------------- Generate setup configurations ------------------');
      await Commander.info('Tip: Use "dart run kappa:generate interactive" for a guided experience!');
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

Future<void> _handleModelCommand(ArgResults command) async {
  final String modelName = command['name'] as String;
  final bool force = command['force'] as bool;

  await Commander.info('---------------- Generate Model: $modelName ------------------');
  await Generator.generateModel(modelName, force: force);
  await Commander.info('--------------- Model: $modelName Generated ------------------');
}

Future<void> _handleInteractiveCommand() async {
  await Commander.info('====================================================');
  await Commander.info('         KAPPA INTERACTIVE GENERATOR                ');
  await Commander.info('====================================================');

  final type = await Commander.promptChoose('What would you like to generate?', [
    'Feature (Clean Architecture layers)',
    'Model (with JSON serialization)',
    'Screen (Widget)',
    'Bloc/Cubit',
    'Repository',
    'Exit',
  ]);

  if (type == 'Exit') return;

  final name = await Commander.prompt('Enter name (snake_case)', required: true);
  final forceInput = await Commander.promptChoose('Overwrite if exists?', ['No', 'Yes']);
  final bool force = forceInput == 'Yes';

  switch (type) {
    case 'Feature (Clean Architecture layers)':
      await Generator.generateFeature(name, force: force);
      break;
    case 'Model (with JSON serialization)':
      await Generator.generateModel(name, force: force);
      break;
    case 'Screen (Widget)':
      final isStateful = await Commander.promptChoose('Type?', ['Stateless', 'Stateful']);
      await FileGenerator.generateScreen(name, stateful: isStateful == 'Stateful', force: force);
      break;
    case 'Bloc/Cubit':
      final blocType = await Commander.promptChoose('Type?', ['Bloc', 'Cubit']);
      if (blocType == 'Bloc') {
        await FileGenerator.generateBloc(name, force: force);
      } else {
        await FileGenerator.generateCubit(name, force: force);
      }
      break;
    case 'Repository':
      await FileGenerator.generateRepository(name, force: force);
      break;
  }

  await Commander.info('Done!');
}

