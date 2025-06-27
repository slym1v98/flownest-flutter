part of 'base_data_source.dart';

/// Base implementation class for local data sources.
///
/// Extends [BaseDataSourceImpl] to provide local database access functionality.
/// Contains a reference to [LocalDatabase] and provides convenient access to:
/// - [localDatabase]: The local database instance
/// - [db]: Direct access to the Isar database instance
///
/// This class serves as the foundation for all local data source implementations
/// that need to interact with the local database.
abstract class BaseLocalDataSourceImpl extends BaseDataSourceImpl {
  final LocalDatabase _localDatabase;

  BaseLocalDataSourceImpl(this._localDatabase);

  LocalDatabase get localDatabase => _localDatabase;

  Isar get db => _localDatabase.db;
}
