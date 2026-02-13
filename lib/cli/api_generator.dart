import 'dart:io';
import 'package:path/path.dart' as p;
import 'generator.dart';
import '../src/core/app_enum.dart';

class ApiGenerator {
  ApiGenerator._();

  static Future<void> generateFromSchema(Map<String, dynamic> schema, {bool force = false}) async {
    final String name = schema['name'];
    final Map<String, dynamic> fields = schema['fields'] ?? {};
    final String snakeName = name.toLowerCase();
    final String pascalName = _toPascalCase(name);
    
    final String featurePath = 'lib/src/features/$snakeName';

    // 1. Generate Folder Structure
    await Generator.generateFeature(name, force: force);

    // 2. Generate Entity
    await _generateEntity(featurePath, snakeName, pascalName, fields, force);

    // 3. Generate Model
    await _generateModel(featurePath, snakeName, pascalName, fields, force);

    // 4. Generate DataSource
    await _generateDataSource(featurePath, snakeName, pascalName, schema['endpoints'] ?? {}, force);

    // 5. Generate Repository Interface
    await _generateRepository(featurePath, snakeName, pascalName, schema['endpoints'] ?? {}, force);

    // 6. Generate Repository Implementation
    await _generateRepositoryImpl(featurePath, snakeName, pascalName, schema['endpoints'] ?? {}, force);

    // 7. Generate UseCases
    await _generateUseCases(featurePath, snakeName, pascalName, schema['endpoints'] ?? {}, force);

    // 8. Generate DI Registration
    await _generateDI(featurePath, snakeName, pascalName, schema['endpoints'] ?? {}, force);
  }

  static Future<void> _generateDI(String path, String snake, String pascal, Map<String, dynamic> endpoints, bool force) async {
    final buffer = StringBuffer();
    buffer.writeln("import 'package:kappa/kappa.dart';");
    buffer.writeln("import 'data/datasources/${snake}_remote_data_source.dart';");
    buffer.writeln("import 'data/repositories/${snake}_repository_impl.dart';");
    buffer.writeln("import 'domain/repositories/${snake}_repository.dart';");
    
    endpoints.keys.forEach((key) {
      final String fileName = _toSnakeCase(key);
      buffer.writeln("import 'domain/usecases/${fileName}_usecase.dart';");
    });

    buffer.writeln("\nclass ${pascal}DI {");
    buffer.writeln("  static void init() {");
    buffer.writeln("    SL.initFeatureServices((i) {");
    buffer.writeln("      i.registerLazySingleton<${pascal}RemoteDataSource>(() => ${pascal}RemoteDataSourceImpl(i()));");
    buffer.writeln("      i.registerLazySingleton<${pascal}Repository>(() => ${pascal}RepositoryImpl(i()));");
    
    endpoints.keys.forEach((key) {
      final String useCaseName = _toPascalCase(key);
      buffer.writeln("      i.registerLazySingleton<${useCaseName}UseCase>(() => ${useCaseName}UseCase(i()));");
    });

    buffer.writeln("    });");
    buffer.writeln("  }");
    buffer.writeln("}");

    final file = File('$path/${snake}_di.dart');
    await file.writeAsString(buffer.toString());
  }

  static Future<void> _generateUseCases(String path, String snake, String pascal, Map<String, dynamic> endpoints, bool force) async {
    endpoints.forEach((key, value) async {
      final buffer = StringBuffer();
      final String useCaseName = _toPascalCase(key);
      final String responseType = value['responseType'] ?? '${pascal}Model';
      final bool isList = responseType.contains('List<');
      final String entityType = isList ? "ListOf<${pascal}Entity>" : "Single<${pascal}Entity>";

      buffer.writeln("import 'package:dartz/dartz.dart';");
      buffer.writeln("import 'package:kappa/kappa.dart';");
      buffer.writeln("import '../../domain/repositories/${snake}_repository.dart';");
      buffer.writeln("import '../../domain/entities/${snake}_entity.dart';\n");

      buffer.writeln("class ${useCaseName}UseCase extends BaseSimpleUseCase<BaseException, $entityType, NoParams> {");
      buffer.writeln("  final ${pascal}Repository repository;\n");
      buffer.writeln("  ${useCaseName}UseCase(this.repository);");

      buffer.writeln("\n  @override");
      buffer.writeln("  Future<Either<BaseException, $entityType>> execute(NoParams params) {");
      buffer.writeln("    return repository.$key();");
      buffer.writeln("  }");
      buffer.writeln("}");

      final String fileName = _toSnakeCase(key);
      final file = File('$path/domain/usecases/${fileName}_usecase.dart');
      await file.writeAsString(buffer.toString());
    });
  }

  static String _toSnakeCase(String input) {
    return input.replaceAllMapped(RegExp(r'(?<!^)([A-Z])'), (Match match) => '_${match.group(0)}').toLowerCase();
  }

  static Future<void> _generateRepository(String path, String snake, String pascal, Map<String, dynamic> endpoints, bool force) async {
    final buffer = StringBuffer();
    buffer.writeln("import 'package:dartz/dartz.dart';");
    buffer.writeln("import 'package:kappa/kappa.dart';");
    buffer.writeln("import '../entities/${snake}_entity.dart';\n");
    buffer.writeln("abstract class ${pascal}Repository extends BaseRepository {");

    endpoints.forEach((key, value) {
      final String responseType = value['responseType'] ?? '${pascal}Model';
      final bool isList = responseType.contains('List<');
      final String entityType = isList ? "ListOf<${pascal}Entity>" : "Single<${pascal}Entity>";
      
      buffer.writeln("  Future<Either<BaseException, $entityType>> $key();");
    });

    buffer.writeln("}");

    final file = File('$path/domain/repositories/${snake}_repository.dart');
    await file.writeAsString(buffer.toString());
  }

  static Future<void> _generateRepositoryImpl(String path, String snake, String pascal, Map<String, dynamic> endpoints, bool force) async {
    final buffer = StringBuffer();
    buffer.writeln("import 'package:dartz/dartz.dart';");
    buffer.writeln("import 'package:kappa/kappa.dart';");
    buffer.writeln("import '../../domain/repositories/${snake}_repository.dart';");
    buffer.writeln("import '../../domain/entities/${snake}_entity.dart';");
    buffer.writeln("import '../datasources/${snake}_remote_data_source.dart';\n");
    
    buffer.writeln("class ${pascal}RepositoryImpl extends BaseRepositoryImpl implements ${pascal}Repository {");
    buffer.writeln("  final ${pascal}RemoteDataSource remoteDataSource;\n");
    buffer.writeln("  ${pascal}RepositoryImpl(this.remoteDataSource);");

    endpoints.forEach((key, value) {
      final String responseType = value['responseType'] ?? '${pascal}Model';
      final bool isList = responseType.contains('List<');
      final String entityType = isList ? "ListOf<${pascal}Entity>" : "Single<${pascal}Entity>";

      buffer.writeln("\n  @override");
      buffer.writeln("  Future<Either<BaseException, $entityType>> $key() async {");
      buffer.writeln("    return handleRequest(");
      buffer.writeln("      remoteRequest: () => remoteDataSource.$key(),");
      if (isList) {
        buffer.writeln("    ).then((result) => result.map((models) => ListOf(models.map((m) => m.toEntity()).toList())));");
      } else {
        buffer.writeln("    ).then((result) => result.map((model) => Single(model.toEntity())));");
      }
      buffer.writeln("  }");
    });

    buffer.writeln("}");

    final file = File('$path/data/repositories/${snake}_repository_impl.dart');
    await file.writeAsString(buffer.toString());
  }

  static Future<void> _generateEntity(String path, String snake, String pascal, Map<String, dynamic> fields, bool force) async {
    final buffer = StringBuffer();
    buffer.writeln("import 'package:kappa/kappa.dart';
");
    buffer.writeln("class ${pascal}Entity extends BaseEntity {");
    
    fields.forEach((key, value) => buffer.writeln("  final $value $key;"));
    
    buffer.writeln("
  const ${pascal}Entity({");
    fields.forEach((key, value) => buffer.writeln("    required this.$key,"));
    buffer.writeln("  });");
    
    buffer.writeln("
  @override");
    buffer.writeln("  List<Object?> get props => [${fields.keys.join(', ')}];");
    buffer.writeln("}");

    final file = File('$path/domain/entities/${snake}_entity.dart');
    await file.writeAsString(buffer.toString());
  }

  static Future<void> _generateModel(String path, String snake, String pascal, Map<String, dynamic> fields, bool force) async {
    final buffer = StringBuffer();
    buffer.writeln("import 'package:json_annotation/json_annotation.dart';");
    buffer.writeln("import 'package:kappa/kappa.dart';");
    buffer.writeln("import '../../domain/entities/${snake}_entity.dart';
");
    buffer.writeln("part '${snake}_model.g.dart';
");
    buffer.writeln("@JsonSerializable()");
    buffer.writeln("class ${pascal}Model extends BaseModel<${pascal}Model, ${pascal}Entity> {");
    
    fields.forEach((key, value) => buffer.writeln("  final $value? $key;"));
    
    buffer.writeln("
  const ${pascal}Model({");
    fields.forEach((key, value) => buffer.writeln("    this.$key,"));
    buffer.writeln("  });");

    buffer.writeln("
  factory ${pascal}Model.fromJson(Map<String, dynamic> json) => _\$${pascal}ModelFromJson(json);");
    buffer.writeln("  Map<String, dynamic> toJson() => _\$${pascal}ModelToJson(this);");

    buffer.writeln("
  @override");
    buffer.writeln("  ${pascal}Entity toEntity() => ${pascal}Entity(");
    fields.forEach((key, value) => buffer.writeln("    $key: $key ?? ${_getDefaultValue(value)},"));
    buffer.writeln("  );");

    buffer.writeln("
  @override");
    buffer.writeln("  List<Object?> get props => [${fields.keys.join(', ')}];");
    buffer.writeln("}");

    final file = File('$path/data/models/${snake}_model.dart');
    await file.writeAsString(buffer.toString());
  }

  static Future<void> _generateDataSource(String path, String snake, String pascal, Map<String, dynamic> endpoints, bool force) async {
    final buffer = StringBuffer();
    buffer.writeln("import 'package:kappa/kappa.dart';");
    buffer.writeln("import '../models/${snake}_model.dart';
");
    buffer.writeln("abstract class ${pascal}RemoteDataSource {");
    
    endpoints.forEach((key, value) {
      final String method = value['method'] ?? 'GET';
      final String responseType = value['responseType'] ?? '${pascal}Model';
      buffer.writeln("  Future<$responseType> $key();");
    });
    
    buffer.writeln("}");

    final file = File('$path/data/datasources/${snake}_remote_data_source.dart');
    await file.writeAsString(buffer.toString());
  }

  static String _toPascalCase(String text) {
    return text[0].toUpperCase() + text.substring(1);
  }

  static String _getDefaultValue(String type) {
    switch (type) {
      case 'String': return "''";
      case 'int': return '0';
      case 'double': return '0.0';
      case 'bool': return 'false';
      default: return 'null';
    }
  }
}
