import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../kappa.dart';

part 'base_usecase_params.dart';

/// Base classes for implementing use cases in the domain layer.
///
/// Provides two main abstract classes:
/// - [BaseUseCase]: For use cases that can return either an error or success result
/// - [BaseUseCaseWithoutException]: For use cases that only return success results
///
/// Features helper classes for handling single or list results:
/// - [SingleOrList]: Abstract class for unified single/list value handling
/// - [Single]: Concrete implementation for single value results
/// - [ListOf]: Concrete implementation for list value results
///
/// Type parameters:
/// - [Exception]: The type of error that can occur
/// - [Entity]: The entity type being operated on
/// - [Params]: Parameters required for the use case execution
abstract class SingleOrList<T> {
  when<R>({required R Function(T value) single, required R Function(List<T> values) list});
}

class Single<T> extends SingleOrList<T> {
  final T value;

  Single(this.value);

  @override
  R when<R>({required R Function(T value) single, required R Function(List<T> values) list}) {
    return single(value);
  }
}

class ListOf<T> extends SingleOrList<T> {
  final List<T> values;

  ListOf(this.values);

  @override
  R when<R>({required R Function(T value) single, required R Function(List<T> values) list}) {
    return list(values);
  }
}

abstract class BaseUseCase<Exception extends BaseException, Entity extends BaseEntity, Params extends UseCaseParams> {
  Future<Either<Exception, SingleOrList<Entity>>> execute(Params params);
}

abstract class BaseUseCaseWithoutException<Entity extends BaseEntity, Params extends UseCaseParams> {
  Future<SingleOrList<Entity>> execute(Params params);
}
