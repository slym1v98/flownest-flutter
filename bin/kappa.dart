import 'dart:io';

import 'package:args/args.dart';
import 'package:fpdart/fpdart.dart';
import 'package:kappa/cli/commander.dart';
import 'package:kappa/cli/generator.dart';
import 'package:kappa/src/core/app_enum.dart';

/// The main command-line tool for initializing and configuring a Flutter project with Kappa.
///
/// This script orchestrates the complete setup process:
/// - Generates initial kappa.yaml configuration
/// - Sets up environment configurations
/// - Configures build flavors
/// - Sets up launcher icons
/// - Configures localization
/// - Creates core project structure and files
/// - Updates pubspec.yaml with required dependencies
///
/// Usage: dart run kappa [-f|--force]
Future<void> main(List<String> args) async {
  try {
    final ArgParser parser = ArgParser();
    parser.addFlag('force', abbr: 'f', help: 'Force action');
    
    parser.addCommand('install', ArgParser()..addFlag('force', abbr: 'f'));
    parser.addCommand('build', ArgParser());
    parser.addCommand('watch', ArgParser());
    parser.addCommand('doctor', ArgParser());
    parser.addCommand('check', ArgParser());
    parser.addCommand('asset', ArgParser());
    parser.addCommand('api', ArgParser());

    final ArgResults argResults = parser.parse(args);

    if (argResults.command != null) {
      switch (argResults.command!.name) {
        case 'install':
          await _handleInstall(argResults.command!['force'] ?? false);
          break;
        case 'build':
          await _handleBuild();
          break;
        case 'watch':
          await _handleWatch();
          break;
        case 'doctor':
          await _handleDoctor();
          break;
        case 'check':
          await Commander.dart('run', ['kappa:check']);
          break;
        case 'asset':
          await Commander.dart('run', ['kappa:asset']);
          break;
        case 'api':
          await Commander.dart('run', ['kappa:api', ...argResults.command!.rest]);
          break;
        default:
          await Commander.info('Unknown command: ${argResults.command!.name}');
      }
      return;
    }

    // Default behavior: Installation if kappa.yaml doesn't exist, else show help
    if (!File('kappa.yaml').existsSync()) {
      await _handleInstall(argResults['force'] ?? false);
    } else {
      await Commander.info('Kappa CLI Tool');
      await Commander.info('Usage: dart run kappa <command> [arguments]');
      await Commander.info('\nAvailable commands:');
      await Commander.table([
        ['install', 'Install/Initialize Kappa in the project'],
        ['build', 'Run build_runner build'],
        ['watch', 'Run build_runner watch'],
        ['doctor', 'Check project health and Kappa configuration'],
        ['check', 'Check architecture violations (Lint)'],
        ['asset', 'Generate AppAssets constant file'],
        ['api', 'Generate feature layers from API schema'],
        ['generate', 'Generate code (features, models, etc.)'],
      ], header: ['Command', 'Description']);
    }
  } catch (e) {
    await Commander.info('[${e.runtimeType}] ${e.toString()}');
  }
}

Future<void> _handleInstall(bool force) async {
  await Commander.info('Kappa has been installing...');

  /// Generate kappa installation configurations file
  if (!File('kappa.yaml').existsSync() || force) {
    List<String> generateCommandArgs = ['kappa:generate'];
    if (force) {
      generateCommandArgs.add('--force');
    }
    await Commander.dart('run', generateCommandArgs);
    await Commander.info('Check your kappa configurations before run installation (kappa.yaml)');
    if (!force) return;
  }

  /// Run installation commands
  List<String> commands = [
    'kappa:env',
    'kappa:flavor',
    'kappa:launcher_icon',
    'kappa:l10n',
  ];
  for (final command in commands) {
    List<String> commandArgs = [command];
    if (force) {
      commandArgs.add('--force');
    }
    await Commander.info('Run command: ${['dart', 'run', ...commandArgs].join(" ")}');
    await Commander.dart('run', commandArgs);
  }

  // Core structure
  await Generator.ensureDirectoryExists(AppEnum.routesDir);
  await Generator.generateFromStub(
    '${AppEnum.routesDir}/app_routes.dart',
    'common/app_routes.stub',
    force: force,
  );
  await Generator.generateFromStub(
    '${AppEnum.routesDir}/app_route_paths.dart',
    'common/app_route_paths.stub',
    force: force,
  );
  await Generator.ensureFileExists(
    '${AppEnum.coreDir}/core_exporter.dart',
    content: "export 'routes/app_routes.dart';",
  );

  // Data structure
  await Generator.ensureDirectoryExists(AppEnum.dataSourcesImplDir);
  await Generator.ensureDirectoryExists(AppEnum.modelsDir);
  await Generator.ensureDirectoryExists(AppEnum.repositoriesImplDir);
  await Generator.ensureFileExists('${AppEnum.dataDir}/data_exporter.dart');

  // Domain structure
  await Generator.ensureDirectoryExists(AppEnum.entitiesDir);
  await Generator.ensureDirectoryExists(AppEnum.repositoriesDir);
  await Generator.ensureDirectoryExists(AppEnum.usecaseParamsDir);
  await Generator.ensureFileExists('${AppEnum.domainDir}/domain_exporter.dart');

  // Presentation structure
  await Generator.ensureDirectoryExists(AppEnum.screensDir);
  await Generator.generateFromStub(
    '${AppEnum.screensDir}/home_screen.dart',
    'common/home_screen.stub',
    force: force,
  );
  await Generator.ensureDirectoryExists(AppEnum.widgetsDir);
  await Generator.ensureDirectoryExists(AppEnum.blocsDir);
  await Generator.ensureFileExists('${AppEnum.presentationDir}/presentation_exporter.dart');

  // Main file
  await Generator.generateFromStub(
    '${AppEnum.sourceDir}/injector.dart',
    'common/injector.stub',
    force: force,
  );
  await Generator.generateFromStub(
    '${AppEnum.libDir}/main.dart',
    'common/main.stub',
    force: true,
  );

  await Generator.updatePubspecYaml(
    modifiedYamlCallback: (modifiedYamlMap) {
      Map<String, dynamic> modifiedYaml = Map<String, dynamic>.from(modifiedYamlMap);

      // Add dependencies
      modifiedYaml['dependencies'] = Map<String, dynamic>.from(modifiedYaml['dependencies'] as Map);
      modifiedYaml['dependencies']['another_flutter_splash_screen'] = '^1.2.1';
      modifiedYaml['dependencies']['auto_route'] = '^9.0.0';
      modifiedYaml['dependencies']['dartz'] = '^0.10.0';
      modifiedYaml['dependencies']['dio'] = '^5.4.3+1';
      modifiedYaml['dependencies']['flutter_bloc'] = '^8.1.5';
      modifiedYaml['dependencies']['flutter_screenutil'] = '^5.0.0+2';
      modifiedYaml['dependencies']['isar'] = '^3.1.0+1';
      modifiedYaml['dependencies']['isar_flutter_libs'] = '^3.1.0+1';
      modifiedYaml['dependencies']['json_annotation'] = '^4.9.0';
      modifiedYaml['dependencies']['path'] = '^1.8.0';
      modifiedYaml['dependencies']['path_provider'] = '^2.1.3';
      modifiedYaml['dependencies']['flutter_dotenv'] = '^5.1.0';

      // Add dev_dependencies
      modifiedYaml['dev_dependencies'] = Map<String, dynamic>.from(modifiedYaml['dev_dependencies'] as Map);
      modifiedYaml['dev_dependencies']['auto_route_generator'] = '^9.0.0';
      modifiedYaml['dev_dependencies']['build_runner'] = '^2.4.9';
      modifiedYaml['dev_dependencies']['isar_generator'] = '^3.1.0+1';
      modifiedYaml['dev_dependencies']['json_serializable'] = '^6.0.0';

      // Add dependency_overrides
      modifiedYaml['dependency_overrides'] =
          Map<String, dynamic>.from((modifiedYaml['dependency_overrides'] ?? {}) as Map);
      modifiedYaml['dependency_overrides']['analyzer'] = '^6.2.0';

      // Assets
      modifiedYaml['flutter'] = Map<String, dynamic>.from(modifiedYaml['flutter'] as Map);
      List<String> assets = List<String>.from(modifiedYaml['flutter']['assets'] as List);

      assets.removeWhere((asset) => asset == 'assets/');
      assets.add('assets/');

      assets.removeWhere((asset) => asset == 'assets/images/');
      assets.add('assets/images/');

      modifiedYaml['flutter']['assets'] = assets;

      return modifiedYaml;
    },
  );
  await Commander.flutter('pub', ['get']);

  await Commander.info('Kappa has been installed.');
  await Commander.info('Note: Run "dart run build_runner watch" for develop!');
}


Future<void> _handleBuild() async {
  await Commander.info('Running build_runner build...');
  await Commander.flutter('pub', ['run', 'build_runner', 'build', '--delete-conflicting-outputs']);
}

Future<void> _handleWatch() async {
  await Commander.info('Running build_runner watch...');
  await Commander.flutter('pub', ['run', 'build_runner', 'watch', '--delete-conflicting-outputs']);
}

Future<void> _handleDoctor() async {
  await Commander.info('Checking Kappa environment...');
  
  bool hasKappaYaml = File('kappa.yaml').existsSync();
  bool hasPubspec = File('pubspec.yaml').existsSync();
  bool hasEnv = File('.env').existsSync() || File('.env.develop').existsSync();

  await Commander.table([
    ['kappa.yaml', hasKappaYaml ? '✅ Found' : '❌ Missing'],
    ['pubspec.yaml', hasPubspec ? '✅ Found' : '❌ Missing'],
    ['Environment (.env)', hasEnv ? '✅ Found' : '⚠️ Missing (Recommended)'],
  ], header: ['Check', 'Status']);

  if (!hasKappaYaml) {
    await Commander.info('\nSuggestion: Run "dart run kappa:generate" to create kappa.yaml');
  }
}
