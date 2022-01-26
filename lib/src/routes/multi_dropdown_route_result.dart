// We box the return value so that the return value can be null. Otherwise,
// canceling the route (which returns null) would get confused with actually
// returning a real null value.
import 'package:flutter/material.dart';

@immutable
class MultiDropdownRouteResult<T> {
  const MultiDropdownRouteResult(this.result);

  final List<T?>? result;

  @override
  bool operator ==(Object other) {
    return other is MultiDropdownRouteResult<T>
        && other.result == result;
  }

  @override
  int get hashCode => result.hashCode;
}