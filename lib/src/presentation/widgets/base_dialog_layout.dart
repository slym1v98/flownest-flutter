import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BaseDialogLayout extends StatelessWidget {
  final Widget child;
  final double padding;

  const BaseDialogLayout({
    super.key,
    required this.child,
    this.padding = 16,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.spMin),
        ),
        child: Padding(
          padding: EdgeInsets.all(padding).copyWith(
            bottom: MediaQuery.of(context).viewInsets.bottom + padding,
          ),
          child: child,
        ),
      ),
    );
  }
}
