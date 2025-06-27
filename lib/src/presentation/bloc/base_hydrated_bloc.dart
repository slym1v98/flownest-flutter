import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../../kappa.dart';

/// Abstract base class for BLoCs with state persistence capabilities.
///
/// Extends [HydratedBloc] to provide automatic state persistence and restoration,
/// while implementing [InjectableService] for dependency injection.
/// Type parameters:
/// - [Event]: The type of events this bloc handles
/// - [State]: The type of states this bloc can emit
///
/// Use this base class when implementing BLoCs that need to persist their state
/// across app restarts.
abstract class BaseHydratedBloc<Event extends BaseEvent, State extends BaseState>
    extends HydratedBloc<Event, State> implements InjectableService {
  BaseHydratedBloc(super.initialState);
}
