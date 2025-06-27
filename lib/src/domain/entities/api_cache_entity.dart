import 'package:kappa/kappa.dart';

/// Entity class representing cached API responses.
///
/// Extends [BaseEntity] to provide core entity functionality and value equality.
/// Stores API cache information including:
/// - [id]: Unique identifier for the cache entry
/// - [key]: Cache key for the stored response
/// - [response]: The actual cached API response
/// - [createdAt]: Creation timestamp
/// - [updatedAt]: Last update timestamp
/// - [expiredAt]: Expiration timestamp
///
/// Provides [empty] factory method for creating empty instances and
/// implements [toMap]/[fromMap] for data conversion.
class ApiCacheEntity extends BaseEntity {
  final String? id;
  final String? key;
  final String? response;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? expiredAt;

  const ApiCacheEntity({
    this.id,
    this.key,
    this.response,
    this.createdAt,
    this.updatedAt,
    this.expiredAt,
  });

  factory ApiCacheEntity.empty() => const ApiCacheEntity(
        id: '-',
        key: '-',
        response: '-',
        createdAt: null,
        updatedAt: null,
        expiredAt: null,
      );

  @override
  List<Object?> get props {
    return [id, key, response, createdAt, updatedAt, expiredAt];
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'key': key,
      'response': response,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'expiredAt': expiredAt,
    };
  }

  factory ApiCacheEntity.fromMap(Map<String, dynamic> map) {
    return ApiCacheEntity(
      id: map['id'],
      key: map['key'],
      response: map['response'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      expiredAt: map['expiredAt'],
    );
  }

  @override
  String toString() {
    return 'ApiCacheEntity(id: $id, key: $key, response: $response, createdAt: $createdAt, updatedAt: $updatedAt, expiredAt: $expiredAt)';
  }
}
