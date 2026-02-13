import 'package:equatable/equatable.dart';

class AuthUserEntity extends Equatable {
  final String id;
  final String email;
  final String? token; // Token can be null if not logged in

  const AuthUserEntity({required this.id, required this.email, this.token});

  // Default unauthenticated user
  static const unauthenticated = AuthUserEntity(id: '', email: '', token: null);

  // Check if user is authenticated
  bool get isAuthenticated => token != null && token!.isNotEmpty;

  @override
  List<Object?> get props => [id, email, token];
}
