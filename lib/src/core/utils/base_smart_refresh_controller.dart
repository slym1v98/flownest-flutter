import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';

class BaseSmartRefreshController {
  late final IndicatorController _controller;
  late final Future<void> Function() _onRefresh;
  late final void Function(IndicatorStateChange)? _onStateChanged;

  BaseSmartRefreshController({
    IndicatorController? controller,
    Future<void> Function()? onRefresh,
    void Function(IndicatorStateChange)? onStateChanged,
  }) {
    _controller = controller ?? IndicatorController();
    _onRefresh = onRefresh ?? () async {};
    _onStateChanged = onStateChanged;
  }

  IndicatorController get controller => _controller;

  Future<void> Function() get onRefresh => _onRefresh;

  void Function(IndicatorStateChange)? get onStateChanged => _onStateChanged;
}
