import 'package:flutter/material.dart';

/// An inherited widget that causes any descendant [DropdownButton]
/// widgets to not include their regular underline.
///
/// This is used by [DataTable] to remove the underline from any
/// [DropdownButton] widgets placed within material data tables, as
/// required by the material design specification.
class MultiDropdownButtonHideUnderline extends InheritedWidget {
  /// Creates a [MultiDropdownButtonHideUnderline]. A non-null [child] must
  /// be given.
  const MultiDropdownButtonHideUnderline({
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  /// Returns whether the underline of [DropdownButton] widgets should
  /// be hidden.
  static bool at(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<
            MultiDropdownButtonHideUnderline>() !=
        null;
  }

  @override
  bool updateShouldNotify(MultiDropdownButtonHideUnderline oldWidget) => false;
}
