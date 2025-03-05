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
    this.maxHeightSubWidget,
    this.decorationConfiguration = const SpargoTableDecorationConfig(),
    this.child,
    this.getIsRowMarked,
  });

  final List<T> data;
  final T? selectedRow;
  final SpargoTableConfig<T> configuration;
  final SpargoTableDecorationConfig decorationConfiguration;

  final void Function(T model)? onRowTap;
  final bool Function(T model)? getIsRowMarked;
  final SubRowWidget<T>? selectedRowSubWidgetBuilder;
  final bool thumbVisibility;
  final double? maxHeight;
  final double? maxHeightSubWidget;
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
    decorationConfiguration: widget.decorationConfiguration,
  );

  @override
  void initState() {
    super.initState();
    vm.init(widget);
  }

  @override
  void dispose() {
    vm.destroy();
    super.dispose();
  }

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
          if (vm.currentConstraints != constraints) {
            vm.setCurrentConstraints(constraints);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              vm.setIsDisplayedHorizontalScroll();
              vm.calculateMaxHeightTable();
            });
          }
          return ValueListenableBuilder(
              valueListenable: vm.heightRowNotifier,
              builder: (context, heightRow, _) {
                return Container(
                  decoration: BoxDecoration(
                      border: widget.decorationConfiguration.borderTable,
                      borderRadius: widget.decorationConfiguration.tableBorderRadius),
                  child: Scrollbar(
                    controller: vm.horizontalScrollController,
                    thumbVisibility: widget.thumbVisibility,
                    thickness: widget.decorationConfiguration.scrollbarBottomHeight,
                    child: SingleChildScrollView(
                      key: vm.tableKey,
                      controller: vm.horizontalScrollController,
                      scrollDirection: Axis.horizontal,
                      child: ValueListenableBuilder(
                          valueListenable: vm.maxHeightNotifier,
                          builder: (context, maxHeight, _) {
                            return ValueListenableBuilder(
                                valueListenable: vm.isDisplayedHorizontalScrollNotifier,
                                builder: (context, isDisplayedHorizontalScroll, _) {
                                  return ValueListenableBuilder(
                                      valueListenable: vm.heightSubWidgetNotifier,
                                      builder: (context, addedHeightBySubWidget, _) {
                                        return ValueListenableBuilder(
                                            valueListenable: vm.columnWidthsNotifier,
                                            builder: (context, columnWidths, _) {
                                              if (!listEquals(vm.currentColumnWidths, columnWidths)) {
                                                vm.setCurrentColumnWidths(columnWidths);
                                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                                  vm.setIsDisplayedHorizontalScroll();
                                                  vm.calculateMaxHeightTable();
                                                });
                                              }
                                              final heightSubWidget =
                                                  widget.maxHeightSubWidget ?? addedHeightBySubWidget ?? 0;
                                              double heightContentTable = (heightRow != null
                                                  ? min(widget.maxHeight ?? maxHeight ?? 9999999,
                                                      heightRow * widget.data.length + heightSubWidget)
                                                  : (maxHeight != null
                                                      ? maxHeight + heightSubWidget
                                                      : widget.maxHeight ?? 300));
                                              if (heightContentTable < (maxHeight ?? widget.maxHeight ?? 300) &&
                                                  isDisplayedHorizontalScroll) {
                                                final addedHeight = min(
                                                    (maxHeight ?? widget.maxHeight ?? 300) - heightContentTable,
                                                    widget.decorationConfiguration.bottomPaddingForScrollbar);
                                                heightContentTable += addedHeight;
                                              }
                                              return Column(
                                                children: [
                                                  SpargoTableHeaderWidget(
                                                    decorationConfig: widget.decorationConfiguration,
                                                    maxHeight: vm.heightHeader,
                                                    key: vm.headerKey,
                                                    columns: widget.configuration.columns,
                                                    columnWidths: columnWidths,
                                                    onStartResizeColumn: vm.onStartResizeColumn,
                                                    onMoveResizeColumn: vm.onMoveResizeColumn,
                                                    onEndResizeColumn: vm.onEndResizeColumn,
                                                  ),
                                                  ConstrainedBox(
                                                    constraints: BoxConstraints(
                                                        maxHeight: heightContentTable, maxWidth: vm.tableWidth),
                                                    child: ValueListenableBuilder(
                                                        valueListenable: vm.filteredDataNotifier,
                                                        builder: (context, filteredData, _) {
                                                          return ValueListenableBuilder(
                                                              valueListenable: vm.sortedDataNotifier,
                                                              builder: (context, sortedData, _) {
                                                                final dataForRender =
                                                                    sortedData ?? filteredData ?? widget.data;
                                                                return _ContentWidget<T>(
                                                                  heightRow: heightRow,
                                                                  dataForRender: dataForRender,
                                                                  verticalScrollController: vm.verticalScrollController,
                                                                  columnWidths: columnWidths,
                                                                  decorationConfiguration:
                                                                      widget.decorationConfiguration,
                                                                  thumbVisibility: widget.thumbVisibility,
                                                                  selectedRow: widget.selectedRow,
                                                                  selectedRowIndex: vm.selectedRowIndex,
                                                                  onRowTap: widget.onRowTap,
                                                                  getIsRowMarked: widget.getIsRowMarked,
                                                                  configuration: widget.configuration,
                                                                  selectedRowSubWidgetBuilder:
                                                                      widget.selectedRowSubWidgetBuilder,
                                                                  buildSizeCallback: vm.buildSizeCallback,
                                                                  isDisplayedHorizontalScroll:
                                                                      isDisplayedHorizontalScroll,
                                                                  child: widget.child,
                                                                );
                                                              });
                                                        }),
                                                  ),
                                                ],
                                              );
                                            });
                                      });
                                });
                          }),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}

class _ContentWidget<T> extends StatefulWidget {
  const _ContentWidget({
    super.key,
    required this.heightRow,
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
    required this.isDisplayedHorizontalScroll,
    required this.child,
    required this.getIsRowMarked,
  });

  final double? heightRow;
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
  final bool isDisplayedHorizontalScroll;
  final Widget? child;
  final bool Function(T model)? getIsRowMarked;

  @override
  State<_ContentWidget<T>> createState() => _ContentWidgetState<T>();
}

class _ContentWidgetState<T> extends State<_ContentWidget<T>> {
  final GlobalKey _key = GlobalKey();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final renderBoxRow = _key.currentContext?.findRenderObject() as RenderBox?;
      if (renderBoxRow != null) {
        widget.buildSizeCallback(renderBoxRow.size);
      }
    });
  }

  Color? getColor(int adjustedIndex) {
    return (widget.getIsRowMarked != null && widget.getIsRowMarked!(widget.dataForRender[adjustedIndex]))
        ? widget.decorationConfiguration.rowIsMarkedColor
        : widget.decorationConfiguration.colorRowsBetweenRows
            ? (adjustedIndex % 2 == 0
                ? widget.decorationConfiguration.colorOddItems
                : widget.decorationConfiguration.colorEvenItems ?? Colors.grey.withAlpha(210))
            : null;
  }

  @override
  Widget build(BuildContext context) {
    final itemsCount = widget.dataForRender.length;
    return Column(
      children: [
        if (widget.dataForRender.isNotEmpty)
          Offstage(
            child: SpargoTableRowWidget(
              key: _key,
              isSelected: false,
              onRowTap: null,
              columns: widget.configuration.columns,
              columnWidths: widget.columnWidths,
              buildRow: () => widget.configuration.buildRow(widget.dataForRender[0]),
              colorRow: null,
              border: widget.decorationConfiguration.borderRow,
            ),
          ),
        if (widget.dataForRender.isNotEmpty && widget.heightRow != null)
          Flexible(
            child: Scrollbar(
              controller: widget.verticalScrollController,
              thumbVisibility: widget.thumbVisibility,
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: widget.isDisplayedHorizontalScroll
                        ? widget.decorationConfiguration.bottomPaddingForScrollbar
                        : 0),
                child: SelectionArea(
                  child: CustomScrollView(
                    physics: const ClampingScrollPhysics(),
                    controller: widget.verticalScrollController,
                    slivers: [
                      SliverFixedExtentList(
                        itemExtent: widget.heightRow!,
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final colorRow = getColor(index);

                            return SpargoTableRowWidget(
                              key: Key('row_$index'),
                              isSelected: widget.selectedRow == widget.dataForRender[index],
                              onRowTap:
                                  widget.onRowTap != null ? () => widget.onRowTap!(widget.dataForRender[index]) : null,
                              columns: widget.configuration.columns,
                              columnWidths: widget.columnWidths,
                              buildRow: () => widget.configuration.buildRow(widget.dataForRender[index]),
                              colorRow: colorRow,
                              border: widget.decorationConfiguration.borderRow,
                            );
                          },
                          childCount: widget.selectedRowIndex != null ? widget.selectedRowIndex! + 1 : itemsCount,
                        ),
                      ),
                      if (widget.selectedRowIndex != null && widget.selectedRowSubWidgetBuilder != null) ...[
                        SliverToBoxAdapter(
                          child: widget.selectedRowSubWidgetBuilder!(widget.dataForRender[widget.selectedRowIndex!]),
                        ),
                        if (widget.selectedRowIndex != itemsCount - 1)
                          SliverFixedExtentList(
                            itemExtent: widget.heightRow!,
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final adjustedIndex = index + (widget.selectedRowIndex! + 1);
                                final colorRow = getColor(adjustedIndex);

                                return SpargoTableRowWidget(
                                  key: Key('row_$adjustedIndex'),
                                  isSelected: widget.selectedRow == widget.dataForRender[adjustedIndex],
                                  onRowTap: widget.onRowTap != null
                                      ? () => widget.onRowTap!(widget.dataForRender[adjustedIndex])
                                      : null,
                                  columns: widget.configuration.columns,
                                  columnWidths: widget.columnWidths,
                                  buildRow: () => widget.configuration.buildRow(widget.dataForRender[adjustedIndex]),
                                  colorRow: colorRow,
                                  border: widget.decorationConfiguration.borderRow,
                                );
                              },
                              childCount: itemsCount - (widget.selectedRowIndex! + 1),
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        if (widget.child != null) widget.child!,
      ],
    );
  }
}
