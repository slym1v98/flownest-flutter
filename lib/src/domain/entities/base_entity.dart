import 'dart:convert';

import 'package:equatable/equatable.dart';

/// Abstract base class for all entities in the domain layer.
///
/// Extends [Equatable] to provide value equality comparison.
/// Features:
/// - JSON map conversion via [toMap] and [fromMap]
/// - String serialization via [toString] and [fromString]
/// - Factory method [empty] for creating empty entity instances
/// - Value comparison through props override
///
/// This class serves as the foundation for all entity classes in the application,
/// ensuring consistent behavior and serialization capabilities.
abstract class BaseEntity extends Equatable {
  const BaseEntity();

  @override
  List<Object?> get props => [];

  factory BaseEntity.empty() {
    throw UnimplementedError();
  }

  Map<String, dynamic> toMap();

  factory BaseEntity.fromMap(Map<String, dynamic> map) {
    throw UnimplementedError();
  }

  @override
  String toString() {
    return jsonEncode(toMap());
  }

  factory BaseEntity.fromString(String jsonString) {
    return BaseEntity.fromMap(jsonDecode(jsonString));
  }
}
