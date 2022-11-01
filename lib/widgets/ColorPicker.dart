import 'package:flutter/material.dart';
import 'package:image_scroller/util/hsvToRgb.dart';
import 'package:image_scroller/util/rgbToHsv.dart';

class ColorPicker extends StatefulWidget {
  const ColorPicker({
    super.key,
    this.selected,
    required this.onSelect,
    required this.onNext,
    this.showCheckMarkInsteadOfNext = false,
  });

  final void Function(Color color) onSelect;
  final void Function() onNext;

  final Color? selected;

  final bool showCheckMarkInsteadOfNext;

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  static const List<Color> allColors = [
    Colors.white,
    Colors.red,
    Colors.redAccent,
    Colors.pink,
    Colors.pinkAccent,
    Colors.purple,
    Colors.purpleAccent,
    Colors.deepPurple,
    Colors.deepPurpleAccent,
    Colors.indigo,
    Colors.indigoAccent,
    Colors.blue,
    Colors.blueAccent,
    Colors.lightBlue,
    Colors.cyan,
    Colors.lightBlueAccent,
    Colors.cyanAccent,
    Colors.tealAccent,
    Colors.greenAccent,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lightGreenAccent,
    Colors.lime,
    Colors.limeAccent,
    Colors.yellow,
    Colors.yellowAccent,
    Colors.amber,
    Colors.amberAccent,
    Colors.orange,
    Colors.orangeAccent,
    Colors.deepOrange,
    Colors.deepOrangeAccent,
    Colors.brown,
    Colors.blueGrey,
    Colors.black,
  ];
  Color? selected;

  @override
  void initState() {
    // TODO: implement initState
    selected = widget.selected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Pick your\nfavorite color...",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  height: 1.25,
                ),
              ),
            ),
            SizedBox(
              width: screenWidth,
              height: 0.70 * screenHeight,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Center(
                  child: Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: allColors
                        .map(
                          (color) => TextButton(
                            style: const ButtonStyle(
                              animationDuration: Duration(seconds: 0),
                            ),
                            onPressed: () {
                              setState(() {
                                selected = color;
                                widget.onSelect(color);
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                gradient: (() {
                                  List<int> hsv = rgbToHsv(
                                    color.red.toDouble(),
                                    color.green.toDouble(),
                                    color.blue.toDouble(),
                                  );

                                  List<int> rgb = hsvToRgb(
                                    hsv[0].toDouble(),
                                    hsv[1].toDouble(),
                                    (hsv[2] - 25).abs().toDouble(),
                                  );
                                  return LinearGradient(colors: [
                                    // Put the lighter one first
                                    if (hsv[2] > (hsv[2] - 25).abs()) color,
                                    Color.fromARGB(255, rgb[0], rgb[1], rgb[2]),
                                    if (hsv[2] <= (hsv[2] - 25).abs()) color,
                                  ]);
                                })(),
                                border: Border.all(
                                  width: 8,
                                  color: selected != color
                                      ? Colors.white
                                      : const Color.fromARGB(255, 44, 160, 48),
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: selected != color
                                        ? const Color.fromARGB(
                                            255,
                                            192,
                                            192,
                                            192,
                                          )
                                        : Colors.green,
                                    spreadRadius: selected != color ? 1 : 4,
                                    blurRadius: 5,
                                    offset: selected != color
                                        ? const Offset(-1.5, 3.0)
                                        : Offset.zero,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: selected == null ? null : widget.onNext,
                    icon: Icon(
                      widget.showCheckMarkInsteadOfNext
                          ? Icons.check
                          : Icons.keyboard_double_arrow_right,
                    ),
                    iconSize: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
