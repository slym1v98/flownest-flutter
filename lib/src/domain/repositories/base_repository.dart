/// Abstract base class for all repositories in the domain layer.
///
/// Provides the foundation for repository interfaces with immutability
/// through const constructor. All concrete repository interfaces should
/// extend this class to maintain consistent repository patterns across
/// the application.
abstract class BaseRepository {
  const BaseRepository();
}
