import 'package:flutter/material.dart';

class WorkshopScaffold extends StatefulWidget {
  const WorkshopScaffold({
    Key? key,
    required this.hsvColor,
    required this.colorDisplay,
    required this.colorPickerBuilder,
    required this.colorSliderHueBuilder,
    required this.colorSliderAlphaBuilder,
  }) : super(key: key);

  final HSVColor hsvColor;
  final Widget colorDisplay;
  final Widget colorPickerBuilder;
  final Widget colorSliderHueBuilder;
  final Widget colorSliderAlphaBuilder;

  @override
  _WorkshopScaffoldState createState() => _WorkshopScaffoldState();
}

class _WorkshopScaffoldState extends State<WorkshopScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 350,
          height: 700,
          color: const Color.fromARGB(255, 206, 206, 206),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Text(
                  'Slide',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 350,
                height: 350,
                child: widget.colorPickerBuilder,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 75,
                    height: 75,
                    child: widget.colorDisplay,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    children: [
                      SizedBox(
                        width: 245,
                        height: 20,
                        child: widget.colorSliderHueBuilder,
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: 245,
                        height: 20,
                        child: widget.colorSliderAlphaBuilder,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
