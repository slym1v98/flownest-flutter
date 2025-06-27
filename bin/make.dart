import 'package:kappa/cli/arguments_parser.dart';
import 'package:kappa/cli/commander.dart';
import 'package:kappa/cli/generator.dart';
import 'package:kappa/cli/maker/file_validator.dart';
import 'package:kappa/cli/maker/generate_file_types.dart';

/// A command-line tool for generating various file types in a Kappa project.
///
/// Supports generating:
/// - screens (stateful/stateless widgets)
/// - events
/// - states
/// - cubits (with optional hydration)
/// - blocs (with optional hydration)
/// - entities
/// - use cases
/// - repositories
/// - models
/// - collections
/// - data sources (local/remote)
///
/// Usage: dart run kappa:make <fileType> [fileName] [options]
///
/// Run without arguments to see available file types and descriptions.
/// Each file type supports a --force flag to overwrite existing files.
Future<void> main(List<String> args) async {
  var fileTypes = GenerateFileTypes.fileTypes;

  if (args.isEmpty) {
    await Commander.info('Usage: dart run kappa:make fileType');
    await Commander.table(
      fileTypes.entries.map((entry) => [entry.key, entry.value.description]).toList(),
      header: ['File Type', 'Description'],
    );
    return;
  }

  String fileType = args[0];
  if (!fileTypes.containsKey(fileType)) {
    await Commander.info('File type $fileType is not supported!');
    return;
  }

  String fileName = args.length > 1 ? args[1] : '';

  if (fileName.isEmpty) {
    await Commander.info('File name is required!');
    return;
  }

  if (!FileValidator.isValid(fileName)) {
    await Commander.info('File name should only contain letters, numbers, and underscores!');
    return;
  }

  if (fileName.contains(' ') ||
      fileName.contains('\t') ||
      fileName.contains('\n') ||
      fileName.contains('\r') ||
      fileName.startsWith('-')) {
    await Commander.info(
      'File name should not contain spaces, tabs, newlines, or start with a dash!',
    );
    return;
  }

  GenerateFileType generateFileType = fileTypes[fileType]!;
  ArgumentsParser argumentsParser = ArgumentsParser();
  argumentsParser
    ..addForceFlag(
      help: 'Force generate file',
      callback: (value) {
        if (value) {
          Commander.info('Force generate file...');
          return;
        }
        Commander.info('Generate file...');
      },
    )
    ..addOptions(generateFileType.optionArguments)
    ..addMultiOptions(generateFileType.multiOptionArguments)
    ..addFlags(generateFileType.flagArguments);

  Map<String, dynamic> result = await argumentsParser.parse(args.sublist(1));

  return switch (fileType) {
    'screen' => await FileGenerator.generateScreen(
        fileName,
        stateful: result['stateful'] ?? false,
        force: result['force'] ?? false,
      ).then((_) => Commander.info('File generated successfully!')),
    'event' => await FileGenerator.generateEvent(
        fileName,
        force: result['force'] ?? false,
        onlyEvent: true,
      ).then((_) => Commander.info('File generated successfully!')),
    'state' => await FileGenerator.generateState(
        fileName,
        type: result['type'] ?? 'bloc',
        force: result['force'] ?? false,
        onlyState: true,
      ).then((_) => Commander.info('File generated successfully!')),
    'cubit' => await FileGenerator.generateCubit(
        fileName,
        hydrated: result['hydrated'] ?? false,
        force: result['force'] ?? false,
      ).then((_) => Commander.info('File generated successfully!')),
    'bloc' => await FileGenerator.generateBloc(
        fileName,
        hydrated: result['hydrated'] ?? false,
        force: result['force'] ?? false,
      ).then((_) => Commander.info('File generated successfully!')),
    'entity' => await FileGenerator.generateEntity(
        fileName,
        force: result['force'] ?? false,
      ).then((_) => Commander.info('File generated successfully!')),
    'usecase' => await FileGenerator.generateUsecase(
        fileName,
        withParams: result['withParams'] ?? false,
        force: result['force'] ?? false,
      ).then((_) => Commander.info('File generated successfully!')),
    'repository' => await FileGenerator.generateRepository(
        fileName,
        force: result['force'] ?? false,
      ).then((_) => Commander.info('File generated successfully!')),
    'model' => await FileGenerator.generateModel(
        fileName,
        force: result['force'] ?? false,
      ).then((_) => Commander.info('File generated successfully!')),
    'collection' => await FileGenerator.generateCollection(
        fileName,
        force: result['force'] ?? false,
      ).then((_) => Commander.info('File generated successfully!')),
    'datasource' => await FileGenerator.generateDatasource(
        fileName,
        type: result['type'] ?? 'local',
        force: result['force'] ?? false,
      ).then((_) => Commander.info('File generated successfully!')),
    'all' => await FileGenerator.generateAll(
        fileName,
        stateful: result['stateful'] ?? false,
        blocType: result['blocType'] ?? 'bloc',
        dataType: result['dataType'] ?? 'remote',
        hydrated: result['hydrated'] ?? false,
        withParams: result['withParams'] ?? false,
        force: result['force'] ?? false,
      ).then((_) => Commander.info('Files generated successfully!')),
    _ => throw UnimplementedError('File type $fileType is not implemented!'),
  };
}
