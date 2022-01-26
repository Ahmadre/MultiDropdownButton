import 'package:flutter/material.dart';
import 'package:multi_dropdown_button/src/delegates/multi_dropdown_menu_route_layout.dart';
import 'package:multi_dropdown_button/src/helpers/menu_limits.dart';
import 'package:multi_dropdown_button/src/routes/multi_dropdown_route.dart';
import 'package:multi_dropdown_button/src/widgets/multi_dropdown_menu.dart';
import 'package:multi_dropdown_button/src/widgets/multi_menu_item.dart';

class MultiDropdownRoutePage<T> extends StatelessWidget {
  const MultiDropdownRoutePage({
    Key? key,
    required this.route,
    required this.constraints,
    this.items,
    required this.padding,
    required this.buttonRect,
    required this.selectedIds,
    this.elevation = 8,
    required this.capturedThemes,
    this.style,
    required this.dropdownColor,
    required this.enableFeedback,
    this.borderRadius,
  }) : super(key: key);

  final MultiDropdownRoute<T> route;
  final BoxConstraints constraints;
  final List<MultiMenuItem<T>>? items;
  final EdgeInsetsGeometry padding;
  final Rect buttonRect;
  final List<int> selectedIds;
  final int elevation;
  final CapturedThemes capturedThemes;
  final TextStyle? style;
  final Color? dropdownColor;
  final bool enableFeedback;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));

    // Computing the initialScrollOffset now, before the items have been laid
    // out. This only works if the item heights are effectively fixed, i.e. either
    // DropdownButton.itemHeight is specified or DropdownButton.itemHeight is null
    // and all of the items' intrinsic heights are less than kMinInteractiveDimension.
    // Otherwise the initialScrollOffset is just a rough approximation based on
    // treating the items as if their heights were all equal to kMinInteractiveDimension.
    if (route.scrollController == null) {
      final MenuLimits menuLimits = route.getMenuLimits(buttonRect, constraints.maxHeight, selectedIds.first);
      route.scrollController = ScrollController(initialScrollOffset: menuLimits.scrollOffset);
    }

    final TextDirection? textDirection = Directionality.maybeOf(context);
    final Widget menu = MultiDropdownMenu<T>(
      route: route,
      padding: padding.resolve(textDirection),
      buttonRect: buttonRect,
      constraints: constraints,
      dropdownColor: dropdownColor,
      enableFeedback: enableFeedback,
      borderRadius: borderRadius,
    );

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: Builder(
        builder: (BuildContext context) {
          return CustomSingleChildLayout(
            delegate: MultiDropdownMenuRouteLayout<T>(
              buttonRect: buttonRect,
              route: route,
              textDirection: textDirection,
            ),
            child: capturedThemes.wrap(menu),
          );
        },
      ),
    );
  }
}