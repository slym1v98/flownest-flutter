import 'package:args/args.dart';
import 'package:kappa/cli/commander.dart';
import 'package:kappa/cli/generator.dart';

/// A command-line tool for generating initial Kappa configuration files.
///
/// This script:
/// - Creates kappa.yaml configuration file from template
/// - Supports force flag (-f) to regenerate configuration
///
/// Usage: dart run kappa:generate [-f|--force]
Future<void> main(List<String> args) async {
  try {
    ArgParser argumentsParser = ArgParser();
    argumentsParser.addFlag('force', abbr: 'f');
    final result = argumentsParser.parse(args);

    await Commander.info('---------------- Generate setup configurations ------------------');
    await Generator.generateFromStub(
      'kappa.yaml',
      'kappa.stub',
      force: result['force'] as bool,
    );
    await Commander.info('--------------- Generated setup configurations ------------------');
  } catch (e) {
    await Commander.info('[${e.runtimeType}] ${e.toString()}');
  }
}
