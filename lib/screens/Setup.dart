import 'package:flutter/material.dart';
import 'package:image_scroller/widgets/ColorPicker.dart';
import 'package:image_scroller/widgets/InterestedTopics.dart';
import 'package:image_scroller/widgets/Loading.dart';

class Setup extends StatefulWidget {
  const Setup({super.key, required this.onSetupComplete});

  final void Function(Color selectedColor, List<String> topics) onSetupComplete;

  @override
  State<Setup> createState() => _SetupState();
}

class _SetupState extends State<Setup> {
  Color? selectedColor;
  String inputValue = "";
  List<String> topics = [];
  bool done = false;

  int page = 0;
  PageController controller = PageController();

  final PageStorageBucket _bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        if (done)
          Container(
            color: const Color.fromARGB(171, 158, 158, 158),
            width: screenWidth,
            height: screenHeight,
            child: const Loading(color: Colors.white),
          ),
        PageView(
          controller: controller,
          children: [
            PageStorage(
              bucket: _bucket,
              child: ColorPicker(
                key: const PageStorageKey<String>('colorPickerPage'),
                selected: selectedColor,
                onSelect: (color) {
                  selectedColor = color;
                },
                onNext: () {
                  setState(() {});

                  while (!mounted) {}
                  controller.jumpToPage(1);
                },
              ),
            ),
            if (selectedColor != null)
              PageStorage(
                bucket: _bucket,
                child: InterestedTopics(
                  key: const PageStorageKey<String>('interestedTopicsPage'),
                  inputValue: inputValue,
                  topics: topics,
                  onNext: () {
                    widget.onSetupComplete(selectedColor!, topics);
                    setState(() {
                      done = true;
                    });
                  },
                  onPrev: () => controller.jumpToPage(0),
                  onType: (List<String> topics, String inputValue) {
                    this.inputValue = inputValue;
                    this.topics = topics;
                  },
                ),
              )
          ],
        ),
        if (done)
          Container(
            color: const Color.fromARGB(171, 158, 158, 158),
            width: screenWidth,
            height: screenHeight,
            child: const Loading(color: Colors.white),
          ),
      ],
    );
  }
}
