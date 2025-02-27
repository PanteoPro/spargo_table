import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spargo_table/src/table/config/spargo_table_config.dart';
import 'package:spargo_table/src/table/config/spargo_table_decoration_config.dart';
import 'package:spargo_table/src/table/spargo_table_view_model.dart';
import 'package:spargo_table/src/table/spargo_table_view_model_provider.dart';
import 'package:spargo_table/src/table/widgets/spargo_table_header_widget.dart';
import 'package:spargo_table/src/table/widgets/spargo_table_row_widget.dart';

typedef SubRowWidget<T> = Widget Function(T model);

class SpargoTable<T> extends StatefulWidget {
  const SpargoTable({
    super.key,
    required this.data,
    required this.configuration,
    this.maxHeight,
    this.selectedRow,
    this.onRowTap,
    this.thumbVisibility = true,
    this.selectedRowSubWidgetBuilder,
    this.decorationConfiguration = const SpargoTableDecorationConfig(),
    this.child,
  });

  final List<T> data;
  final T? selectedRow;
  final SpargoTableConfig<T> configuration;
  final SpargoTableDecorationConfig decorationConfiguration;

  final void Function(T model)? onRowTap;
  final SubRowWidget<T>? selectedRowSubWidgetBuilder;
  final bool thumbVisibility;
  final double? maxHeight;
  final Widget? child;

  @override
  State<SpargoTable<T>> createState() => _SpargoTableState<T>();
}

class _SpargoTableState<T> extends State<SpargoTable<T>> {
  late final vm = SpargoTableViewModel<T>(
    widgetState: this,
    data: widget.data,
    selectedRow: widget.selectedRow,
    configuration: widget.configuration,
  );

  @override
  void initState() {
    super.initState();
    vm.init();
  }

  @override
  void dispose() {
    vm.destroy();
    super.dispose();
  }

  final verticalScrollController = ScrollController();
  final horizontalScrollController = ScrollController();

  final GlobalKey _key = GlobalKey();
  final GlobalKey _keyHeader = GlobalKey();

  double? maxHeight;
  double? maxWidth;
  double? heightHeader;

  void _setSizes() {
    final renderBox = _key.currentContext?.findRenderObject() as RenderBox?;
    final renderBoxHeader =
        _keyHeader.currentContext?.findRenderObject() as RenderBox?;
    heightHeader = renderBoxHeader?.size.height;
    if (heightHeader == null) return;
    setState(() {
      maxHeight = renderBox!.size.height - heightHeader!;
      maxWidth = renderBox.size.width;
    });
  }

  double get tableWidth =>
      vm.columnWidthsNotifier.value.reduce((a, b) => a + b) +
      17 * (widget.configuration.columns.length - 1);

  BoxConstraints? _savedConstraints;
  List<double>? _savedColumnWidths;

  @override
  void didUpdateWidget(SpargoTable<T> oldWidget) {
    vm.didUpdateWidget(widget, oldWidget);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SpargoTableViewModelProvider(
      vm: vm,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (_savedConstraints != constraints) {
            _savedConstraints = constraints;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _setSizes();
            });
          }
          return SelectionArea(
            child: ValueListenableBuilder(
                valueListenable: vm.heightRowNotifier,
                builder: (context, heightRow, _) {
                  return Container(
                    decoration: BoxDecoration(
                      border: widget.decorationConfiguration.borderTable,
                    ),
                    child: Scrollbar(
                      controller: horizontalScrollController,
                      thumbVisibility: widget.thumbVisibility,
                      thickness:
                          widget.decorationConfiguration.scrollbarBottomHeight,
                      child: SingleChildScrollView(
                        key: _key,
                        controller: horizontalScrollController,
                        scrollDirection: Axis.horizontal,
                        child: ValueListenableBuilder(
                            valueListenable: vm.columnWidthsNotifier,
                            builder: (context, columnWidths, _) {
                              if (!listEquals(
                                  _savedColumnWidths, columnWidths)) {
                                _savedColumnWidths = columnWidths;
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  _setSizes();
                                });
                              }
                              final addedHeightBySubWidget =
                                  widget.selectedRow != null &&
                                          widget.selectedRowSubWidgetBuilder !=
                                              null
                                      ? 70
                                      : 0;
                              double heightContentTable = (heightRow != null
                                      ? min(maxHeight ?? 9999999,
                                          heightRow * widget.data.length)
                                      : (maxHeight ??
                                          widget.maxHeight ??
                                          300)) +
                                  addedHeightBySubWidget;
                              if (heightContentTable <
                                  (maxHeight ?? widget.maxHeight ?? 300)) {
                                final addedHeight = min(
                                    (maxHeight ?? widget.maxHeight ?? 300) -
                                        heightContentTable,
                                    widget.decorationConfiguration
                                        .bottomPaddingForScrollbar);
                                heightContentTable += addedHeight;
                              }
                              return Column(
                                children: [
                                  SpargoTableHeaderWidget(
                                    decorationConfig:
                                        widget.decorationConfiguration,
                                    maxHeight: heightHeader,
                                    key: _keyHeader,
                                    columns: widget.configuration.columns,
                                    columnWidths: columnWidths,
                                    onStartResizeColumn: vm.onStartResizeColumn,
                                    onMoveResizeColumn: vm.onMoveResizeColumn,
                                    onEndResizeColumn: vm.onEndResizeColumn,
                                  ),
                                  SizedBox(
                                    height: heightContentTable,
                                    width: tableWidth,
                                    child: ValueListenableBuilder(
                                        valueListenable:
                                            vm.filteredDataNotifier,
                                        builder: (context, filteredData, _) {
                                          return ValueListenableBuilder(
                                              valueListenable:
                                                  vm.sortedDataNotifier,
                                              builder:
                                                  (context, sortedData, _) {
                                                final dataForRender =
                                                    sortedData ??
                                                        filteredData ??
                                                        widget.data;
                                                return _RowWidget<T>(
                                                  dataForRender: dataForRender,
                                                  verticalScrollController:
                                                      verticalScrollController,
                                                  columnWidths: columnWidths,
                                                  decorationConfiguration: widget
                                                      .decorationConfiguration,
                                                  thumbVisibility:
                                                      widget.thumbVisibility,
                                                  selectedRow:
                                                      widget.selectedRow,
                                                  selectedRowIndex:
                                                      vm.selectedRowIndex,
                                                  onRowTap: widget.onRowTap,
                                                  configuration:
                                                      widget.configuration,
                                                  selectedRowSubWidgetBuilder:
                                                      widget
                                                          .selectedRowSubWidgetBuilder,
                                                  buildSizeCallback:
                                                      vm.buildSizeCallback,
                                                  child: widget.child,
                                                );
                                              });
                                        }),
                                  ),
                                ],
                              );
                            }),
                      ),
                    ),
                  );
                }),
          );
        },
      ),
    );
  }
}

class _RowWidget<T> extends StatefulWidget {
  const _RowWidget({
    super.key,
    required this.dataForRender,
    required this.columnWidths,
    required this.verticalScrollController,
    required this.thumbVisibility,
    required this.selectedRow,
    required this.selectedRowIndex,
    required this.onRowTap,
    required this.configuration,
    required this.selectedRowSubWidgetBuilder,
    required this.decorationConfiguration,
    required this.buildSizeCallback,
    required this.child,
  });

  final List<T> dataForRender;
  final List<double> columnWidths;
  final ScrollController verticalScrollController;
  final bool thumbVisibility;
  final T? selectedRow;
  final int? selectedRowIndex;
  final void Function(T model)? onRowTap;
  final SpargoTableConfig<T> configuration;
  final SpargoTableDecorationConfig decorationConfiguration;
  final SubRowWidget<T>? selectedRowSubWidgetBuilder;
  final void Function(Size size) buildSizeCallback;
  final Widget? child;

  @override
  State<_RowWidget<T>> createState() => _RowWidgetState<T>();
}

class _RowWidgetState<T> extends State<_RowWidget<T>> {
  final GlobalKey _key = GlobalKey();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final renderBoxRow =
          _key.currentContext?.findRenderObject() as RenderBox?;
      if (renderBoxRow != null) {
        widget.buildSizeCallback(renderBoxRow.size);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final itemsCount = widget.dataForRender.length +
        (widget.selectedRowSubWidgetBuilder != null &&
                widget.dataForRender.contains(widget.selectedRow)
            ? 1
            : 0);
    return Column(
      children: [
        if (widget.dataForRender.isNotEmpty)
          Flexible(
            child: Scrollbar(
              controller: widget.verticalScrollController,
              thumbVisibility: widget.thumbVisibility,
              child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                controller: widget.verticalScrollController,
                itemBuilder: (context, index) {
                  final colorRow =
                      widget.decorationConfiguration.colorRowsBetweenRows
                          ? index % 2 == 0
                              ? widget.decorationConfiguration.colorOddItems
                              : widget.decorationConfiguration.colorEvenItems ??
                                  Colors.grey.withValues(alpha: 210)
                          : null;
                  int resultIndex = index;
                  if (widget.selectedRowSubWidgetBuilder != null &&
                      widget.selectedRowIndex == index - 1) {
                    return widget.selectedRowSubWidgetBuilder!(
                        widget.dataForRender[index - 1]);
                  }
                  if (widget.selectedRowIndex != null &&
                          widget.selectedRowSubWidgetBuilder != null
                      ? index > widget.selectedRowIndex!
                      : false) {
                    resultIndex--;
                  }

                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: index == itemsCount - 1
                            ? widget.decorationConfiguration
                                .bottomPaddingForScrollbar
                            : 0),
                    child: SpargoTableRowWidget(
                      key: index == 0 ? _key : null,
                      isSelected: widget.selectedRow ==
                          widget.dataForRender[resultIndex],
                      onRowTap: widget.onRowTap != null
                          ? () => widget
                              .onRowTap!(widget.dataForRender[resultIndex])
                          : null,
                      columns: widget.configuration.columns,
                      columnWidths: widget.columnWidths,
                      buildRow: () => widget.configuration
                          .buildRow(widget.dataForRender[resultIndex]),
                      colorRow: colorRow,
                    ),
                  );
                },
                itemCount: itemsCount,
              ),
            ),
          ),
        if (widget.child != null) widget.child!,
      ],
    );
  }
}
