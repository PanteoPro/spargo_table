import 'dart:math';

import 'package:flutter/material.dart';
import 'package:spargo_table/src/table/config/spargo_table_decoration_config.dart';
import 'package:spargo_table/src/table/config/spargo_table_header_config.dart';
import 'package:spargo_table/src/table/models/spargo_sort_model.dart';
import 'package:spargo_table/src/table/spargo_table_view_model.dart';
import 'package:spargo_table/src/table/spargo_table_view_model_provider.dart';

class SpargoTableHeaderWidget<T> extends StatelessWidget {
  const SpargoTableHeaderWidget({
    super.key,
    required this.maxHeight,
    required this.columns,
    required this.columnWidths,
    required this.onStartResizeColumn,
    required this.onMoveResizeColumn,
    required this.onEndResizeColumn,
    required this.decorationConfig,
  });

  final double? maxHeight;

  final SpargoTableDecorationConfig decorationConfig;
  final List<SpargoTableColumnConfig<T>> columns;
  final List<double> columnWidths;
  final void Function(PointerDownEvent event, int index) onStartResizeColumn;
  final void Function(PointerMoveEvent event, int index) onMoveResizeColumn;
  final void Function(PointerUpEvent event, int index) onEndResizeColumn;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          color: decorationConfig.headerBackground,
          border: decorationConfig.headerBorder ??
              Border(
                  bottom: BorderSide(
                      color: Theme.of(context).colorScheme.outline))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              for (int index = 0; index < columns.length; index++) ...[
                _CellWidget<T>(
                  columns[index],
                  width: columnWidths[index],
                  index: index,
                  decorationConfig: decorationConfig,
                ),
                if (index < columns.length - 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Listener(
                      onPointerDown: (event) =>
                          onStartResizeColumn(event, index),
                      onPointerUp: (event) => onEndResizeColumn(event, index),
                      onPointerMove: (event) =>
                          onMoveResizeColumn(event, index),
                      child: Tooltip(
                        message: 'Изменить размер',
                        child: Material(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          color: Colors.transparent,
                          child: InkWell(
                            mouseCursor: SystemMouseCursors.click,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            onTap: () {},
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              child: Container(
                                width: 1,
                                height: maxHeight != null ? maxHeight! - 8 : 35,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _CellWidget<T> extends StatefulWidget {
  const _CellWidget(
    this.config, {
    super.key,
    required this.decorationConfig,
    required this.index,
    required this.width,
  });

  final SpargoTableColumnConfig<T> config;
  final SpargoTableDecorationConfig decorationConfig;
  final double width;
  final int index;

  @override
  State<_CellWidget<T>> createState() => _CellWidgetState<T>();
}

class _CellWidgetState<T> extends State<_CellWidget<T>> {
  final focusNode = FocusNode();
  final controller = TextEditingController();
  bool isEditMode = false;
  SpargoTableViewModel<T>? vm;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(_onChangeFocusNode);
  }

  @override
  void didChangeDependencies() {
    vm ??= SpargoTableViewModelProvider.of<T>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    focusNode.removeListener(_onChangeFocusNode);
    focusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  void _onChangeFocusNode() {
    if (isEditMode == false) return;
    if (focusNode.hasFocus) return;
    isEditMode = false;
    setState(() {});
  }

  void enterEditMode() {
    isEditMode = true;
    focusNode.requestFocus();
    setState(() {});
  }

  void toggleSort(SpargoSortType? currentType) {
    switch (currentType) {
      case null:
        vm?.setSortColumnIndex(widget.index, SpargoSortType.ascending);
      case SpargoSortType.ascending:
        vm?.setSortColumnIndex(widget.index, SpargoSortType.descending);
      case SpargoSortType.descending:
        vm?.setSortColumnIndex(widget.index, null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textWidget = Text(
      widget.config.name,
      style: widget.config.style ??
          Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.bold),
      maxLines: 3,
      textAlign: TextAlign.start,
    );
    Widget? interactiveWidget;
    if (widget.config.queryFilter != null) {
      interactiveWidget = InkWell(
        onTap: enterEditMode,
        child: Tooltip(
          message: 'Поиск по полю',
          child: textWidget,
        ),
      );
    }

    Widget? textField;
    if (isEditMode) {
      textField = TextField(
        cursorColor: widget.decorationConfig.cursorColor,
        controller: controller,
        focusNode: focusNode,
        onChanged: (query) => vm?.setQueryByColumn(query, widget.index),
        style: widget.decorationConfig.textStyleTextField,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: widget.decorationConfig.enableBorderTextFieldColor ??
                    Theme.of(context).colorScheme.outline),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: widget.decorationConfig.focusBorderTextFieldColor ??
                    Theme.of(context).colorScheme.outline),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        ),
      );
    }
    return Container(
      width: widget.width,
      padding: EdgeInsets.symmetric(vertical: isEditMode ? 0 : 6),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: isEditMode == false
                  ? interactiveWidget ?? textWidget
                  : textField!,
            ),
            if (widget.config.sortBy != null)
              ValueListenableBuilder(
                valueListenable: vm!.sortColumnNotifier,
                builder: (context, sortModel, child) {
                  final isSelect = sortModel?.columnIndex == widget.index;
                  return Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () =>
                            toggleSort(isSelect ? sortModel?.type : null),
                        child: Tooltip(
                            message: 'Применить сортировку',
                            child: Transform.rotate(
                              angle: isSelect
                                  ? sortModel?.type == SpargoSortType.descending
                                      ? pi
                                      : 0
                                  : 0,
                              child: Icon(
                                Icons.sort,
                                color: isSelect
                                    ? widget.decorationConfig
                                            .activeIconHeaderColor ??
                                        Theme.of(context).colorScheme.primary
                                    : widget.decorationConfig.iconHeaderColor,
                                size: 20,
                              ),
                            )),
                      ),
                    ),
                  );
                },
              ),
            if (widget.config.queryFilter != null)
              ValueListenableBuilder(
                valueListenable: vm!.queryFilters[widget.index]!,
                builder: (context, value, child) {
                  IconData icon = Icons.search;
                  String message = 'Применен фильтр - $value';
                  if (value == null || value.isEmpty) {
                    message = 'Можно применить фильтр';
                    icon = Icons.filter_alt;
                  }
                  return Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: enterEditMode,
                        child: Tooltip(
                            message: message,
                            child: Icon(
                              icon,
                              size: 20,
                              color: value?.isNotEmpty ?? false
                                  ? widget.decorationConfig
                                          .activeIconHeaderColor ??
                                      Theme.of(context).colorScheme.primary
                                  : widget.decorationConfig.iconHeaderColor,
                            )),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
