import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../../kappa.dart';

/// Abstract base class for Cubits with state persistence capabilities.
///
/// Extends [HydratedCubit] to provide automatic state persistence and restoration,
/// while implementing [InjectableService] for dependency injection.
/// Type parameter:
/// - [State]: The type of state this cubit manages that implements [BaseState]
///
/// Use this base class when implementing Cubits that need to persist their state
/// across app restarts.
abstract class BaseHydratedCubit<State extends BaseState> extends HydratedCubit<State> implements InjectableService {
  BaseHydratedCubit(super.state);
}
