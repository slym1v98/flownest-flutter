import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kappa/kappa.dart';

enum SafeProperties {
  bottom,
  bottomLeft,
  bottomRight,
  top,
  topLeft,
  topRight,
  left,
  right,
  all,
  vertical,
  horizontal,
  none,
}

class BaseMainLayout extends StatelessWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final Widget body;
  final bool resizeToAvoidBottomInset;
  final SafeProperties safeProperties;
  final Color backgroundColor;
  final Widget? backgroundImage;
  final void Function()? onBackgroundPress;

  const BaseMainLayout({
    super.key,
    this.scaffoldKey,
    required this.body,
    this.resizeToAvoidBottomInset = true,
    this.safeProperties = SafeProperties.all,
    this.backgroundColor = Colors.white,
    this.backgroundImage,
    this.onBackgroundPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onBackgroundPress(context),
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        backgroundColor: backgroundColor,
        body: ConditionalVisibility(
          condition: safeProperties != SafeProperties.none,
          passed: SafeArea(
            bottom: safeProperties == SafeProperties.all ||
                safeProperties == SafeProperties.bottom ||
                safeProperties == SafeProperties.bottomLeft ||
                safeProperties == SafeProperties.bottomRight ||
                safeProperties == SafeProperties.vertical,
            top: safeProperties == SafeProperties.all ||
                safeProperties == SafeProperties.top ||
                safeProperties == SafeProperties.topLeft ||
                safeProperties == SafeProperties.topRight ||
                safeProperties == SafeProperties.vertical,
            left: safeProperties == SafeProperties.all ||
                safeProperties == SafeProperties.left ||
                safeProperties == SafeProperties.topLeft ||
                safeProperties == SafeProperties.bottomLeft ||
                safeProperties == SafeProperties.horizontal,
            right: safeProperties == SafeProperties.all ||
                safeProperties == SafeProperties.right ||
                safeProperties == SafeProperties.topRight ||
                safeProperties == SafeProperties.bottomRight ||
                safeProperties == SafeProperties.horizontal,
            child: _buildBody(context),
          ),
          failed: _buildBody(context),
        ),
        extendBody: false,
      ),
    );
  }

  void _onBackgroundPress(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    if (onBackgroundPress != null) {
      onBackgroundPress!.call();
    }
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<LoaderCubit, LoaderState>(
      builder: (context, loaderState) {
        return Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: ConditionalVisibility(
                  condition: backgroundImage == null,
                  passed: Container(
                    color: backgroundColor,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  failed: backgroundImage ?? const SizedBox.shrink(),
                ),
              ),
            ),
            body,
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: ConditionalVisibility(
                  condition: loaderState.loading,
                  passed: Container(
                    color: Colors.black.withValues(alpha: 0.5),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
