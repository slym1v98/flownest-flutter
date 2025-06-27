import 'package:equatable/equatable.dart';

/// Abstract base class for all BLoC events in the application.
///
/// Extends [Equatable] to provide value equality comparison for events.
/// All events in the application should extend this class to ensure
/// consistent event handling and comparison behavior.
///
/// Implements empty props list by default which can be overridden
/// by concrete event classes to specify their comparison properties.
abstract class BaseEvent extends Equatable {
  const BaseEvent();

  @override
  List<Object> get props => [];
}
