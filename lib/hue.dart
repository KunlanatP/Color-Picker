import 'package:flutter/material.dart';

class HuePicker extends StatefulWidget {
  const HuePicker({
    Key? key,
    required this.selectedHue,
    this.onHueSelected,
  }) : super(key: key);

  final double selectedHue;
  final HuePickerCallback? onHueSelected;

  @override
  _HuePickerState createState() => _HuePickerState();
}

class _HuePickerState extends State<HuePicker> {
  void _onDragStart(DragStartDetails details) {
    if (widget.onHueSelected == null) {
      return;
    }

    final sliderPercent = _calculateSliderPercent(details.localPosition);
    widget.onHueSelected!(
      _hueFromSliderPercent(sliderPercent),
    );
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (widget.onHueSelected == null) {
      return;
    }

    final sliderPercent = _calculateSliderPercent(details.localPosition);
    widget.onHueSelected!(
      _hueFromSliderPercent(sliderPercent),
    );
  }

  double _calculateSliderPercent(Offset localPosition) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    return (1.0 - (localPosition.dx / box.size.width)).clamp(0.0, 1.0);
  }

  double _hueFromSliderPercent(double sliderPercent) {
    return sliderPercent * 360;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return GestureDetector(
        onPanStart: _onDragStart,
        onPanUpdate: _onDragUpdate,
        child: Stack(
          children: [
            CustomPaint(
              painter: HuePickerPainter(),
              size: Size.infinite,
            ),
            _buildSelector(constraints.maxWidth),
          ],
        ),
      );
    });
  }

  Widget _buildSelector(double width) {
    final huePercent = widget.selectedHue / 360;
    return Align(
      alignment: Alignment(1.0 - (huePercent * 2), 0.0),
      child: Container(
        width: 3,
        height: double.infinity,
        color: Colors.black,
      ),
    );
  }
}

typedef HuePickerCallback = void Function(double hue);

class HuePickerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final hueGradientShader = LinearGradient(
      colors: [
        /// HSV Color
        const HSVColor.fromAHSV(1.0, 0.0, 1.0, 1.0).toColor(),
        const HSVColor.fromAHSV(1.0, 51.0, 1.0, 1.0).toColor(),
        const HSVColor.fromAHSV(1.0, 102.0, 1.0, 1.0).toColor(),
        const HSVColor.fromAHSV(1.0, 153.0, 1.0, 1.0).toColor(),
        const HSVColor.fromAHSV(1.0, 204.0, 1.0, 1.0).toColor(),
        const HSVColor.fromAHSV(1.0, 255.0, 1.0, 1.0).toColor(),
        const HSVColor.fromAHSV(1.0, 306.0, 1.0, 1.0).toColor(),
        const HSVColor.fromAHSV(1.0, 360.0, 1.0, 1.0).toColor(),
      ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).createShader(Offset.zero & size);
    // Offset.zero & size === Rect.fromLTWH(0,0,size.width, size.height)

    final paint = Paint()..shader = hueGradientShader;

    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
