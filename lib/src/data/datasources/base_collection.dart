import '../../domain/entities/base_entity.dart';
import 'entity_convertable.dart';

/// Abstract base class for database collections that provides entity conversion capabilities.
///
/// Type parameters:
/// - [C]: The concrete collection type that extends [BaseCollection]
/// - [E]: The entity type that extends [BaseEntity]
///
/// Implements [EntityConvertible] to enable conversion between collection and entity models.
abstract class BaseCollection<C, E extends BaseEntity> with EntityConvertible<C, E> {}
