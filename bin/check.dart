import 'dart:io';
import 'package:kappa/cli/commander.dart';
import 'package:path/path.dart' as p;

Future<void> main(List<String> args) async {
  await Commander.info('====================================================');
  await Commander.info('         KAPPA ARCHITECTURE LINTER (CHECK)          ');
  await Commander.info('====================================================');

  final directory = Directory('lib/src');
  if (!directory.existsSync()) {
    await Commander.info('Error: lib/src directory not found.');
    return;
  }

  int violations = 0;
  List<FileSystemEntity> files = directory.listSync(recursive: true);

  for (var file in files) {
    if (file is File && file.path.endsWith('.dart')) {
      violations += await _checkFile(file);
    }
  }

  if (violations == 0) {
    await Commander.info('
✅ No architecture violations found. Keep it clean!');
  } else {
    await Commander.info('
❌ Total violations found: $violations');
    exit(1);
  }
}

Future<int> _checkFile(File file) async {
  final content = await file.readAsString();
  final lines = content.split('
');
  final filePath = file.path.replaceAll('', '/');
  int fileViolations = 0;

  for (var line in lines) {
    if (line.trim().startsWith('import ')) {
      // Check Domain layer
      if (filePath.contains('/domain/')) {
        if (line.contains('/data/') || line.contains('/presentation/')) {
          _printViolation(filePath, line, 'Domain layer should not depend on Data or Presentation layers.');
          fileViolations++;
        }
      }
      
      // Check Data layer
      if (filePath.contains('/data/')) {
        if (line.contains('/presentation/')) {
          _printViolation(filePath, line, 'Data layer should not depend on Presentation layer.');
          fileViolations++;
        }
      }

      // Check Core layer
      if (filePath.contains('/core/')) {
        if (line.contains('/data/') || line.contains('/domain/') || line.contains('/presentation/')) {
          _printViolation(filePath, line, 'Core layer should be independent of other layers.');
          fileViolations++;
        }
      }
    }
  }
  return fileViolations;
}

void _printViolation(String path, String line, String reason) {
  print('----------------------------------------------------');
  print('📍 File: $path');
  print('⚠️ Violation: ${line.trim()}');
  print('📝 Reason: $reason');
}
