import 'package:isar/isar.dart';
import 'package:kappa/kappa.dart';

part 'api_cache_collection.g.dart';

/// A collection class for managing API cache data using Isar database.
///
/// This collection stores API responses with their associated keys and expiration dates.
/// It extends [BaseCollection] and implements conversion methods between collection and entity models.
///
/// Properties:
/// - [id]: Unique identifier for the cache entry
/// - [key]: Cache key used to identify the stored response
/// - [response]: The cached API response data
/// - [createdAt]: Timestamp when the cache entry was created
/// - [updatedAt]: Timestamp when the cache entry was last updated
/// - [expiredAt]: Indexed timestamp indicating when the cache entry expires
@collection
class ApiCacheCollection extends BaseCollection<ApiCacheCollection, ApiCacheEntity> {
  final Id? id;
  late final String? key;
  late final String? response;
  late final DateTime? createdAt;
  final DateTime? updatedAt;
  @Index()
  late final DateTime? expiredAt;

  ApiCacheCollection({
    this.id,
    this.key,
    this.response,
    this.createdAt,
    this.updatedAt,
    this.expiredAt,
  });

  @override
  ApiCacheEntity toEntity() => ApiCacheEntity(
        id: id as String,
        key: key,
        response: response,
        createdAt: createdAt,
        updatedAt: updatedAt,
        expiredAt: expiredAt,
      );

  @override
  ApiCacheEntity fromEntity(ApiCacheEntity entity) => ApiCacheEntity(
        id: entity.id as String,
        key: entity.key,
        response: entity.response,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
        expiredAt: entity.expiredAt,
      );
}
