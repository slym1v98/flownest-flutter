import 'package:isar/isar.dart';

import '../../../kappa.dart';

part 'base_data_source_impl.dart';

part 'base_remote_data_source_impl.dart';

part 'base_local_data_source_impl.dart';

/// Base abstract class for all data sources in the application.
///
/// Extends [InjectableService] to enable dependency injection capabilities.
/// This class serves as the foundation for remote and local data sources,
/// with implementations provided in separate part files:
/// - base_data_source_impl.dart
/// - base_remote_data_source_impl.dart
/// - base_local_data_source_impl.dart
abstract class BaseDataSource extends InjectableService {}
