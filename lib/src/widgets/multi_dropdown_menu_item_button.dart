// The widget that is the button wrapping the menu items.
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_dropdown_button/src/helpers/menu_limits.dart';
import 'package:multi_dropdown_button/src/routes/multi_dropdown_route.dart';
import 'package:multi_dropdown_button/src/routes/multi_dropdown_route_result.dart';
import 'package:multi_dropdown_button/src/widgets/multi_dropdown_menu_item.dart';

class MultiDropdownMenuItemButton<T> extends StatefulWidget {
  const MultiDropdownMenuItemButton({
    Key? key,
    this.padding,
    required this.borderRadius,
    required this.route,
    required this.buttonRect,
    required this.constraints,
    required this.itemIndex,
    required this.enableFeedback,
  }) : super(key: key);

  final MultiDropdownRoute<T> route;
  final EdgeInsets? padding;
  final Rect buttonRect;
  final BoxConstraints constraints;
  final int itemIndex;
  final bool enableFeedback;
  final BorderRadius borderRadius;

  @override
  _MultiDropdownMenuItemButtonState<T> createState() => _MultiDropdownMenuItemButtonState<T>();
}

class _MultiDropdownMenuItemButtonState<T> extends State<MultiDropdownMenuItemButton<T>> {
  void _handleFocusChange(bool focused) {
    final bool inTraditionalMode;
    switch (FocusManager.instance.highlightMode) {
      case FocusHighlightMode.touch:
        inTraditionalMode = false;
        break;
      case FocusHighlightMode.traditional:
        inTraditionalMode = true;
        break;
    }

    if (focused && inTraditionalMode) {
      final MenuLimits menuLimits = widget.route.getMenuLimits(
        widget.buttonRect,
        widget.constraints.maxHeight,
        widget.itemIndex,
      );
      widget.route.scrollController!.animateTo(
        menuLimits.scrollOffset,
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 100),
      );
    }
  }

  void _handleOnTap() {
    final MultiDropdownMenuItem<T> dropdownMenuItem = widget.route.items[widget.itemIndex].item!;

    dropdownMenuItem.onTap?.call();

    Navigator.pop(
      context,
      MultiDropdownRouteResult<T>(dropdownMenuItem.values),
    );
  }

  static const Map<ShortcutActivator, Intent> _webShortcuts = <ShortcutActivator, Intent>{
    // On the web, up/down don't change focus, *except* in a <select>
    // element, which is what a dropdown emulates.
    SingleActivator(LogicalKeyboardKey.arrowDown): DirectionalFocusIntent(TraversalDirection.down),
    SingleActivator(LogicalKeyboardKey.arrowUp): DirectionalFocusIntent(TraversalDirection.up),
  };

  @override
  Widget build(BuildContext context) {
    final MultiDropdownMenuItem<T> dropdownMenuItem = widget.route.items[widget.itemIndex].item!;
    final CurvedAnimation opacity;
    final double unit = 0.5 / (widget.route.items.length + 1.5);
    if (widget.itemIndex == widget.route.selectedIds.first) {
      opacity = CurvedAnimation(parent: widget.route.animation!, curve: const Threshold(0.0));
    } else {
      final double start = (0.5 + (widget.itemIndex + 1) * unit).clamp(0.0, 1.0);
      final double end = (start + 1.5 * unit).clamp(0.0, 1.0);
      opacity = CurvedAnimation(parent: widget.route.animation!, curve: Interval(start, end));
    }
    Widget child = Container(
      padding: widget.padding,
      height: widget.route.itemHeight,
      child: widget.route.items[widget.itemIndex],
    );
    final BorderRadius itemBorderRadius;
    if (widget.route.items.length == 1) {
      itemBorderRadius = widget.borderRadius;
    } else if (widget.itemIndex == 0) {
      itemBorderRadius = BorderRadius.only(topLeft: widget.borderRadius.topLeft, topRight: widget.borderRadius.topRight);
    } else if (widget.itemIndex == widget.route.items.length - 1) {
      itemBorderRadius = BorderRadius.only(bottomLeft: widget.borderRadius.bottomLeft, bottomRight: widget.borderRadius.bottomRight);
    } else {
      itemBorderRadius = BorderRadius.zero;
    }
    // An [InkWell] is added to the item only if it is enabled
    if (dropdownMenuItem.enabled) {
      child = InkWell(
        autofocus: widget.itemIndex == widget.route.selectedIds.first,
        enableFeedback: widget.enableFeedback,
        onTap: _handleOnTap,
        onFocusChange: _handleFocusChange,
        borderRadius: itemBorderRadius,
        child: child,
      );
    }
    child = FadeTransition(opacity: opacity, child: child);
    if (kIsWeb && dropdownMenuItem.enabled) {
      child = Shortcuts(
        shortcuts: _webShortcuts,
        child: child,
      );
    }
    return child;
  }
}