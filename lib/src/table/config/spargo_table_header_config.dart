import 'package:flutter/material.dart';
import 'package:spargo_table/src/table/models/spargo_sort_model.dart';

class SpargoTableColumnConfig<T> {
  const SpargoTableColumnConfig({
    required this.name,
    this.style,
    this.sortBy,
    this.width = 250,
    this.queryFilter,
    this.textAlign,
  });

  final String name;
  final TextStyle? style;
  final double width;
  final bool Function(String query, T model)? queryFilter;
  final int Function(T modelA, T modelB, SpargoSortType type)? sortBy;
  final TextAlign? textAlign;

  SpargoTableColumnConfig<T> copyWith({
    String? name,
    double? width,
  }) {
    return SpargoTableColumnConfig<T>(
      name: name ?? this.name,
      width: width ?? this.width,
      queryFilter: queryFilter,
      sortBy: sortBy,
    );
  }
}
