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
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
