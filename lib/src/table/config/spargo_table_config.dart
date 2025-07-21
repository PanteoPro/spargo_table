import 'package:flutter/material.dart';
import 'package:spargo_table/src/table/config/spargo_table_cell_config.dart';
import 'package:spargo_table/src/table/config/spargo_table_header_config.dart';

class SpargoTableConfig<T> {
  const SpargoTableConfig({
    required this.columns,
    required this.buildRow,
    this.emptyFilterBuilder,
  });
  final List<SpargoTableColumnConfig<T>> columns;
  final List<SpargoTableCellConfig> Function(T model) buildRow;

  /// Билдит этот виджет, если после применения фильтров нет результатов
  final Widget Function(BuildContext context)? emptyFilterBuilder;
}
