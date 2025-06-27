part of 'base_usecase.dart';

/// Abstract base class for use case parameters with JSON serialization support.
///
/// Extends [Equatable] to provide value equality comparison.
/// Features:
/// - JSON conversion via [toJson] and [fromJson]
/// - Value comparison through props override
///
/// Includes [NoParams] implementation for use cases that don't require parameters.
abstract class UseCaseParams extends Equatable {
  const UseCaseParams();

  @override
  List<Object> get props => [];

  Map<String, dynamic> toJson();

  UseCaseParams fromJson(Map<String, dynamic> json);
}

class NoParams extends UseCaseParams {
  @override
  UseCaseParams fromJson(Map<String, dynamic> json) {
    return NoParams();
  }

  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}
