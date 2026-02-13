import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:kappa/kappa.dart';
import 'package:kappa/src/presentation/utils/kappa_ui.dart';
import 'package:kappa/src/presentation/widgets/common/kappa_button.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'dart:io';

class MockStorage extends Mock implements Storage {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late Storage storage;

  setUpAll(() async {
    storage = MockStorage();
    when(() => storage.write(any(), any())).thenAnswer((_) async {});
    when(() => storage.read(any())).thenReturn(null);
    HydratedBloc.storage = storage;
  });

  Widget createTestApp() {
    return KappaMaterialApp(
      designSize: const Size(390, 844),
      routerDelegate: TestRouterDelegate(),
      routeInformationParser: TestRouteParser(),
    );
  }

  group('Kappa Framework Integration Tests', () {
    testWidgets('Full workflow: Load App, Show Loader, Change Theme', (WidgetTester tester) async {
      // 1. Initialize core services (mocked)
      await SL.initBaseServices(appConfig: AppConfig.defaultConfig);
      
      // 2. Pump the app
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      // 3. Verify Home Screen is visible
      expect(find.text('Kappa Test Home'), findsOneWidget);

      // 4. Test Global Loader
      SL.call<LoaderCubit>().setLoading(true);
      await tester.pump(); // Start animation
      await tester.pump(const Duration(milliseconds: 500));
      
      // Verify loader overlay is visible (CircularProgressIndicator)
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      SL.call<LoaderCubit>().setLoading(false);
      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);

      // 5. Test Theme Switching
      final initialBrightness = Theme.of(tester.element(find.text('Kappa Test Home'))).brightness;
      
      SL.call<ThemeCubit>().toggleTheme();
      await tester.pumpAndSettle();
      
      final newBrightness = Theme.of(tester.element(find.text('Kappa Test Home'))).brightness;
      expect(initialBrightness != newBrightness, true);

      // 6. Test KappaUI (Global Snackbar)
      KappaUI.showSuccess('Integration Test Success');
      await tester.pumpAndSettle();
      expect(find.text('Integration Test Success'), findsOneWidget);
    });
  });
}

// Simple Router for testing
class TestRouterDelegate extends RouterDelegate<Object> with ChangeNotifier {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Kappa Test Home'),
            KappaButton(
              text: 'Click Me',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  @override
  Future<void> setNewRoutePath(Object configuration) async {}
  @override
  Object? get currentConfiguration => null;
}

class TestRouteParser extends RouteInformationParser<Object> {
  @override
  Future<Object> parseRouteInformation(RouteInformation routeInformation) async => Object();
}
