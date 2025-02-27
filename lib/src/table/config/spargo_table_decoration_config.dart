import 'package:flutter/material.dart';

class SpargoTableDecorationConfig {
  const SpargoTableDecorationConfig({
    this.colorRowsBetweenRows = false,
    this.colorOddItems,
    this.colorEvenItems,
    this.headerBackground,
    this.headerBorder,
    this.borderTable,
    this.iconHeaderColor,
    this.activeIconHeaderColor,
    this.enableBorderTextFieldColor,
    this.focusBorderTextFieldColor,
    this.textStyleTextField,
    this.cursorColor,
  });
  final bool colorRowsBetweenRows;

  /// Цвет нечет строки
  final Color? colorOddItems;

  /// Цвет чет строки
  final Color? colorEvenItems;

  /// Цвет шапки таблицы
  final Color? headerBackground;

  final Border? headerBorder;

  final Border? borderTable;

  /// Цвет иконки сортировка и фильтрации
  final Color? iconHeaderColor;

  /// Активный цвет иконки сортировка и фильтрации
  final Color? activeIconHeaderColor;

  final Color? enableBorderTextFieldColor;

  final Color? focusBorderTextFieldColor;

  final Color? cursorColor;

  final TextStyle? textStyleTextField;
}
