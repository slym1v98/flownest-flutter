import '../commander.dart';
import '../models/arg_flag.dart';
import '../models/arg_multi_option.dart';
import '../models/arg_option.dart';

class GenerateFileType {
  final String description;
  final Map<String, dynamic> arguments;

  GenerateFileType({
    required this.description,
    required this.arguments,
  });

  Map<String, ArgOptionModel> get optionArguments => Map.fromEntries(
        arguments.entries.where((entry) => entry.value is ArgOptionModel).toList(),
      ).cast<String, ArgOptionModel>();

  Map<String, ArgFlagModel> get flagArguments => Map.fromEntries(
        arguments.entries.where((entry) => entry.value is ArgFlagModel).toList(),
      ).cast<String, ArgFlagModel>();

  Map<String, ArgMultiOptionModel> get multiOptionArguments => Map.fromEntries(
        arguments.entries.where((entry) => entry.value is ArgMultiOptionModel).toList(),
      ).cast<String, ArgMultiOptionModel>();
}

class GenerateFileTypes {
  static Map<String, GenerateFileType> get fileTypes => {
        'screen': GenerateFileType(
          description: 'Generate a screen',
          arguments: {
            'stateful': ArgFlagModel(
              help: 'Generate a stateful screen',
            )
          },
        ),
        'event': GenerateFileType(
          description: 'Generate an event',
          arguments: {},
        ),
        'state': GenerateFileType(
          description: 'Generate a state',
          arguments: {
            'type': ArgOptionModel(
              help: 'The type of the state',
              question: () async {
                String? value = await Commander.promptChoose(
                  'Choose the type of the state',
                  ['bloc', 'cubit'],
                );
                return value;
              },
            ),
          },
        ),
        'bloc': GenerateFileType(
          description: 'Generate a bloc',
          arguments: {
            'hydrated': ArgFlagModel(
              help: 'Generate a hydrated bloc',
            )
          },
        ),
        'cubit': GenerateFileType(
          description: 'Generate a cubit',
          arguments: {
            'hydrated': ArgFlagModel(
              help: 'Generate a hydrated cubit',
            )
          },
        ),
        'entity': GenerateFileType(
          description: 'Generate an entity',
          arguments: {},
        ),
        'usecase': GenerateFileType(
          description: 'Generate a usecase',
          arguments: {
            'withParams': ArgFlagModel(
              help: 'Generate a usecase with params',
            ),
          },
        ),
        'repository': GenerateFileType(
          description: 'Generate a repository',
          arguments: {},
        ),
        'model': GenerateFileType(
          description: 'Generate a model',
          arguments: {},
        ),
        'collection': GenerateFileType(
          description: 'Generate a collection',
          arguments: {},
        ),
        'datasource': GenerateFileType(
          description: 'Generate a datasource',
          arguments: {
            'type': ArgOptionModel(
              help: 'The type of the datasource',
              question: () async {
                String? value = await Commander.promptChoose(
                  'Choose the type of the datasource',
                  ['local', 'remote'],
                );
                return value;
              },
            ),
          },
        ),
        'all': GenerateFileType(
          description: 'Generate all files',
          arguments: {
            'stateful': ArgFlagModel(
              help: 'Generate a stateful screen',
            ),
            'blocType': ArgOptionModel(
              help: 'The type of the state',
              question: () async {
                String? value = await Commander.promptChoose(
                  'Choose the type of the state',
                  ['bloc', 'cubit'],
                );
                return value;
              },
            ),
            'dataType': ArgOptionModel(
              help: 'The type of the datasource',
              question: () async {
                String? value = await Commander.promptChoose(
                  'Choose the type of the datasource',
                  ['local', 'remote'],
                );
                return value;
              },
            ),
            'hydrated': ArgFlagModel(
              help: 'Generate a hydrated bloc',
            ),
            'withParams': ArgFlagModel(
              help: 'Generate a usecase with params',
            ),
          },
        ),
      };
}
