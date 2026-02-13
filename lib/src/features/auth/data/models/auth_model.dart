import 'package:json_annotation/json_annotation.dart';
import 'package:kappa/src/features/auth/domain/entities/auth_entity.dart';

part 'auth_model.g.dart';

@JsonSerializable()
class AuthModel extends AuthUserEntity { // Extends AuthUserEntity
  const AuthModel({
    required super.id,
    required super.email,
    super.token, // token is now part of AuthUserEntity
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) => _$AuthModelFromJson(json);
  @override // Override toJson as it will be used for API requests
  Map<String, dynamic> toJson() => _$AuthModelToJson(this);

  // No need for toEntity() as AuthModel extends AuthUserEntity
}
