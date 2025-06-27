import 'dart:math';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';

import '../../core/core_exporter.dart';
import '../presentation_exporter.dart';

enum BaseSmartRefreshLayoutType {
  none,
  list,
  grid,
}

class BaseSmartRefreshLayout extends StatelessWidget {
  final BaseSmartRefreshController controller;
  final Widget Function(BuildContext, Widget, IndicatorController)? builder;
  final BaseSmartRefreshLayoutType type;
  final Widget? child;
  final Widget? blankWidget;

  // For list type
  final int itemCount;
  final Widget? Function(BuildContext, int)? itemBuilder;
  final Widget Function(BuildContext, int)? separatorBuilder;

  // For grid type
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;

  const BaseSmartRefreshLayout({
    super.key,
    required this.controller,
    this.builder,
    this.type = BaseSmartRefreshLayoutType.none,
    this.child,
    this.blankWidget,
  })  : itemCount = 0,
        itemBuilder = null,
        separatorBuilder = null,
        crossAxisCount = 1,
        crossAxisSpacing = 0.0,
        mainAxisSpacing = 0.0;

  const BaseSmartRefreshLayout.list({
    super.key,
    required this.controller,
    this.builder,
    this.itemCount = 0,
    required this.itemBuilder,
    required this.separatorBuilder,
    this.blankWidget,
  })  : type = BaseSmartRefreshLayoutType.list,
        child = null,
        crossAxisCount = 1,
        crossAxisSpacing = 0.0,
        mainAxisSpacing = 0.0;

  const BaseSmartRefreshLayout.grid({
    super.key,
    required this.controller,
    this.builder,
    this.itemCount = 0,
    required this.itemBuilder,
    this.crossAxisCount = 2,
    this.crossAxisSpacing = 0.0,
    this.mainAxisSpacing = 0.0,
    this.blankWidget,
  })  : type = BaseSmartRefreshLayoutType.grid,
        child = null,
        separatorBuilder = null;

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      controller: controller.controller,
      onRefresh: controller.onRefresh,
      trigger: IndicatorTrigger.bothEdges,
      onStateChanged: controller.onStateChanged,
      builder: builder ??
          (context, child, controller) => Padding(
                padding: const EdgeInsets.all(6.0),
                child: CircularProgressIndicator(
                  color: Colors.redAccent,
                  value: controller.state.isLoading ? null : min(controller.value, 1.0),
                ),
              ),
      child: ConditionalVisibility(
        condition:
            (type == BaseSmartRefreshLayoutType.list || type == BaseSmartRefreshLayoutType.grid) && itemCount > 0,
        passed: switch (type) {
          BaseSmartRefreshLayoutType.list => ListView.separated(
              itemBuilder: itemBuilder as Widget Function(BuildContext, int),
              separatorBuilder: separatorBuilder as Widget Function(BuildContext, int),
              itemCount: itemCount,
            ),
          BaseSmartRefreshLayoutType.grid => GridView.builder(
              itemCount: itemCount,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: crossAxisSpacing,
                mainAxisSpacing: mainAxisSpacing,
              ),
              itemBuilder: itemBuilder as Widget Function(BuildContext, int),
            ),
          BaseSmartRefreshLayoutType.none => child ?? const SizedBox.shrink(),
        },
        failed: blankWidget ?? const SizedBox.shrink(),
      ),
    );
  }
}
