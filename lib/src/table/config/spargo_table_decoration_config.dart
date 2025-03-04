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
    this.focusBorderTextFieldColor,
    this.textStyleTextField,
    this.cursorColor,
    this.scrollbarBottomHeight = 8,
    this.bottomPaddingForScrollbar = 12,
    this.showBottomBorderBetweenRows = true,
    this.tableBorderRadius,
    this.headerBorderRadius,
    this.rowIsMarkedColor,
  });
  final bool colorRowsBetweenRows;

  /// Цвет нечет строки
  final Color? colorOddItems;

  /// Цвет чет строки
  final Color? colorEvenItems;

  /// Цвет, в который будет окрашена строка таблицы,если для нее будет определено и выполнено (true) условие isMarked внутри _ContentWidget
  final Color? rowIsMarkedColor;

  /// Цвет шапки таблицы
  final Color? headerBackground;

  final Border? headerBorder;

  final Border? borderTable;

  /// Цвет иконки сортировка и фильтрации
  final Color? iconHeaderColor;

  /// Активный цвет иконки сортировка и фильтрации
  final Color? activeIconHeaderColor;

  /// Цвет обводки в фокусе TextField
  final Color? focusBorderTextFieldColor;

  /// Цвет в TextField курсора
  final Color? cursorColor;

  /// TextStyle TextField в head колонки
  final TextStyle? textStyleTextField;

  /// Ширина нижнего scrollbar
  final double scrollbarBottomHeight;

  /// Отступ для нижнего scrollbar
  final double bottomPaddingForScrollbar;

  /// Нужна ли граница между строками таблицы
  final bool showBottomBorderBetweenRows;

  /// Значение радиуса угла таблицы
  final BorderRadius? tableBorderRadius;

  /// Значение радиуса угла шапки таблицы
  final BorderRadius? headerBorderRadius;
}
