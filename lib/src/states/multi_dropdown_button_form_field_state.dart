import 'package:flutter/material.dart';
import 'package:multi_dropdown_button/src/multi_dropdown_button_form_field.dart';

class MultiDropdownButtonFormFieldState<T> extends FormFieldState<T> {
  @override
  MultiDropdownButtonFormField<T> get widget => super.widget as MultiDropdownButtonFormField<T>;

  @override
  void didChange(T? value) {
    super.didChange(value);
    assert(widget.onChanged != null);
    widget.onChanged!(value);
  }

  @override
  void didUpdateWidget(MultiDropdownButtonFormField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      setValue(widget.initialValue);
    }
  }
}