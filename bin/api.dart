import 'dart:convert';
import 'dart:io';
import 'package:kappa/cli/commander.dart';
import 'package:kappa/cli/api_generator.dart';

Future<void> main(List<String> args) async {
  if (args.isEmpty) {
    await Commander.info('Usage: dart run kappa:api <path_to_schema.json>');
    await Commander.info('\nExample schema.json:');
    await Commander.info('''
{
  "name": "User",
  "fields": {
    "id": "String",
    "name": "String",
    "email": "String",
    "age": "int"
  },
  "endpoints": {
    "getUsers": {
      "method": "GET",
      "path": "/users"
    }
  }
}''');
    return;
  }

  final schemaFile = File(args[0]);
  if (!schemaFile.existsSync()) {
    await Commander.info('Error: Schema file not found at \${args[0]}');
    return;
  }

  try {
    final String content = await schemaFile.readAsString();
    final Map<String, dynamic> schema = jsonDecode(content);

    final String name = schema['name'] ?? 'Generated';
    await Commander.info('----------------------------------------------------');
    await Commander.info('🚀 KAPPA API: Generating Advanced Feature: $name');
    await Commander.info('----------------------------------------------------');

    await ApiGenerator.generateFromSchema(schema, force: true);

    await Commander.info('\n✅ Done! Feature "$name" has been generated with dynamic fields.');
    await Commander.info('Next: Run "dart run kappa build" to generate JSON serializable code.');
  } catch (e) {
    await Commander.info('Error parsing schema: \$e');
  }
}
