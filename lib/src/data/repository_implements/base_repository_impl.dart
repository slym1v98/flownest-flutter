import '../../../kappa.dart';

/// Base implementation class for repositories.
///
/// Implements [BaseRepository] to provide the foundation for all concrete repository
/// implementations. This abstract class defines the basic structure that all
/// repository implementations should follow while maintaining immutability
/// through const constructor.
abstract class BaseRepositoryImpl implements BaseRepository {
  const BaseRepositoryImpl();
}
