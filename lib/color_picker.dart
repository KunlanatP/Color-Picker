import 'dart:ui';

import 'package:flutter/material.dart';

class ColorPicker extends StatefulWidget {
  const ColorPicker({
    Key? key,
    required this.hsvColor,
    this.onColorSelected,
  }) : super(key: key);

  final HSVColor hsvColor;
  final ColorPickerCallback? onColorSelected;

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  void _onDragStart(DragStartDetails details) {
    if (widget.onColorSelected == null) {
      return;
    }

    final percentOffset = _calculatePercentOffset(details.localPosition);
    widget.onColorSelected!(
      _hsvColorFromPercentOffset(percentOffset),
    );
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (widget.onColorSelected == null) {
      return;
    }

    final percentOffset = _calculatePercentOffset(details.localPosition);
    widget.onColorSelected!(
      _hsvColorFromPercentOffset(percentOffset),
    );
  }

  Offset _calculatePercentOffset(Offset localPosition) {
    final RenderBox box = context.findRenderObject() as RenderBox;

    return Offset((localPosition.dx / box.size.width).clamp(0.0, 1.0),
        (1.0 - (localPosition.dy / box.size.height)).clamp(0.0, 1.0));
  }

  HSVColor _hsvColorFromPercentOffset(Offset percentOffset) {
    return HSVColor.fromAHSV(
      1.0,
      widget.hsvColor.hue,
      percentOffset.dx,
      percentOffset.dy,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return GestureDetector(
        onPanStart: _onDragStart,
        onPanUpdate: _onDragUpdate,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            CustomPaint(
              painter: ColorPickerPainter(
                hue: widget.hsvColor.hue,
                // alpha: widget.hsvColor.alpha,
              ),
              size: Size.infinite,
            ),
            _buildSelector(Size(constraints.maxWidth, constraints.maxHeight)),
          ],
        ),
      );
    });
  }

  Widget _buildSelector(Size size) {
    final double saturationPercent = widget.hsvColor.saturation;
    final double darknessPercent = 1.0 - widget.hsvColor.value;

    // print('Saturation: $saturationPercent, Darkness: $darknessPercent');

    return Positioned(
      left: lerpDouble(0, size.width, saturationPercent),
      top: lerpDouble(0, size.height, darknessPercent),
      child: FractionalTranslation(
        translation: const Offset(-0.5, -0.5),
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 3,
            ),
          ),
        ),
      ),
    );
  }
}

typedef ColorPickerCallback = void Function(HSVColor newColor);

class ColorPickerPainter extends CustomPainter {
  ColorPickerPainter({
    required this.hue,
    // required this.alpha,
  });

  final double hue;
  // final double alpha;

  @override
  void paint(Canvas canvas, Size size) {
    final lightGradientShader = const LinearGradient(
      colors: [
        Colors.white,
        Colors.black,
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ).createShader(Offset.zero & size);
    final lightPaint = Paint()..shader = lightGradientShader;

    canvas.drawRect(Offset.zero & size, lightPaint);

    final onSaturationColor = HSVColor.fromAHSV(1.0, hue, 0.0, 1.0);
    final fullSaturationColor = HSVColor.fromAHSV(1.0, hue, 1.0, 1.0);
    final saturationGradientShader = LinearGradient(
      colors: [
        onSaturationColor.toColor(),
        fullSaturationColor.toColor(),
      ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).createShader(Offset.zero & size);
    final saturationPaint = Paint()
      ..shader = saturationGradientShader
      ..blendMode = BlendMode.modulate;

    canvas.drawRect(Offset.zero & size, saturationPaint);
  }

  @override
  bool shouldRepaint(ColorPickerPainter oldDelegate) {
    return hue != oldDelegate.hue;
  }
}
