import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../kappa.dart';

/// Abstract base class for all BLoCs (Business Logic Components) in the application.
///
/// Extends [Bloc] from flutter_bloc and implements [InjectableService] for dependency injection.
/// Type parameters:
/// - [Event]: The type of events this bloc handles
/// - [State]: The type of states this bloc can emit
///
/// Serves as the foundation for all bloc implementations, ensuring consistent
/// state management and dependency injection capabilities.
abstract class BaseBloc<Event extends BaseEvent, State extends BaseState> extends Bloc<Event, State>
    implements InjectableService {
  BaseBloc(super.initialState);
}
