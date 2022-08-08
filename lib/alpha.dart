import 'package:flutter/material.dart';
import 'package:flutter_color_picker/checker_pattern.dart';

class AlphaPicker extends StatefulWidget {
  const AlphaPicker({
    Key? key,
    required this.hsvColor,
    required this.selectedAlpha,
    this.onAlphaSelected,
  }) : super(key: key);

  final HSVColor hsvColor;
  final double selectedAlpha;
  final AlphaPickerCallback? onAlphaSelected;

  @override
  _AlphaPickerState createState() => _AlphaPickerState();
}

class _AlphaPickerState extends State<AlphaPicker> {
  void _onDragStart(DragStartDetails details) {
    if (widget.onAlphaSelected == null) {
      return;
    }

    final sliderPercent = _calculateSliderPercent(details.localPosition);
    widget.onAlphaSelected!(
      _alphaFromSliderPercent(sliderPercent),
    );
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (widget.onAlphaSelected == null) {
      return;
    }

    final sliderPercent = _calculateSliderPercent(details.localPosition);
    widget.onAlphaSelected!(
      _alphaFromSliderPercent(sliderPercent),
    );
  }

  double _calculateSliderPercent(Offset localPosition) {
    final box = context.findRenderObject() as RenderBox;
    return ((localPosition.dx / box.size.width)).clamp(0.0, 1.0);
  }

  double _alphaFromSliderPercent(double sliderPercent) {
    return sliderPercent;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return GestureDetector(
        onPanStart: _onDragStart,
        onPanUpdate: _onDragUpdate,
        child: Stack(
          children: [
            const CheckerPattern(),
            CustomPaint(
              painter: AlphaPickerPainter(
                hue: widget.hsvColor.hue,
              ),
              size: Size.infinite,
            ),
            _buildSelector(constraints.maxWidth)
          ],
        ),
      );
    });
  }

  Widget _buildSelector(double width) {
    final huePercent = widget.selectedAlpha;
    return Align(
      alignment: Alignment((huePercent * 2) - 1.0, 0.0),
      child: Container(
        width: 3,
        height: double.infinity,
        color: Colors.black,
      ),
    );
  }
}

typedef AlphaPickerCallback = void Function(double alpha);

class AlphaPickerPainter extends CustomPainter {
  AlphaPickerPainter({
    required this.hue,
  });

  final double hue;

  @override
  void paint(Canvas canvas, Size size) {
    final alphaGradientShader = LinearGradient(
      colors: [
        /// HSV Color
        HSVColor.fromAHSV(0.0, hue, 1.0, 1.0).toColor(),
        HSVColor.fromAHSV(0.1, hue, 1.0, 1.0).toColor(),
        HSVColor.fromAHSV(0.2, hue, 1.0, 1.0).toColor(),
        HSVColor.fromAHSV(0.3, hue, 1.0, 1.0).toColor(),
        HSVColor.fromAHSV(0.4, hue, 1.0, 1.0).toColor(),
        HSVColor.fromAHSV(0.5, hue, 1.0, 1.0).toColor(),
        HSVColor.fromAHSV(0.6, hue, 1.0, 1.0).toColor(),
        HSVColor.fromAHSV(0.7, hue, 1.0, 1.0).toColor(),
        HSVColor.fromAHSV(0.8, hue, 1.0, 1.0).toColor(),
        HSVColor.fromAHSV(0.9, hue, 1.0, 1.0).toColor(),
      ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).createShader(Offset.zero & size);

    final paint = Paint()..shader = alphaGradientShader;

    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
