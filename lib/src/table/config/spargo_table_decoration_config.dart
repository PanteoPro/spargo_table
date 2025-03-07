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
    this.borderRow,
    this.tableBorderRadius,
    this.headerBorderRadius,
    this.rowIsMarkedColor,
    this.selectedRowColor,
  });

  /// При значении true цвет четных и нечетных строк в таблице будет различаться
  final bool colorRowsBetweenRows;

  /// Цвет нечет строки
  final Color? colorOddItems;

  /// Цвет чет строки
  final Color? colorEvenItems;

  /// Цвет текущей выьранной строки
  final Color? selectedRowColor;

  /// Цвет, в который будет окрашена строка таблицы,если для нее будет определено и выполнено (true) условие isMarked внутри _ContentWidget
  final Color? rowIsMarkedColor;

  /// Цвет шапки таблицы
  final Color? headerBackground;

  /// Рамка заголовка
  final Border? headerBorder;

  /// Рамка таблицы
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

  /// Рамка строки
  final Border? borderRow;

  /// Значение радиуса угла таблицы
  final BorderRadius? tableBorderRadius;

  /// Значение радиуса угла шапки таблицы
  final BorderRadius? headerBorderRadius;
}
