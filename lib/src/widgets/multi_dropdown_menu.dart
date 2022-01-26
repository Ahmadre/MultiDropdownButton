import 'package:flutter/material.dart';
import 'package:multi_dropdown_button/src/painter/multi_dropdown_menu_painter.dart';
import 'package:multi_dropdown_button/src/routes/multi_dropdown_route.dart';
import 'package:multi_dropdown_button/src/widgets/multi_dropdown_menu_item_button.dart';

class MultiDropdownMenu<T> extends StatefulWidget {
  const MultiDropdownMenu({
    Key? key,
    this.padding,
    required this.route,
    required this.buttonRect,
    required this.constraints,
    this.dropdownColor,
    required this.enableFeedback,
    this.borderRadius,
  }) : super(key: key);

  final MultiDropdownRoute<T> route;
  final EdgeInsets? padding;
  final Rect buttonRect;
  final BoxConstraints constraints;
  final Color? dropdownColor;
  final bool enableFeedback;
  final BorderRadius? borderRadius;

  @override
  _MultiDropdownMenuState<T> createState() => _MultiDropdownMenuState<T>();
}

class _MultiDropdownMenuState<T> extends State<MultiDropdownMenu<T>> {
  late CurvedAnimation _fadeOpacity;
  late CurvedAnimation _resize;

  @override
  void initState() {
    super.initState();
    // We need to hold these animations as state because of their curve
    // direction. When the route's animation reverses, if we were to recreate
    // the CurvedAnimation objects in build, we'd lose
    // CurvedAnimation._curveDirection.
    _fadeOpacity = CurvedAnimation(
      parent: widget.route.animation!,
      curve: const Interval(0.0, 0.25),
      reverseCurve: const Interval(0.75, 1.0),
    );
    _resize = CurvedAnimation(
      parent: widget.route.animation!,
      curve: const Interval(0.25, 0.5),
      reverseCurve: const Threshold(0.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    // The menu is shown in three stages (unit timing in brackets):
    // [0s - 0.25s] - Fade in a rect-sized menu container with the selected item.
    // [0.25s - 0.5s] - Grow the otherwise empty menu container from the center
    //   until it's big enough for as many items as we're going to show.
    // [0.5s - 1.0s] Fade in the remaining visible items from top to bottom.
    //
    // When the menu is dismissed we just fade the entire thing out
    // in the first 0.25s.
    assert(debugCheckHasMaterialLocalizations(context));
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final MultiDropdownRoute<T> route = widget.route;
    final List<Widget> children = <Widget>[
      for (int itemIndex = 0; itemIndex < route.items.length; ++itemIndex)
        MultiDropdownMenuItemButton<T>(
          route: widget.route,
          padding: widget.padding,
          buttonRect: widget.buttonRect,
          constraints: widget.constraints,
          itemIndex: itemIndex,
          enableFeedback: widget.enableFeedback,
          borderRadius: widget.borderRadius ?? BorderRadius.zero,
        ),
      ];

    return FadeTransition(
      opacity: _fadeOpacity,
      child: CustomPaint(
        painter: MultiDropdownMenuPainter(
          color: widget.dropdownColor ?? Theme.of(context).canvasColor,
          elevation: route.elevation,
          selectedIndex: route.selectedIds.first,
          resize: _resize,
          borderRadius: widget.borderRadius,
          // This offset is passed as a callback, not a value, because it must
          // be retrieved at paint time (after layout), not at build time.
          getSelectedItemOffset: () => route.getItemOffset(route.selectedIds.first),
        ),
        child: Semantics(
          scopesRoute: true,
          namesRoute: true,
          explicitChildNodes: true,
          label: localizations.popupMenuLabel,
          child: Material(
            type: MaterialType.transparency,
            textStyle: route.style,
            child: ScrollConfiguration(
              // Dropdown menus should never overscroll or display an overscroll indicator.
              // Scrollbars are built-in below.
              // Platform must use Theme and ScrollPhysics must be Clamping.
              behavior: ScrollConfiguration.of(context).copyWith(
                scrollbars: false,
                overscroll: false,
                physics: const ClampingScrollPhysics(),
                platform: Theme.of(context).platform,
              ),
              child: PrimaryScrollController(
                controller: widget.route.scrollController!,
                child: Scrollbar(
                  isAlwaysShown: true,
                  child: ListView(
                    padding: kMaterialListPadding,
                    shrinkWrap: true,
                    children: children,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}