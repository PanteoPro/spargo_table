import 'package:flutter/material.dart';

class SpargoTableCellConfig {
  const SpargoTableCellConfig({required this.builder});
  final Widget Function(bool isSelected) builder;
}
