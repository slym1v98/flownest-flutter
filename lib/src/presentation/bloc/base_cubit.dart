import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../kappa.dart';

/// Abstract base class for all Cubits in the application.
///
/// Extends [Cubit] from flutter_bloc and implements [InjectableService] for dependency injection.
/// Type parameter:
/// - [State]: The type of state this cubit manages that implements [BaseState]
///
/// Serves as the foundation for all cubit implementations, providing simplified
/// state management with dependency injection capabilities.
abstract class BaseCubit<State extends BaseState> extends Cubit<State> implements InjectableService {
  BaseCubit(super.initialState);
}
