import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:multi_dropdown_button/src/helpers/constants.dart';

class MultiDropdownMenuPainter extends CustomPainter {
  MultiDropdownMenuPainter({
    this.color,
    this.elevation,
    this.selectedIndex,
    this.borderRadius,
    required this.resize,
    required this.getSelectedItemOffset,
  }) : _painter = BoxDecoration(
         // If you add an image here, you must provide a real
         // configuration in the paint() function and you must provide some sort
         // of onChanged callback here.
         color: color,
         borderRadius: borderRadius ?? const BorderRadius.all(Radius.circular(2.0)),
         boxShadow: kElevationToShadow[elevation],
       ).createBoxPainter(),
       super(repaint: resize);

  final Color? color;
  final int? elevation;
  final int? selectedIndex;
  final BorderRadius? borderRadius;
  final Animation<double> resize;
  final ValueGetter<double> getSelectedItemOffset;
  final BoxPainter _painter;

  @override
  void paint(Canvas canvas, Size size) {
    final double selectedItemOffset = getSelectedItemOffset();
    final Tween<double> top = Tween<double>(
      begin: selectedItemOffset.clamp(0.0, math.max(size.height - kMenuItemHeight, 0.0)),
      end: 0.0,
    );

    final Tween<double> bottom = Tween<double>(
      begin: (top.begin! + kMenuItemHeight).clamp(math.min(kMenuItemHeight, size.height), size.height),
      end: size.height,
    );

    final Rect rect = Rect.fromLTRB(0.0, top.evaluate(resize), size.width, bottom.evaluate(resize));

    _painter.paint(canvas, rect.topLeft, ImageConfiguration(size: rect.size));
  }

  @override
  bool shouldRepaint(MultiDropdownMenuPainter oldDelegate) {
    return oldDelegate.color != color
        || oldDelegate.elevation != elevation
        || oldDelegate.selectedIndex != selectedIndex
        || oldDelegate.borderRadius != borderRadius
        || oldDelegate.resize != resize;
  }
}