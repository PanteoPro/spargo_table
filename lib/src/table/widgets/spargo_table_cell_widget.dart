import 'package:flutter/material.dart';

class SpargoTableCellWidget extends StatelessWidget {
  const SpargoTableCellWidget({
    super.key,
    required this.width,
    required this.child,
    this.alignment,
  });

  final double width;
  final Widget child;
  final MainAxisAlignment? alignment;

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
              mainAxisAlignment: alignment ?? MainAxisAlignment.start,
              children: [
                if (child is Text || child is RichText)
                  _buildEllipsisChild(child)
                else
                  child,
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
    return Flexible(
      child: Text(
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
      ),
    );
  }
  if (child is RichText) {
    return Flexible(
      child: RichText(
        text: child.text,
        textAlign: child.textAlign,
        textDirection: child.textDirection,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        textScaler: child.textScaler,
        strutStyle: child.strutStyle,
        textWidthBasis: child.textWidthBasis,
        textHeightBehavior: child.textHeightBehavior,
      ),
    );
  }
  return child;
}
