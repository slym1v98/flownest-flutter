import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'package:path/path.dart' as p;
import 'package:xml/xml.dart';
import 'package:yaml/yaml.dart';
import 'package:yaml_writer/yaml_writer.dart';

import '../src/core/app_enum.dart';
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

  static Future<KappaConfig> readYaml(String fileName) async {
    String yamlString = await File(fileName).readAsString();
    final yamlMap = loadYaml(yamlString);
    final map = convertYamlToMap(yamlMap);
    return KappaConfig.fromMap(map);
  }

  static Map<String, dynamic> convertYamlToMap(YamlMap yamlMap) {
    final map = <String, dynamic>{};

    yamlMap.forEach((key, value) {
      if (value is YamlMap) {
        map[key.toString()] = convertYamlToMap(value);
      } else if (value is YamlList) {
        map[key.toString()] = value.toList();
      } else {
        map[key.toString()] = value;
      }
    });

    return map;
  }

  static Future<void> generateYaml(
    String fileName,
    Map<String, dynamic> content, {
    bool force = false,
  }) async {
    if (!force && File(fileName).existsSync()) {
      return;
    }

    final yamlFile = File(fileName);
    if (!yamlFile.existsSync()) {
      yamlFile.createSync(recursive: true);
    }
    final yamlWriter = YamlWriter();
    final modifiedYamlString = yamlWriter.write(content);
    yamlFile.writeAsStringSync(modifiedYamlString);
  }

  static Future<void> updatePubspecYaml({
    Map<String, dynamic> Function(Map<String, dynamic>)? modifiedYamlCallback,
  }) async {
    final pubspecFile = File('pubspec.yaml');
    String yamlString = pubspecFile.readAsStringSync();
    final yamlMap = loadYaml(yamlString);

    Map<String, dynamic> modifiedYamlMap = Map<String, dynamic>.from(yamlMap as Map);

    if (!modifiedYamlMap.containsKey('flutter')) {
      modifiedYamlMap['flutter'] = {
        'assets': [],
      };
    }
    if (!(modifiedYamlMap['flutter'] as Map).containsKey('assets')) {
      var flutter = {
        ...(modifiedYamlMap['flutter'] as Map),
        'assets': [],
      };
      modifiedYamlMap['flutter'] = flutter;
    }

    Map<String, dynamic> modifiedYamlMapCalled = {};
    if (modifiedYamlCallback != null) {
      modifiedYamlMapCalled = modifiedYamlCallback(modifiedYamlMap);
      modifiedYamlMap = modifiedYamlMapCalled;
    }

    final yamlWriter = YamlWriter();
    final modifiedYamlString = yamlWriter.write(modifiedYamlMap);

    pubspecFile.writeAsStringSync(modifiedYamlString);
  }

  static Future<void> updateXcconfigFile(
    String filePath,
    Map<String, String> updates,
  ) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception('File not found: $filePath');
    }

    List<String> lines = await file.readAsLines();
    updates.forEach((key, value) {
      bool found = false;
      for (int i = 0; i < lines.length; i++) {
        if (lines[i].startsWith('#include')) {
          continue; // Skip #include lines
        }
        if (lines[i].startsWith(key)) {
          lines[i] = '$key=$value';
          found = true;
          break;
        }
      }
      if (!found) {
        lines.add('$key=$value');
      }
    });

    await file.writeAsString(lines.join('\n'));
  }

  static Future<void> generateIdeaRunConfigurations(
    String filePath,
    String flavor,
  ) async {
    final file = File(filePath);

    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }

    final builder = XmlBuilder();

    builder.element('component', attributes: {'name': 'ProjectRunConfigurationManager'}, nest: () {
      builder.element('configuration', attributes: {
        'default': 'false',
        'name': 'main_$flavor.dart',
        'type': 'FlutterRunConfigurationType',
        'factoryName': 'Flutter',
      }, nest: () {
        builder.element('option', attributes: {
          'name': 'buildFlavor',
          'value': flavor,
        });

        builder.element('option', attributes: {
          'name': 'filePath',
          'value': '\$PROJECT_DIR\$/${AppEnum.libDir}/main.dart',
        });

        builder.element('option', attributes: {
          'name': 'additionalArgs',
          'value': '--dart-define=FLAVOR=$flavor',
        });

        builder.element('method', attributes: {
          'v': '2',
        });
      });
    });

    String content = builder.buildDocument().toXmlString(pretty: true);
    await file.writeAsString(content);
  }

  static Future<void> updateInfoPlist({
    required String plistPath,
    required List<String> localizations,
  }) async {
    final file = File(plistPath);
    if (!file.existsSync()) {
      throw Exception('Info.plist file not found at $plistPath');
    }

    final document = XmlDocument.parse(await file.readAsString());
    final dictElement = document.findAllElements('dict').first;

    // Collect elements to be removed
    final elementsToRemove = <XmlElement>[];
    dictElement.findElements('key').where((element) => element.innerText == 'CFBundleLocalizations').forEach((element) {
      elementsToRemove.add(element);
      if (element.nextElementSibling != null) {
        elementsToRemove.add(element.nextElementSibling!);
      }
    });

    // Remove collected elements
    for (var element in elementsToRemove) {
      element.parent?.children.remove(element);
    }

    // Create new CFBundleLocalizations element
    final localizationsKey = XmlElement(XmlName('key'), [], [XmlText('CFBundleLocalizations')]);
    final localizationsArray = XmlElement(
      XmlName('array'),
      [],
      localizations
          .map(
            (locale) => XmlElement(XmlName('string'), [], [XmlText(locale)]),
          )
          .toList(),
    );

    // Add new elements to the dict
    dictElement.children.add(localizationsKey);
    dictElement.children.add(localizationsArray);

    // Write the updated content back to the file
    await file.writeAsString(
      document.toXmlString(pretty: true, indent: '  '),
    );
  }

  static String generateAppKey() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256));
    return base64.encode(bytes);
  }

  static Future<void> ensureDirectoryExists(
    String path, {
    bool recursive = true,
    bool force = false,
  }) async {
    final directory = Directory(path);
    if (force && await directory.exists()) {
      await directory.delete(recursive: true);
    }
    if (!await directory.exists()) {
      await directory.create(recursive: recursive);
    }
  }

  static Future<void> ensureFileExists(
    String path, {
    bool force = false,
    String? content,
  }) async {
    final file = File(path);
    if (force && await file.exists()) {
      await file.delete();
    }
    if (!await file.exists()) {
      await file.writeAsString(content ?? '');
    }
  }
}
