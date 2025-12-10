import 'package:flutter/material.dart';

class SpargoTableCellConfig {
  const SpargoTableCellConfig({
    required this.builder,
    this.alignment,
  });
  final Widget Function(bool isSelected) builder;
  final MainAxisAlignment? alignment;
}
