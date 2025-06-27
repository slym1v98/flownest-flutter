import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kappa/kappa.dart';
import 'package:provider/single_child_widget.dart';
import 'package:upgrader/upgrader.dart';

class KappaMaterialApp extends StatefulWidget {
  final ThemeData? lightTheme;
  final ThemeData? darkTheme;
  final RouterDelegate<Object>? routerDelegate;
  final RouteInformationParser<Object>? routeInformationParser;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final Size? designSize;
  final List<SingleChildWidget> providers;
  final Future<void> Function(BuildContext context)? onConnectivityFailure;
  final Future<void> Function()? onAppForeground;
  final Future<void> Function()? onAppBackground;
  final Future<void> Function()? onAppDetached;
  final UpgraderMessages? upgraderMessages;

  const KappaMaterialApp({
    super.key,
    this.lightTheme,
    this.darkTheme,
    this.routerDelegate,
    this.routeInformationParser,
    this.localizationsDelegates,
    this.designSize = ScreenUtil.defaultSize,
    this.providers = const [],
    this.onConnectivityFailure,
    this.onAppForeground,
    this.onAppBackground,
    this.onAppDetached,
    this.upgraderMessages,
  }) : assert(
          routerDelegate != null && routeInformationParser != null,
          'routerDelegate and routeInformationParser must be provided',
        );

  @override
  State<KappaMaterialApp> createState() => _KappaMaterialAppState();
}

class _KappaMaterialAppState extends State<KappaMaterialApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        Logger.info("✅ App quay lại foreground!");
        widget.onAppForeground?.call();
        break;
      case AppLifecycleState.paused:
        Logger.info("⏸️ App vào background!");
        widget.onAppBackground?.call();
        break;
      case AppLifecycleState.detached:
        Logger.info("❌ App bị đóng!");
        widget.onAppDetached?.call();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider<ConnectivityBloc>(create: (context) => SL.call<ConnectivityBloc>()),
          BlocProvider<LoaderCubit>(create: (context) => SL.call<LoaderCubit>()),
          BlocProvider<ThemeCubit>(create: (context) => SL.call<ThemeCubit>()),
          BlocProvider<LocalizationCubit>(create: (context) => SL.call<LocalizationCubit>()),
          ...widget.providers,
        ],
        child: ScreenUtilInit(
          designSize: widget.designSize ?? ScreenUtil.defaultSize,
          child: BlocConsumer<ConnectivityBloc, ConnectivityState>(
            listener: (context, connectivityState) async {
              Logger.setLevel(Logger.lInfo);
              Logger.info('Connectivity state: $connectivityState');
              if (connectivityState is ConnectivityFailureState) {
                Logger.error('Connectivity failure: $connectivityState');
                if (widget.onConnectivityFailure != null) {
                  await widget.onConnectivityFailure!.call(context);
                }
              }
            },
            builder: (context, appLoaderState) => BlocBuilder<LoaderCubit, LoaderState>(
              builder: (context, loaderState) => BlocBuilder<ThemeCubit, ThemeState>(
                builder: (context, themeState) => BlocBuilder<LocalizationCubit, LocalizationState>(
                  builder: (context, localizationState) => MaterialApp.router(
                    debugShowCheckedModeBanner: false,
                    theme: widget.lightTheme ?? AppTheme.lightTheme,
                    darkTheme: widget.darkTheme ?? AppTheme.darkTheme,
                    themeMode: themeState.themeMode,
                    locale: localizationState.language,
                    supportedLocales: localizationState.supportedLanguages,
                    localizationsDelegates: widget.localizationsDelegates,
                    routerDelegate: widget.routerDelegate,
                    routeInformationParser: widget.routeInformationParser,
                    localeResolutionCallback: (deviceLocale, supportedLocales) {
                      Locale locale = localizationState.supportedLanguages.firstWhere(
                        (supportedLocale) => supportedLocale.languageCode == deviceLocale!.languageCode,
                        orElse: () => localizationState.language,
                      );
                      return locale;
                    },
                    builder: (context, child) => UpgradeAlert(
                      upgrader: Upgrader(
                        languageCode: localizationState.language.languageCode,
                        messages: widget.upgraderMessages,
                      ),
                      child: ConditionalBanner(
                        condition: AppFlavor.flavor != Flavor.product,
                        location: BannerLocation.topStart,
                        message: AppFlavor.nameTagged.toUpperCase(),
                        color: Color(AppFlavor.color),
                        child: child!,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
