import 'dart:io';
import 'dart:math';
import 'dart:convert';

class Commander {
  Commander._();

  static Future<void> run(String command, List<String> args) async {
    ProcessResult result = await Process.run(command, args);
    if (result.exitCode != 0) {
      stdout.writeln(result.stderr);
      exit(result.exitCode);
    }

    stdout.writeln(result.stdout);
  }

  static Future<void> dart(String command, List<String> args) async {
    await run('dart', [command, ...args]);
  }

  static Future<void> flutter(String command, List<String> args) async {
    await run('flutter', [command, ...args]);
  }

  static Future<void> info(String message) async {
    stdout.writeln(message);
  }

  static Future<void> table(List<List<String>> rows, {List<String>? header}) async {
    int columnCount = header?.length ?? rows[0].length;
    List<int> columnWidths = List<int>.filled(columnCount + 1, 0);

    if (header != null) {
      header.insert(0, '#');
      for (int i = 0; i < columnCount + 1; i++) {
        columnWidths[i] = max(columnWidths[i], header[i].length);
      }
    }

    for (int i = 0; i < columnCount; i++) {
      columnWidths[i + 1] = rows.fold(columnWidths[i + 1], (maximum, row) => max(maximum, row[i].length));
    }

    if (header != null) {
      for (int i = 0; i < columnCount + 1; i++) {
        stdout.write(header[i].padRight(columnWidths[i] + 2));
        if (i < columnCount) {
          stdout.write('| ');
        }
      }
      stdout.writeln();
      stdout.writeln('-' * columnWidths.reduce((a, b) => a + b + 2 * (columnCount + 1) + columnCount * 2));
    }

    for (int i = 0; i < rows.length; i++) {
      stdout.write((i + 1).toString().padRight(columnWidths[0] + 2));
      stdout.write('| ');
      for (int j = 0; j < columnCount; j++) {
        stdout.write(rows[i][j].padRight(columnWidths[j + 1] + 2));
        if (j < columnCount - 1) {
          stdout.write('| ');
        }
      }
      stdout.writeln();
    }
  }

  static Future<String> prompt(String question, {bool required = false}) async {
    stdout.write('$question: ');
    String? input = stdin.readLineSync(encoding: utf8)?.trim();
    if (required && (input == null || input.isEmpty)) {
      return await prompt(question, required: required);
    }
    return input ?? '';
  }

  static Future<String> promptChoose(String question, List<String> options) async {
    while (true) {
      stdout.writeln(question);
      for (int i = 0; i < options.length; i++) {
        stdout.writeln('${i + 1}. ${options[i]}');
      }
      stdout.write('Enter the number of your choice: ');
      String? input = stdin.readLineSync(encoding: utf8)?.trim();

      int? choice = int.tryParse(input ?? '');
      if (choice != null && choice > 0 && choice <= options.length) {
        return options[choice - 1];
      } else {
        stdout.writeln('Invalid choice. Please enter a number between 1 and ${options.length}.');
      }
    }
  }
}
