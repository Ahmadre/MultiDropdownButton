import 'package:flutter/material.dart';
import 'package:multi_dropdown_button/src/helpers/constants.dart';
import 'package:multi_dropdown_button/src/helpers/menu_limits.dart';
import 'package:multi_dropdown_button/src/routes/multi_dropdown_route.dart';

class MultiDropdownMenuRouteLayout<T> extends SingleChildLayoutDelegate {
  MultiDropdownMenuRouteLayout({
    required this.buttonRect,
    required this.route,
    required this.textDirection,
  });

  final Rect buttonRect;
  final MultiDropdownRoute<T> route;
  final TextDirection? textDirection;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // The maximum height of a simple menu should be one or more rows less than
    // the view height. This ensures a tappable area outside of the simple menu
    // with which to dismiss the menu.
    //   -- https://material.io/design/components/menus.html#usage
    double maxHeight = max(0.0, constraints.maxHeight - 2 * kMenuItemHeight);
    if (route.menuMaxHeight != null && route.menuMaxHeight! <= maxHeight) {
      maxHeight = route.menuMaxHeight!;
    }
    // The width of a menu should be at most the view width. This ensures that
    // the menu does not extend past the left and right edges of the screen.
    final double width = min(constraints.maxWidth, buttonRect.width);
    return BoxConstraints(
      minWidth: width,
      maxWidth: width,
      maxHeight: maxHeight,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final MenuLimits menuLimits =
        route.getMenuLimits(buttonRect, size.height, route.selectedIds.first);

    assert(() {
      final Rect container = Offset.zero & size;
      if (container.intersect(buttonRect) == buttonRect) {
        // If the button was entirely on-screen, then verify
        // that the menu is also on-screen.
        // If the button was a bit off-screen, then, oh well.
        assert(menuLimits.top >= 0.0);
        assert(menuLimits.top + menuLimits.height <= size.height);
      }
      return true;
    }());
    assert(textDirection != null);
    final double left;
    switch (textDirection!) {
      case TextDirection.rtl:
        left = buttonRect.right.clamp(0.0, size.width) - childSize.width;
        break;
      case TextDirection.ltr:
        left = buttonRect.left.clamp(0.0, size.width - childSize.width);
        break;
    }

    return Offset(left, menuLimits.top);
  }

  @override
  bool shouldRelayout(MultiDropdownMenuRouteLayout<T> oldDelegate) {
    return buttonRect != oldDelegate.buttonRect ||
        textDirection != oldDelegate.textDirection;
  }
}
