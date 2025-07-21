import 'package:flutter/material.dart';

class SpargoTableCellWidget extends StatelessWidget {
  const SpargoTableCellWidget(
      {super.key, required this.width, required this.child});

  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
      child: Center(
        child: Theme(
          data: Theme.of(context).copyWith(
            textTheme: Theme.of(context).textTheme.copyWith(
                bodyLarge: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 40)),
          ),
          child: ClipRect(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  child: _buildEllipsisChild(child),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildEllipsisChild(Widget child) {
  if (child is Text) {
    return Text(
      child.data ?? '',
      style: child.style,
      textAlign: child.textAlign,
      textDirection: child.textDirection,
      locale: child.locale,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      textScaler: child.textScaler,
      semanticsLabel: child.semanticsLabel,
      strutStyle: child.strutStyle,
      textWidthBasis: TextWidthBasis.parent,
      textHeightBehavior: child.textHeightBehavior,
    );
  }
  return child;
}
