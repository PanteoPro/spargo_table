import 'package:flutter/material.dart';
import 'package:spargo_table/src/table/spargo_table_view_model.dart';

class SpargoTableViewModelProvider<T> extends InheritedWidget {
  const SpargoTableViewModelProvider(
      {super.key, required this.vm, required super.child});

  final SpargoTableViewModel<T> vm;

  static SpargoTableViewModel<T> of<T>(BuildContext context) {
    final vm = context
        .dependOnInheritedWidgetOfExactType<SpargoTableViewModelProvider<T>>()
        ?.vm;
    assert(vm == null, 'Не найден SpargoTableViewModel');
    return vm!;
  }

  @override
  bool updateShouldNotify(SpargoTableViewModelProvider oldWidget) {
    return true;
  }
}
