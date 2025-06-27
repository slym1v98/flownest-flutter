import 'package:equatable/equatable.dart';

/// Abstract base class for all BLoC and Cubit states in the application.
///
/// Extends [Equatable] to provide value equality comparison for states.
/// All states in the application should extend this class to ensure
/// consistent state handling and comparison behavior.
///
/// Implements empty props list by default which can be overridden
/// by concrete state classes to specify their comparison properties.
abstract class BaseState extends Equatable {
  const BaseState();

  @override
  List<Object?> get props => [];
}
