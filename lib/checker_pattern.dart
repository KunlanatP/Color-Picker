import 'dart:math';

import 'package:flutter/material.dart';

class CheckerPattern extends StatelessWidget {
  final double checkerSize;
  final Color color1;
  final Color color2;

  const CheckerPattern({
    Key? key,
    this.checkerSize = 8,
    this.color1 = const Color.fromRGBO(192, 192, 192, 1.0),
    this.color2 = const Color.fromRGBO(255, 255, 255, 1.0),
  }) : super(key: key);

  SizedBox _buildChecker(
      {required Color color, required double width, required double height}) {
    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
        ),
      ),
    );
  }

  Widget _buildColumn(
      {required bool isRowEven,
      required double height,
      required double maxWidth}) {
    final heightInCheckers = (height / checkerSize).ceil();
    final lastCheckerHeight = height - (heightInCheckers - 1) * checkerSize;

    return SizedBox(
        width: min(maxWidth, checkerSize),
        child: Column(
            children: List<Widget>.generate(
          heightInCheckers.floor(),
          (i) {
            final isColumnEven = i % 2 == 0;
            return _buildChecker(
              color: isRowEven ^ isColumnEven ? color1 : color2,
              width: min(maxWidth, checkerSize),
              height:
                  i == heightInCheckers - 1 ? lastCheckerHeight : checkerSize,
            );
          },
        )));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final widthInCheckers = (constraints.maxWidth / checkerSize).ceil();
        final lastColumnWidth =
            constraints.maxWidth - (widthInCheckers - 1) * checkerSize;

        return Row(
          children: List<Widget>.generate(
            widthInCheckers,
            (i) {
              return _buildColumn(
                isRowEven: i.isEven,
                height: constraints.maxHeight,
                maxWidth:
                    i == widthInCheckers - 1 ? lastColumnWidth : checkerSize,
              );
            },
          ),
        );
      },
    );
  }
}
