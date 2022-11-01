import 'package:flutter/material.dart';

class InterestedTopics extends StatefulWidget {
  const InterestedTopics({
    super.key,
    required this.onNext,
    required this.onPrev,
    required this.onType,
    required this.inputValue,
    required this.topics,
    this.showBack = true,
  });

  final void Function(List<String> topics, String inputValue) onType;
  final void Function() onNext;
  final void Function() onPrev;

  final String inputValue;
  final List<String> topics;

  final bool showBack;

  @override
  State<InterestedTopics> createState() => _InterestedTopicsState();
}

class _InterestedTopicsState extends State<InterestedTopics> {
  Set<String> topics = {};
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    topics = Set.from(widget.topics);
    controller.text = widget.inputValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Tell us what all\nyou'd like to see about...",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  height: 1.25,
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: TextField(
                        autofocus: true,
                        autocorrect: true,
                        onChanged: (String text) {
                          widget.onType(topics.toList(), controller.text);
                        },
                        onSubmitted: (text) => setState(() {
                          if (controller.text.trim().isNotEmpty) {
                            topics.add(controller.text.trim());
                          }
                          widget.onType(topics.toList(), controller.text);
                          controller.text = '';
                        }),
                        controller: controller,
                        style: const TextStyle(fontSize: 18),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade300,
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          suffixIcon: IconButton(
                            padding: const EdgeInsets.all(0.0),
                            onPressed: () => setState(() {
                              if (controller.text.trim().isNotEmpty) {
                                topics.add(controller.text.trim());
                              }
                              widget.onType(topics.toList(), controller.text);
                              controller.text = '';
                            }),
                            icon: const Icon(
                              Icons.add,
                              color: Colors.blue,
                            ),
                            iconSize: 18,
                          ),
                          // suffixStyle: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: screenWidth,
                height: (0.60 * screenHeight) - bottomInset,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: (topics.toList()..sort((a, b) => a.compareTo(b)))
                      .map(
                        (e) => ListTile(
                          title: Text(e),
                          trailing: IconButton(
                            icon: const Icon(Icons.cancel),
                            onPressed: () => setState(() {
                              topics.remove(e);
                              widget.onType(topics.toList(), controller.text);
                            }),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: widget.showBack
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.end,
                  children: [
                    if (widget.showBack)
                      IconButton(
                        onPressed: () {
                          WidgetsBinding.instance.focusManager.primaryFocus
                              ?.unfocus();
                          widget.onPrev();
                        },
                        icon: const Icon(Icons.keyboard_double_arrow_left),
                        iconSize: 20,
                      ),
                    IconButton(
                      onPressed: topics.isEmpty ? null : widget.onNext,
                      icon: const Icon(Icons.check),
                      iconSize: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
