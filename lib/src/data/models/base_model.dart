import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../kappa.dart';

/// Abstract base class for data models with JSON serialization and entity conversion capabilities.
///
/// Type parameters:
/// - [M]: The concrete model type that extends [BaseModel]
/// - [E]: The entity type that extends [BaseEntity]
///
/// Features:
/// - JSON serialization/deserialization via [toJson] and [fromJson]
/// - String conversion via [toString] and [fromString]
/// - Entity conversion through [EntityConvertible] mixin
/// - Value equality comparison through [Equatable]
/// - Factory method [empty] for creating empty model instances
abstract class BaseModel<M, E extends BaseEntity> extends Equatable with EntityConvertible<M, E> {
  const BaseModel();

  @override
  List<Object?> get props => [];

  factory BaseModel.empty() {
    throw UnimplementedError();
  }

  Map<String, dynamic> toJson();

  factory BaseModel.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  factory BaseModel.fromString(String jsonString) {
    return BaseModel.fromJson(jsonDecode(jsonString));
  }
}
