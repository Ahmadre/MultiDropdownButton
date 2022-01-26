// This widget enables _DropdownRoute to look up the sizes of
// each menu item. These sizes are used to compute the offset of the selected
// item so that _DropdownRoutePage can align the vertical center of the
// selected item lines up with the vertical center of the dropdown button,
// as closely as possible.
import 'package:flutter/material.dart';
import 'package:multi_dropdown_button/src/helpers/render_menu_item_proxy.dart';
import 'package:multi_dropdown_button/src/widgets/multi_dropdown_menu_item.dart';

class MultiMenuItem<T> extends SingleChildRenderObjectWidget {
  const MultiMenuItem({
    Key? key,
    required this.onLayout,
    required this.item,
  }) : super(key: key, child: item);

  final ValueChanged<Size> onLayout;
  final MultiDropdownMenuItem<T>? item;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderMenuItem(onLayout);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderMenuItem renderObject) {
    renderObject.onLayout = onLayout;
  }
}
