import 'package:flutter/material.dart';
import 'package:multi_dropdown_button/src/widgets/multi_dropdown_menu_item_container.dart';

/// An item in a menu created by a [DropdownButton].
///
/// The type `T` is the type of the value the entry represents. All the entries
/// in a given menu must represent values with consistent types.
class MultiDropdownMenuItem<T> extends MultiDropdownMenuItemContainer {
  /// Creates an item for a dropdown menu.
  ///
  /// The [child] argument is required.
  const MultiDropdownMenuItem({
    Key? key,
    this.onTap,
    this.value,
    this.enabled = true,
    this.selected = false,
    AlignmentGeometry alignment = AlignmentDirectional.centerStart,
    required Widget child,
  }) : super(key: key, alignment: alignment, child: child);

  /// Called when the dropdown menu item is tapped.
  final VoidCallback? onTap;

  /// The value to return if the user selects this menu item.
  ///
  /// Eventually returned in a call to [DropdownButton.onChanged].
  final T? value;

  /// Whether or not a user can select this menu item.
  ///
  /// Defaults to `true`.
  final bool enabled;

  /// Whether item is select by the user.
  ///
  /// Defaults to `false`.
  final bool selected;

  set selected(bool val) => selected = val;
}
