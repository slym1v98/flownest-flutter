import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'package:path/path.dart' as p;
import 'package:xml/xml.dart';
import 'package:yaml/yaml.dart';
import 'package:yaml_writer/yaml_writer.dart';

import '../src/core/app_enum.dart';
import 'commander.dart'; // Import Commander for info messages
import 'kappa_config.dart';

part 'file_generator.dart';

class Generator {
  Generator._();

  static Future<void> generate(
    String fileName,
    String content, {
    bool force = false,
  }) async {
    if (force && File(fileName).existsSync()) {
      File(fileName).deleteSync(recursive: true);
    }

    String filePath = p.dirname(fileName);
    Directory(filePath).createSync(recursive: true);
    File(fileName).writeAsStringSync(content);
  }

  static Future<void> generateFromStub(
    String fileName,
    String stubPath, {
    bool force = false,
    Map<String, String>? params,
  }) async {
    if (File(fileName).existsSync() && !force) {
      Commander.info('File already exists and --force not used: $fileName'); // Add info message
      return;
    }

    String stubFolderPath = (await Isolate.resolvePackageUri(
      Uri.parse('package:kappa/cli/stubs'),
    ))!
        .path;
    var stubContent = File(p.join(stubFolderPath, stubPath)).readAsStringSync();
    if (params != null) {
      params.forEach((key, value) {
        stubContent = stubContent.replaceAll('{{$key}}', value.toString());
      });
    }

    return await generate(
      fileName,
      stubContent,
      force: force,
    );
  }

  static Future<void> generateFeature(
    String featureName, {
    bool force = false,
  }) async {
    final String snakeCaseName = featureName.toLowerCase();
    final String pascalCaseName = _snakeCaseToPascalCase(snakeCaseName);

    final Map<String, String> params = {
      'feature_name_snake': snakeCaseName,
      'feature_name_pascal': pascalCaseName,
    };

    // Define base path for feature
    final String featureBasePath = 'lib/src/features/$snakeCaseName';

    // Create directories
    await ensureDirectoryExists('$featureBasePath/data/datasources');
    await ensureDirectoryExists('$featureBasePath/data/models');
    await ensureDirectoryExists('$featureBasePath/data/repositories');
    await ensureDirectoryExists('$featureBasePath/domain/entities');
    await ensureDirectoryExists('$featureBasePath/domain/usecases');
    await ensureDirectoryExists('$featureBasePath/presentation/bloc');
    await ensureDirectoryExists('$featureBasePath/presentation/pages');


    // Generate files from stubs
    await Commander.info('Generating data layer for $featureName...');
    await generateFromStub(
      '$featureBasePath/data/datasources/${snakeCaseName}_remote_data_source.dart',
      'generator/feature/data/datasources/remote_data_source.stub',
      force: force,
      params: params,
    );
    await generateFromStub(
      '$featureBasePath/data/datasources/${snakeCaseName}_local_data_source.dart',
      'generator/feature/data/datasources/local_data_source.stub',
      force: force,
      params: params,
    );
    await generateFromStub(
      '$featureBasePath/data/models/${snakeCaseName}_model.dart',
      'generator/feature/data/models/model.stub',
      force: force,
      params: params,
    );
    await generateFromStub(
      '$featureBasePath/data/repositories/${snakeCaseName}_repository_impl.dart',
      'generator/feature/data/repositories/repository_impl.stub',
      force: force,
      params: params,
    );

    await Commander.info('Generating domain layer for $featureName...');
    await generateFromStub(
      '$featureBasePath/domain/entities/${snakeCaseName}_entity.dart',
      'generator/feature/domain/entities/entity.stub',
      force: force,
      params: params,
    );
    await generateFromStub(
      '$featureBasePath/domain/repositories/${snakeCaseName}_repository.dart',
      'generator/feature/domain/repositories/repository.stub',
      force: force,
      params: params,
    );
    await generateFromStub(
      '$featureBasePath/domain/usecases/get_${snakeCaseName}_usecase.dart',
      'generator/feature/domain/usecases/get_usecase.stub',
      force: force,
      params: params,
    );

    await Commander.info('Generating presentation layer for $featureName...');
    await generateFromStub(
      '$featureBasePath/presentation/bloc/${snakeCaseName}_bloc.dart',
      'generator/feature/presentation/bloc/bloc.stub',
      force: force,
      params: params,
    );
    await generateFromStub(
      '$featureBasePath/presentation/bloc/${snakeCaseName}_event.dart',
      'generator/feature/presentation/bloc/event.stub',
      force: force,
      params: params,
    );
    await generateFromStub(
      '$featureBasePath/presentation/bloc/${snakeCaseName}_state.dart',
      'generator/feature/presentation/bloc/state.stub',
      force: force,
      params: params,
    );
    await generateFromStub(
      '$featureBasePath/presentation/pages/${snakeCaseName}_page.dart',
      'generator/feature/presentation/pages/page.stub',
      force: force,
      params: params,
    );
    await Commander.info('--------------- Feature: $featureName Generated ------------------');
  }

  static Future<void> generateModel( // NEW METHOD
    String modelName, {
    bool force = false,
  }) async {
    final String snakeCaseName = modelName.toLowerCase();
    final String pascalCaseName = _snakeCaseToPascalCase(snakeCaseName);

    final Map<String, String> params = {
      'model_name_snake': snakeCaseName,
      'model_name_pascal': pascalCaseName,
    };

    // Define path for model
    final String modelFilePath = 'lib/src/data/models/$snakeCaseName/$snakeCaseName.dart';

    // Ensure directory exists
    await ensureDirectoryExists('lib/src/data/models/$snakeCaseName');

    // Generate model file from stub
    await Commander.info('Generating model: $modelName...');
    await generateFromStub(
      modelFilePath,
      'generator/model/model.stub', // Stub for model
      force: force,
      params: params,
    );
  }

  static String _snakeCaseToPascalCase(String text) {
    if (text.isEmpty) return '';
    return text.split('_').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join();
  }
}