import 'package:flutter/material.dart';
import 'package:flutter_color_picker/alpha.dart';
import 'package:flutter_color_picker/checker_pattern.dart';
import 'package:flutter_color_picker/color_picker.dart';
import 'package:flutter_color_picker/hue.dart';
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
      colorSliderHueBuilder: _buildColorSliderHue(),
      colorSliderAlphaBuilder: _buildColorSliderAlpha(),
    );
  }

  Widget _buildColorDisplay() {
    return Stack(
      children: [
        const CheckerPattern(),
        Container(
          width: double.infinity,
          color: _hsvColor.toColor(),
          // decoration: BoxDecoration(
          //   color: _hsvColor.toColor(),
          //   // borderRadius: const BorderRadius.all(
          //   //   Radius.circular(5),
          //   // ),
          // ),
        ),
      ],
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

  Widget _buildColorSliderHue() {
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

  Widget _buildColorSliderAlpha() {
    //ColorComponent colorComponent

    return AlphaPicker(
      hsvColor: _hsvColor,
      selectedAlpha: _hsvColor.alpha,
      onAlphaSelected: (newAlpha) {
        setState(() {
          _hsvColor = _hsvColor.withAlpha(newAlpha);
        });
      },
    );
  }
}
