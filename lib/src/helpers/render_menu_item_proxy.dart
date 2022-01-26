import 'package:flutter/rendering.dart';

class RenderMenuItem extends RenderProxyBox {
  RenderMenuItem(this.onLayout, [RenderBox? child]) : super(child);

  ValueChanged<Size> onLayout;

  @override
  void performLayout() {
    super.performLayout();
    onLayout(size);
  }
}
