import 'dart:math';

import 'package:flutter/material.dart';
import 'package:spargo_table/src/table/config/spargo_table_config.dart';
import 'package:spargo_table/src/table/models/spargo_sort_model.dart';
import 'package:spargo_table/src/table/spargo_table.dart';

class SpargoTableViewModel<T> {
  SpargoTableViewModel({
    required this.data,
    required this.configuration,
    required this.selectedRow,
    required State widgetState,
  }) : _widgetState = widgetState;

  final State _widgetState;
  bool get mounted => _widgetState.mounted;

  final SpargoTableConfig<T> configuration;
  List<T> data;
  T? selectedRow;
  int? selectedRowIndex;

  final ValueNotifier<List<double>> columnWidthsNotifier = ValueNotifier([]);
  final Map<int, ValueNotifier<String?>> queryFilters = {};
  final ValueNotifier<List<T>?> filteredDataNotifier = ValueNotifier(null);
  final ValueNotifier<List<T>?> sortedDataNotifier = ValueNotifier(null);
  final ValueNotifier<SpargoSortModel?> sortColumnNotifier =
      ValueNotifier(null);

  final ValueNotifier<double?> heightRowNotifier = ValueNotifier(null);

  final verticalScrollController = ScrollController();
  final horizontalScrollController = ScrollController();

  final GlobalKey tableKey = GlobalKey();
  final GlobalKey headerKey = GlobalKey();

  final ValueNotifier<double?> maxHeightNotifier = ValueNotifier(null);
  final ValueNotifier<double?> maxWidthNotifier = ValueNotifier(null);

  BoxConstraints? get currentConstraints => _currentConstraints;
  BoxConstraints? _currentConstraints;
  List<double>? get currentColumnWidths => _currentColumnWidths;
  List<double>? _currentColumnWidths;
  double? get heightHeader => _heightHeader;
  double? _heightHeader;

  final ValueNotifier<bool> isDisplayedHorizontalScrollNotifier =
      ValueNotifier(false);

  void destroy() {
    for (final notifiers in queryFilters.values) {
      notifiers.dispose();
    }
    columnWidthsNotifier.dispose();
    filteredDataNotifier.dispose();
    sortColumnNotifier.dispose();
    heightRowNotifier.dispose();
    sortedDataNotifier.dispose();
    verticalScrollController.dispose();
    horizontalScrollController.dispose();
    maxHeightNotifier.dispose();
    maxWidthNotifier.dispose();
    isDisplayedHorizontalScrollNotifier.dispose();
  }

  void init() {
    final columnWidths = <double>[];
    for (int i = 0; i < configuration.columns.length; i++) {
      columnWidths.add(configuration.columns[i].width);
      if (configuration.columns[i].queryFilter != null) {
        queryFilters[i] = ValueNotifier(null);
      }
    }
    columnWidthsNotifier.value = columnWidths;
    _calculateSelectedRowIndex();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setIsDisplayedHorizontalScroll();
    });
  }

  void setIsDisplayedHorizontalScroll() {
    isDisplayedHorizontalScrollNotifier.value =
        horizontalScrollController.position.maxScrollExtent > 0;
  }

  void setCurrentConstraints(BoxConstraints constraints) {
    _currentConstraints = constraints;
  }

  void setCurrentColumnWidths(List<double> columnWidths) {
    _currentColumnWidths = columnWidths;
  }

  void setSortColumnIndex(int index, SpargoSortType? type) {
    if (type == null) {
      sortColumnNotifier.value = null;
      sortedDataNotifier.value = null;
      _calculateSelectedRowIndex();
      return;
    }
    sortColumnNotifier.value = SpargoSortModel(columnIndex: index, type: type);
    _sortingData();
    _calculateSelectedRowIndex();
  }

  void _sortingData() {
    if (sortColumnNotifier.value == null) return;
    List<T> newSortedData = [...(filteredDataNotifier.value ?? data)];
    newSortedData.sort(
      (a, b) => configuration.columns[sortColumnNotifier.value!.columnIndex]
          .sortBy!(a, b, sortColumnNotifier.value!.type),
    );
    sortedDataNotifier.value = newSortedData;
  }

  void setQueryByColumn(String query, int columnIndex) {
    if (queryFilters.containsKey(columnIndex)) {
      queryFilters[columnIndex]!.value = query;
    }
    queryFilters[columnIndex] = ValueNotifier(query);

    _filteringData();
    _sortingData();
    _calculateSelectedRowIndex();
  }

  void _filteringData() {
    Iterable<T> newFilteredData = [...data];
    bool anyFilter = false;
    for (int i = 0; i < configuration.columns.length; i++) {
      if (queryFilters.containsKey(i) && queryFilters[i]!.value != null) {
        final buffer = newFilteredData.where((e) =>
            configuration.columns[i].queryFilter!(queryFilters[i]!.value!, e));
        newFilteredData = buffer;
        anyFilter = true;
      }
    }
    if (anyFilter) {
      filteredDataNotifier.value = newFilteredData.toList();
    } else {
      filteredDataNotifier.value = null;
    }
  }

  int? _resizeColumnIndex;
  double? _startColumnWidth;
  Offset? _startMousePosition;
  Offset? _startTablePosition;

  void onStartResizeColumn(PointerDownEvent event, int index) {
    _resizeColumnIndex = index;
    _startColumnWidth = columnWidthsNotifier.value[index];
    _startMousePosition = event.localPosition;
    final renderBox = tableKey.currentContext?.findRenderObject() as RenderBox?;
    _startTablePosition = renderBox?.localToGlobal(Offset.zero);
  }

  void onEndResizeColumn(PointerUpEvent event, int index) {
    _resizeColumnIndex = null;
    _startColumnWidth = null;
    _startMousePosition = null;
    setIsDisplayedHorizontalScroll();
  }

  void onMoveResizeColumn(PointerMoveEvent event, int index) {
    if (_resizeColumnIndex == null) return;
    final renderBox = tableKey.currentContext?.findRenderObject() as RenderBox?;
    final differenceByTablePositionX = (_startTablePosition?.dx ?? 0) -
        (renderBox?.localToGlobal(Offset.zero).dx ?? 0);
    final differenceX = event.localPosition.dx - _startMousePosition!.dx;
    final newWidths = [...columnWidthsNotifier.value];
    newWidths[index] =
        max(50, _startColumnWidth! + differenceX + differenceByTablePositionX);
    columnWidthsNotifier.value = newWidths;
    setIsDisplayedHorizontalScroll();
  }

  void didUpdateWidget(SpargoTable<T> widget, SpargoTable<T> oldWidget) {
    this.data = widget.data;
    selectedRow = widget.selectedRow;
    if (widget.selectedRow != oldWidget.selectedRow) {
      _calculateSelectedRowIndex();
    }
  }

  void _calculateSelectedRowIndex() {
    final resultData =
        sortedDataNotifier.value ?? filteredDataNotifier.value ?? data;
    for (int i = 0; i < resultData.length; i++) {
      final item = resultData[i];
      if (item == selectedRow) {
        selectedRowIndex = i;
        return;
      }
    }
    selectedRowIndex = null;
  }

  void buildSizeCallback(Size sizeRow) {
    heightRowNotifier.value ??= sizeRow.height;
  }

  void setSizes() {
    final renderBox = tableKey.currentContext?.findRenderObject() as RenderBox?;
    final renderBoxHeader =
        headerKey.currentContext?.findRenderObject() as RenderBox?;
    _heightHeader = renderBoxHeader?.size.height;
    if (_heightHeader == null) return;
    maxHeightNotifier.value = renderBox!.size.height - _heightHeader!;
    maxWidthNotifier.value = renderBox.size.width;
  }

  double get tableWidth =>
      columnWidthsNotifier.value.reduce((a, b) => a + b) +
      17 * (configuration.columns.length);
}
