part of 'extensions.dart';

extension WidgetExtension on Widget {
  ClipRRect radius(BorderRadius value) {
    return ClipRRect(
      borderRadius: value,
      clipBehavior: Clip.hardEdge,
      child: this,
    );
  }

  Padding padding(EdgeInsets value) {
    return Padding(
      padding: value,
      child: this,
    );
  }

  Expanded expanded({int flex = 1}) {
    return Expanded(
      flex: flex,
      child: this,
    );
  }

  Flexible flexible({int flex = 1}) {
    return Flexible(
      flex: flex,
      child: this,
    );
  }

  SizedBox size({
    double? height,
    double? width,
  }) {
    return SizedBox(
      height: height,
      width: width,
      child: this,
    );
  }

  Widget container({
    double? height,
    double? width,
    EdgeInsets? padding,
    EdgeInsets? margin,
    Color? bgColor,
    double radius = 8,
    Border? border,
    List<BoxShadow>? boxShadow,
  }) {
    return Container(
      height: height,
      width: width,
      padding: padding ?? const EdgeInsets.all(16),
      margin: margin,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(radius),
        border: border,
        boxShadow: boxShadow,
      ),
      child: this,
    );
  }

  Widget visible(bool visible) {
    return Visibility(
      visible: visible,
      child: this,
    );
  }

  Widget ifFalse({required bool condition, Widget? falseWidget}) {
    return condition ? this : falseWidget ?? const SizedBox.shrink();
  }

  Widget ifTrue({required bool condition, Widget? trueWidget}) {
    return condition ? trueWidget ?? this : const SizedBox.shrink();
  }
}
