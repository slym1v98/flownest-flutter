import 'package:flutter/material.dart';
import 'package:kappa/kappa.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kappa/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:kappa/src/features/auth/presentation/bloc/auth_event.dart';
import 'package:kappa/src/features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/login_page.dart';
import 'features/product/presentation/product_list_page.dart';
import 'features/product/presentation/product_cubit.dart';
import 'injection.dart';

void main() async {
  // Ensure framework is initialized
  await Kappa.ensureInitialized(
    designSize: const Size(390, 844),
    onInitServices: () async {
      // Register example specific services
      initExampleInjection();
    },
    routerDelegate: SimpleRouterDelegate(),
    routeInformationParser: SimpleRouteParser(),
    providers: [
      BlocProvider<AuthBloc>(create: (context) => SL.call<AuthBloc>()..add(const AppStarted())),
    ],
  );
}

// Minimalistic Router for the example
class SimpleRouterDelegate extends RouterDelegate<Object> with ChangeNotifier, PopNavigatorRouterDelegateMixin<Object> {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        return Navigator(
          key: navigatorKey,
          pages: [
            if (authState is! Authenticated)
              const MaterialPage(child: LoginPage())
            else
              MaterialPage(
                child: BlocProvider<ProductCubit>(
                  create: (context) => SL.call<ProductCubit>(),
                  child: const ProductListPage(),
                ),
              ),
          ],
          onPopPage: (route, result) => route.didPop(result),
        );
      },
    );
  }

  @override
  Future<void> setNewRoutePath(Object configuration) async {}
}

class SimpleRouteParser extends RouteInformationParser<Object> {
  @override
  Future<Object> parseRouteInformation(RouteInformation routeInformation) async => Object();
}
