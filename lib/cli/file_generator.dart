part of 'generator.dart';

class FileGenerator {
  static const bool isDir = false;

  static String _capitalize(String input) {
    return '${input[0].toUpperCase()}${input.substring(1)}';
  }

  static String _toSnakeCase(String input) {
    String snakeCase = input.replaceAllMapped(
      RegExp(r'(?<!^)([A-Z])'),
      (Match match) => '_${match.group(0)}',
    );

    snakeCase = snakeCase.toLowerCase();
    snakeCase = snakeCase.replaceAll(RegExp(r'\s+'), '_');
    snakeCase = snakeCase.replaceAll(RegExp(r'[^a-z0-9_]'), '_');
    snakeCase = snakeCase.replaceAll(RegExp(r'_+'), '_').replaceAll(RegExp(r'^_|_$'), '');

    return snakeCase;
  }

  static String _toPascalCase(String input) {
    return _toSnakeCase(input).replaceAll('_', ' ').split(' ').map((word) {
      return _capitalize(word);
    }).join('');
  }

  static List<String> _splitToPath(String name) {
    List<String> paths = name.split(RegExp(r'[\\/]+'));
    return paths;
  }

  static String _toPath(String name, {String? suffix}) {
    String path = _splitToPath(name)
        .map(
          (splitPath) => _toSnakeCase(splitPath).toLowerCase(),
        )
        .reduce(
          (value, element) => p.join(value, element),
        );
    if (isDir) {
      String partPath = _toSnakeCase(_splitToPath(name).last);
      path = p.join(path, partPath);
    }
    if (suffix != null && !path.endsWith(suffix.toLowerCase())) {
      path += '_${suffix.toLowerCase()}';
    }

    return path;
  }

  static String _toClassName(String name, {String? suffix}) {
    return _toPascalCase(_splitToPath(name).last) + (suffix != null ? _capitalize(suffix) : '');
  }

  static String _toRelativePath(String name, {List<String>? directories = const []}) {
    List<String> paths = _splitToPath(name);
    List<String> clonePaths = paths;
    paths = paths.map((splitPath) => '..').toList();
    if (isDir) {
      paths.add('..');
    }
    paths
      ..removeLast()
      ..addAll(directories as Iterable<String>)
      ..addAll(
        isDir ? clonePaths : clonePaths
          ..removeLast(),
      );
    return paths
        .map(
          (splitPath) => splitPath == '..' ? splitPath : _toSnakeCase(splitPath).toLowerCase(),
        )
        .join('/');
  }

  static Map<String, String> _toStubParams({
    required String name,
    required String suffix,
  }) {
    String partPath = _toSnakeCase(_splitToPath(name).last);
    return {
      'stubType': _capitalize(suffix),
      'partPath': partPath,
      'screenClass': _toClassName(name, suffix: 'screen'),
      'screenPartPath': '${partPath}_screen.dart',
      'stateClass': _toClassName(name, suffix: 'state'),
      'stateInitialClass': _toClassName(name, suffix: 'initial'),
      'stateLoadingClass': _toClassName(name, suffix: 'loading'),
      'stateFailureClass': _toClassName(name, suffix: 'failure'),
      'stateSuccessClass': _toClassName(name, suffix: 'success'),
      'statePartPath': '${partPath}_state.dart',
      'eventClass': _toClassName(name, suffix: 'event'),
      'eventPartPath': '${partPath}_event.dart',
      'blocClass': _toClassName(name, suffix: 'bloc'),
      'blocPartPath': '${partPath}_bloc.dart',
      'cubitClass': _toClassName(name, suffix: 'cubit'),
      'cubitPartPath': '${partPath}_cubit.dart',
      'usecaseClass': _toClassName(name, suffix: 'usecase'),
      'usecasePartPath': '../${_toRelativePath(name)}/${partPath}_usecase.dart',
      'usecaseParamsClass': _toClassName(name, suffix: 'usecaseParams'),
      'usecaseParamsPartPath': '${_toRelativePath(name, directories: [
            AppEnum.usecaseParamsFolder,
          ])}/${partPath}_usecase_params.dart',
      'repositoryClass': _toClassName(name, suffix: 'repository'),
      'repositoryPartPath': '${partPath}_repository.dart',
      'repositoryForImplPartPath': '../../${_toRelativePath(name, directories: [
            AppEnum.domainFolder,
            AppEnum.repositoriesFolder,
          ])}/${partPath}_repository.dart',
      'entityClass': _toClassName(name, suffix: 'entity'),
      'entityPartPath': '${partPath}_entity.dart',
      'entityForModelPartPath': '../../${_toRelativePath(name, directories: [
            AppEnum.domainFolder,
            AppEnum.entitiesFolder,
          ])}/${partPath}_entity.dart',
      'entityForCollectionPartPath': '../../../${_toRelativePath(name, directories: [
            AppEnum.domainFolder,
            AppEnum.entitiesFolder,
          ])}/${partPath}_entity.dart',
      'entityForUsecasePartPath': '../${_toRelativePath(name, directories: [
            AppEnum.entitiesFolder,
          ])}/${partPath}_entity.dart',
      'repositoryImplClass': _toClassName(name, suffix: 'repositoryImpl'),
      'repositoryImplPartPath': '${partPath}_repository_impl.dart',
      'modelClass': _toClassName(name, suffix: 'model'),
      'modelPartPath': '${partPath}_model.dart',
      'modelGPartPath': '${partPath}_model.g.dart',
      'collectionClass': _toClassName(name, suffix: 'collection'),
      'collectionPartPath': '${partPath}_collection.dart',
      'collectionGPartPath': '${partPath}_collection.g.dart',
      'datasourceClass': _toClassName(name, suffix: 'datasource'),
      'datasourcePartPath': '../${_toRelativePath(name)}/${partPath}_datasource.dart',
      'datasourceImplClass': _toClassName(name, suffix: 'datasourceImpl'),
      'datasourceImplPartPath': '${partPath}_datasource_impl.dart',
    };
  }

  static Future<void> generateCode(
    String name, {
    String stub = '',
    String path = '',
    String suffix = '',
    bool force = false,
  }) async {
    Map<String, String> stubParams = _toStubParams(name: name, suffix: suffix);
    String dummyPath = p.join(
      path,
      '${_toPath(name, suffix: suffix)}.dart',
    );
    return await Generator.generateFromStub(
      dummyPath,
      p.join('generator', stub),
      force: force,
      params: stubParams,
    );
  }

  static Future<void> generateScreen(
    String name, {
    bool stateful = false,
    bool force = false,
  }) async {
    await Generator.ensureFileExists('${AppEnum.routesDir}/app_route_paths.dart');
    await generateCode(
      name,
      stub: stateful ? 'stateful_widget.stub' : 'stateless_widget.stub',
      path: AppEnum.screensDir,
      suffix: 'screen',
      force: force,
    );
  }

  static Future<void> generateEvent(
    String name, {
    bool force = false,
    bool onlyEvent = false,
  }) async {
    await generateCode(
      name,
      stub: 'bloc_event${onlyEvent ? '_only' : ''}.stub',
      path: AppEnum.blocsDir,
      suffix: 'event',
      force: force,
    );
  }

  static Future<void> generateState(
    String name, {
    bool force = false,
    String type = 'bloc',
    bool onlyState = false,
  }) async {
    await generateCode(
      name,
      stub:
          type == 'bloc' ? 'bloc_state${onlyState ? '_only' : ''}.stub' : 'cubit_state${onlyState ? '_only' : ''}.stub',
      path: AppEnum.blocsDir,
      suffix: 'state',
      force: force,
    );
  }

  static Future<void> generateCubit(
    String name, {
    bool hydrated = false,
    bool force = false,
  }) async {
    await generateState(name, force: force, type: 'cubit');
    await generateCode(
      name,
      stub: hydrated ? 'hydrated_cubit.stub' : 'cubit.stub',
      path: AppEnum.blocsDir,
      suffix: 'cubit',
      force: force,
    );
  }

  static Future<void> generateBloc(
    String name, {
    bool hydrated = false,
    bool force = false,
  }) async {
    await generateState(name, force: force, type: 'bloc');
    await generateEvent(name, force: force);
    await generateCode(
      name,
      stub: hydrated ? 'hydrated_bloc.stub' : 'bloc.stub',
      path: AppEnum.blocsDir,
      suffix: 'bloc',
      force: force,
    );
  }

  static Future<void> generateEntity(
    String name, {
    bool force = false,
  }) async {
    await generateCode(
      name,
      stub: 'entity.stub',
      path: AppEnum.entitiesDir,
      suffix: 'entity',
      force: force,
    );
  }

  static Future<void> generateUsecase(
    String name, {
    bool force = false,
    bool withParams = false,
  }) async {
    if (withParams) {
      await generateCode(
        name,
        stub: 'usecase_params.stub',
        path: AppEnum.usecaseParamsDir,
        suffix: 'usecase_params',
        force: force,
      );
    }
    await generateEntity(name, force: false);
    await generateCode(
      name,
      stub: withParams ? 'usecase.stub' : 'usecase_empty.stub',
      path: AppEnum.usecasesDir,
      suffix: 'usecase',
      force: force,
    );
  }

  static Future<void> generateRepository(
    String name, {
    bool force = false,
  }) async {
    await generateCode(
      name,
      stub: 'repository_impl.stub',
      path: AppEnum.repositoriesImplDir,
      suffix: 'repository_impl',
      force: force,
    );
    await generateCode(
      name,
      stub: 'repository.stub',
      path: AppEnum.repositoriesDir,
      suffix: 'repository',
      force: force,
    );
  }

  static Future<void> generateModel(
    String name, {
    bool force = false,
  }) async {
    await generateEntity(name, force: false);
    await generateCode(
      name,
      stub: 'model.stub',
      path: AppEnum.modelsDir,
      suffix: 'model',
      force: force,
    );
  }

  static Future<void> generateCollection(
    String name, {
    bool force = false,
  }) async {
    await generateEntity(name, force: false);
    await generateCode(
      name,
      stub: 'collection.stub',
      path: AppEnum.dataSourcesCollectionsDir,
      suffix: 'collection',
      force: force,
    );
  }

  static Future<void> generateDatasource(
    String name, {
    bool force = false,
    String type = 'remote',
  }) async {
    await generateCode(
      name,
      stub: '${type}_datasource_impl.stub',
      path: AppEnum.dataSourcesImplDir,
      suffix: 'datasource_impl',
      force: force,
    );
    return await generateCode(
      name,
      stub: 'datasource.stub',
      path: AppEnum.dataSourcesDir,
      suffix: 'datasource',
      force: force,
    );
  }

  static Future<void> generateAll(
    String name, {
    bool stateful = false,
    String blocType = 'bloc',
    String dataType = 'remote',
    bool hydrated = false,
    bool withParams = false,
    bool force = false,
  }) async {
    await generateScreen(name, stateful: stateful, force: force);
    if (blocType == 'bloc') {
      await generateBloc(name, hydrated: hydrated, force: force);
    }
    if (blocType == 'cubit') {
      await generateCubit(name, hydrated: hydrated, force: force);
    }
    await generateUsecase(name, force: force, withParams: withParams);
    await generateRepository(name, force: force);
    if (dataType == 'remote') {
      await generateModel(name, force: force);
    }
    if (dataType == 'local') {
      await generateCollection(name, force: force);
    }

    await generateCollection(name, force: force);
    await generateDatasource(name, force: force, type: dataType);
    return;
  }
}
