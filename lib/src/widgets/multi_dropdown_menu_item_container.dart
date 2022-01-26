// The container widget for a menu item created by a [DropdownButton]. It
// provides the default configuration for [DropdownMenuItem]s, as well as a
// [DropdownButton]'s hint and disabledHint widgets.
import 'package:flutter/material.dart';
import 'package:multi_dropdown_button/src/helpers/constants.dart';

class MultiDropdownMenuItemContainer extends StatefulWidget {
  /// Creates an item for a dropdown menu.
  ///
  /// The [child] argument is required.
  const MultiDropdownMenuItemContainer({
    Key? key,
    this.alignment = AlignmentDirectional.centerStart,
    required this.child,
  }) : super(key: key);

  /// The widget below this widget in the tree.
  ///
  /// Typically a [Text] widget.
  final Widget child;

  /// Defines how the item is positioned within the container.
  ///
  /// This property must not be null. It defaults to [AlignmentDirectional.centerStart].
  ///
  /// See also:
  ///
  ///  * [Alignment], a class with convenient constants typically used to
  ///    specify an [AlignmentGeometry].
  ///  * [AlignmentDirectional], like [Alignment] for specifying alignments
  ///    relative to text direction.
  final AlignmentGeometry alignment;

  @override
  State<MultiDropdownMenuItemContainer> createState() => _MultiDropdownMenuItemContainerState();
}

class _MultiDropdownMenuItemContainerState extends State<MultiDropdownMenuItemContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: kMenuItemHeight),
      alignment: widget.alignment,
      child: widget.child,
    );
  }
}
