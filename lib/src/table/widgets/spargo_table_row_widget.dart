import 'package:flutter/material.dart';
import 'package:spargo_table/src/table/config/spargo_table_cell_config.dart';
import 'package:spargo_table/src/table/config/spargo_table_header_config.dart';
import 'package:spargo_table/src/table/widgets/spargo_table_cell_widget.dart';

class SpargoTableRowWidget extends StatelessWidget {
  const SpargoTableRowWidget({
    super.key,
    required this.columns,
    required this.columnWidths,
    required this.buildRow,
    required this.onRowTap,
    required this.isSelected,
    required this.colorRow,
    required this.showBottomBorder,
  });

  final List<SpargoTableColumnConfig> columns;
  final List<double> columnWidths;
  final List<SpargoTableCellConfig> Function() buildRow;
  final void Function()? onRowTap;
  final bool isSelected;
  final Color? colorRow;
  final bool? showBottomBorder;

  @override
  Widget build(BuildContext context) {
    final cells = buildRow();
    return Material(
      color: isSelected
          ? Theme.of(context).colorScheme.primary
          : colorRow ?? Colors.white,
      child: InkWell(
        onTap: onRowTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
              border: showBottomBorder == true
                  ? Border(
                      bottom: BorderSide(
                          color: Theme.of(context).colorScheme.outline))
                  : null),
          child: Row(
            spacing: 17,
            children: [
              for (int i = 0; i < cells.length; i++)
                SpargoTableCellWidget(
                    width: columnWidths[i], child: cells[i].child)
            ],
          ),
        ),
      ),
    );
  }
}
