import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_color_picker/workshop_scaffold.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WidgetWorkshop(),
    );
  }
}

class WidgetWorkshop extends StatefulWidget {
  const WidgetWorkshop({Key? key}) : super(key: key);

  @override
  _WidgetWorkshopState createState() => _WidgetWorkshopState();
}

class _WidgetWorkshopState extends State<WidgetWorkshop> {
  HSVColor _hsvColor = const HSVColor.fromAHSV(1.0, 0, 1.0, 1.0);

  @override
  Widget build(BuildContext context) {
    return WorkshopScaffold(
      hsvColor: _hsvColor,
      colorDisplay: _buildColorDisplay(),
      colorPickerBuilder: _buildColorPicker(),
      colorSliderBuilder: _buildColorSlider(),
    );
  }

  Widget _buildColorDisplay() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _hsvColor.toColor(),
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
      ),
    );
  }

  Widget _buildColorPicker() {
    //ColorComponent colorComponent
    return ColorPicker(
      hsvColor: _hsvColor,
      onColorSelected: (newColor) {
        setState(() {
          _hsvColor = newColor;
        });
      },
    );
  }

  Widget _buildColorSlider() {
    //ColorComponent colorComponent
    return HuePicker(
      selectedHue: _hsvColor.hue,
      onHueSelected: (newHue) {
        setState(() {
          _hsvColor = _hsvColor.withHue(newHue);
        });
      },
    );
  }
}

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
  });

  final double hue;

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
        /// RGB Color
        // const Color(0xFFFF0000),
        // const Color(0xFF00FF00),
        // const Color(0xFF0000FF),
        // const Color(0xFFFF0000),

        /// HSL Color
        // const HSLColor.fromAHSL(1.0, 0.0, 1.0, 0.5).toColor(),
        // const HSLColor.fromAHSL(1.0, 51.0, 1.0, 0.5).toColor(),
        // const HSLColor.fromAHSL(1.0, 102.0, 1.0, 0.5).toColor(),
        // const HSLColor.fromAHSL(1.0, 153.0, 1.0, 0.5).toColor(),
        // const HSLColor.fromAHSL(1.0, 204.0, 1.0, 0.5).toColor(),
        // const HSLColor.fromAHSL(1.0, 255.0, 1.0, 0.5).toColor(),
        // const HSLColor.fromAHSL(1.0, 306.0, 1.0, 0.5).toColor(),
        // const HSLColor.fromAHSL(1.0, 360.0, 1.0, 0.5).toColor(),

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
