import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown_button/src/helpers/constants.dart';
import 'package:multi_dropdown_button/src/helpers/menu_limits.dart';
import 'package:multi_dropdown_button/src/routes/multi_dropdown_route_result.dart';
import 'package:multi_dropdown_button/src/widgets/multi_dropdown_route_page.dart';
import 'package:multi_dropdown_button/src/widgets/multi_menu_item.dart';

class MultiDropdownRoute<T> extends PopupRoute<MultiDropdownRouteResult<T>> {
  MultiDropdownRoute({
    required this.items,
    required this.padding,
    required this.buttonRect,
    required this.selectedIds,
    this.elevation = 8,
    required this.capturedThemes,
    required this.style,
    this.barrierLabel,
    this.itemHeight,
    this.dropdownColor,
    this.menuMaxHeight,
    required this.enableFeedback,
    this.borderRadius,
  }) : itemHeights = List<double>.filled(
            items.length, itemHeight ?? kMinInteractiveDimension);

  final List<MultiMenuItem<T>> items;
  final EdgeInsetsGeometry padding;
  final Rect buttonRect;
  final List<int> selectedIds;
  final int elevation;
  final CapturedThemes capturedThemes;
  final TextStyle style;
  final double? itemHeight;
  final Color? dropdownColor;
  final double? menuMaxHeight;
  final bool enableFeedback;
  final BorderRadius? borderRadius;

  final List<double> itemHeights;
  ScrollController? scrollController;

  @override
  Duration get transitionDuration => kDropdownMenuDuration;

  @override
  bool get barrierDismissible => true;

  @override
  Color? get barrierColor => null;

  @override
  final String? barrierLabel;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return MultiDropdownRoutePage<T>(
          route: this,
          constraints: constraints,
          items: items,
          padding: padding,
          buttonRect: buttonRect,
          selectedIds: selectedIds,
          elevation: elevation,
          capturedThemes: capturedThemes,
          style: style,
          dropdownColor: dropdownColor,
          enableFeedback: enableFeedback,
          borderRadius: borderRadius,
        );
      },
    );
  }

  void dismiss() {
    if (isActive) {
      navigator?.removeRoute(this);
    }
  }

  double getItemOffset(int index) {
    double offset = kMaterialListPadding.top;
    if (items.isNotEmpty && index > 0) {
      assert(items.length == itemHeights.length);
      offset += itemHeights
          .sublist(0, index)
          .reduce((double total, double height) => total + height);
    }
    return offset;
  }

  // Returns the vertical extent of the menu and the initial scrollOffset
  // for the ListView that contains the menu items. The vertical center of the
  // selected item is aligned with the button's vertical center, as far as
  // that's possible given availableHeight.
  MenuLimits getMenuLimits(
      Rect buttonRect, double availableHeight, int index) {
    double computedMaxHeight = availableHeight - 2.0 * kMenuItemHeight;
    if (menuMaxHeight != null) {
      computedMaxHeight = min(computedMaxHeight, menuMaxHeight!);
    }
    final double buttonTop = buttonRect.top;
    final double buttonBottom = min(buttonRect.bottom, availableHeight);
    final double selectedItemOffset = getItemOffset(index);

    // If the button is placed on the bottom or top of the screen, its top or
    // bottom may be less than [_kMenuItemHeight] from the edge of the screen.
    // In this case, we want to change the menu limits to align with the top
    // or bottom edge of the button.
    final double topLimit = min(kMenuItemHeight, buttonTop);
    final double bottomLimit =
        max(availableHeight - kMenuItemHeight, buttonBottom);

    double menuTop = (buttonTop - selectedItemOffset) -
        (itemHeights[selectedIds.first] - buttonRect.height) / 2.0;
    double preferredMenuHeight = kMaterialListPadding.vertical;
    if (items.isNotEmpty) {
      preferredMenuHeight +=
          itemHeights.reduce((double total, double height) => total + height);
    }

    // If there are too many elements in the menu, we need to shrink it down
    // so it is at most the computedMaxHeight.
    final double menuHeight = min(computedMaxHeight, preferredMenuHeight);
    double menuBottom = menuTop + menuHeight;

    // If the computed top or bottom of the menu are outside of the range
    // specified, we need to bring them into range. If the item height is larger
    // than the button height and the button is at the very bottom or top of the
    // screen, the menu will be aligned with the bottom or top of the button
    // respectively.
    if (menuTop < topLimit) {
      menuTop = min(buttonTop, topLimit);
      menuBottom = menuTop + menuHeight;
    }

    if (menuBottom > bottomLimit) {
      menuBottom = max(buttonBottom, bottomLimit);
      menuTop = menuBottom - menuHeight;
    }

    if (menuBottom - itemHeights[selectedIds.first] / 2.0 <
        buttonBottom - buttonRect.height / 2.0) {
      menuBottom = buttonBottom -
          buttonRect.height / 2.0 +
          itemHeights[selectedIds.first] / 2.0;
      menuTop = menuBottom - menuHeight;
    }

    double scrollOffset = 0;
    // If all of the menu items will not fit within availableHeight then
    // compute the scroll offset that will line the selected menu item up
    // with the select item. This is only done when the menu is first
    // shown - subsequently we leave the scroll offset where the user left
    // it. This scroll offset is only accurate for fixed height menu items
    // (the default).
    if (preferredMenuHeight > computedMaxHeight) {
      // The offset should be zero if the selected item is in view at the beginning
      // of the menu. Otherwise, the scroll offset should center the item if possible.
      scrollOffset = max(0.0, selectedItemOffset - (buttonTop - menuTop));
      // If the selected item's scroll offset is greater than the maximum scroll offset,
      // set it instead to the maximum allowed scroll offset.
      scrollOffset = min(scrollOffset, preferredMenuHeight - menuHeight);
    }

    assert((menuBottom - menuTop - menuHeight).abs() < precisionErrorTolerance);
    return MenuLimits(menuTop, menuBottom, menuHeight, scrollOffset);
  }
}
