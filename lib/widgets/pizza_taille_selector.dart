import 'dart:developer';
import 'package:flutter/material.dart';

import 'pizza_taille_selector_foreground_painter.dart';

class PizzaTailleSelector extends StatefulWidget {
  const PizzaTailleSelector({Key key, this.onTailleChanged}) : super(key: key);

  final Function onTailleChanged;

  static const _tailles = ["M", "S", "L"];

  @override
  _PizzaTailleSelectorState createState() => _PizzaTailleSelectorState();
}

class _PizzaTailleSelectorState extends State<PizzaTailleSelector> {
  
  bool canChange = true;

  ValueNotifier<int> selectedTailleNotifier;

  ScrollController scrollController;

  @override
  void initState() {
    selectedTailleNotifier = ValueNotifier<int>(0);
    scrollController = ScrollController(initialScrollOffset: 0.0);
    super.initState();
  }

  @override
  void dispose() {
    selectedTailleNotifier?.dispose();
    scrollController?.dispose();
    super.dispose();
  }

  void _animateListTo(double offset) async {
    canChange = false;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController
          .animateTo(offset,
              duration: Duration(milliseconds: 600), curve: Curves.decelerate)
          .then((value) => canChange = true);
    });
  }

  int getSelectedTailleIndex(double offset, double itemExtent) {

    final int r = offset ~/ itemExtent;
    final int index = (r % 3);

    return index;
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        foregroundPainter: const PTailleSelectorForeGroundPainter(),
        isComplex: false,
        willChange: false,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Stack(
              children: [
                RotatedBox(
                  quarterTurns: 1,
                  child: ListWheelScrollView.useDelegate(
                    controller: scrollController,
                    physics: const NeverScrollableScrollPhysics(),
                    childDelegate: ListWheelChildLoopingListDelegate(
                      children: [
                        ...List.generate(
                          3,
                          (index) => RotatedBox(
                            quarterTurns: 3,
                            child: Center(
                                child: ValueListenableBuilder(
                              valueListenable: selectedTailleNotifier,
                              builder: (BuildContext context, int value,
                                  Widget child) {
                                return Text(
                                    "${PizzaTailleSelector._tailles[index]}",
                                    style: TextStyle(
                                        fontSize: 30.0,
                                        color: Color(index == value
                                            ? 0xff9E1208
                                            : 0xff1B1D0A)));
                              },
                            )),
                          ),
                        )
                      ],
                    ),
                    itemExtent: constraints.maxWidth / 2.9,
                    offAxisFraction: -3.5,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ...List.generate(
                        3,
                        (index) => GestureDetector(
                              onTap: () async {
                                if (canChange) {
                                  double newPos;
                                  if (index == 2) {
                                    newPos = scrollController.offset -
                                        (constraints.maxWidth / 2.9);
                                    _animateListTo(newPos);
                                  } else if (index == 0) {
                                    newPos = scrollController.offset +
                                        (constraints.maxWidth / 2.9);
                                    _animateListTo(newPos);
                                  } else
                                    return;

                                  int newIndex = getSelectedTailleIndex(
                                      newPos, constraints.maxWidth / 2.9);

                                  // invoke on Taille Changed
                                  widget.onTailleChanged(newIndex);

                                  selectedTailleNotifier.value = newIndex;
                                }
                              },
                              child: Container(
                                width: (constraints.maxWidth / 3.5),
                                height: constraints.maxHeight,
                                color: Colors.transparent,
                              ),
                            ))
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
