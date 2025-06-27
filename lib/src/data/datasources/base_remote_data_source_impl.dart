part of 'base_data_source.dart';

/// Base implementation class for remote data sources.
///
/// Extends [BaseDataSourceImpl] to provide remote API access functionality.
/// Contains a reference to [DioClient] and provides convenient access to:
/// - [dioClient]: The HTTP client instance for making API requests
///
/// This class serves as the foundation for all remote data source implementations
/// that need to interact with external APIs.
abstract class BaseRemoteDataSourceImpl extends BaseDataSourceImpl {
  final DioClient _dioClient;

  BaseRemoteDataSourceImpl(this._dioClient);

  DioClient get dioClient => _dioClient;
}
