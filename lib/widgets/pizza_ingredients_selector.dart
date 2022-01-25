import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:pizza_order_flutter/data/ingredient_model.dart';

import 'pizza_ingredients_foreground_painter.dart';

class PizzaIngredientSelector extends StatefulWidget {
  final Function onChange;
  final ValueNotifier<double> currentQNotifier;

  const PizzaIngredientSelector({Key key, this.onChange, this.currentQNotifier})
      : super(key: key);

  @override
  _PizzaIngredientSelectorState createState() =>
      _PizzaIngredientSelectorState();
}

class _PizzaIngredientSelectorState extends State<PizzaIngredientSelector> {
  bool canChange = true;

  ScrollController scrollController;
  int selectedIngredientIndex = 0;
  List<double> _quantities;

  @override
  void initState() {
    _quantities = List.generate(5, (index) => 0.0);
    scrollController = ScrollController(initialScrollOffset: 0.0);
    widget.currentQNotifier.addListener(() {
      _quantities[selectedIngredientIndex] = widget.currentQNotifier.value;
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController?.dispose();
    super.dispose();
  }

  void _animateListTo(double offset) async {
    canChange = false;
    scrollController
        .animateTo(offset,
            duration: Duration(milliseconds: 600), curve: Curves.decelerate)
        .then((value) => canChange = true);
  }

  int getSelectedIngredientIndex(double offset, double itemExtent) {
    final int r = offset ~/ itemExtent;

    //final int index = ((4 - (r % 5)) + 1) % 5;
    final int index = r % 5;

    return index;
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        foregroundPainter: const PIngredientSelectorForeGroundPainter(),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Stack(
              children: [
                RotatedBox(
                  quarterTurns: 1,
                  child: ListWheelScrollView.useDelegate(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: scrollController,
                    childDelegate: ListWheelChildLoopingListDelegate(
                      children: [
                        ...List.generate(
                            MyData.ingradients.length,
                            (index) => RotatedBox(
                                  quarterTurns: 3,
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    child: Image.asset(
                                        MyData.ingradients[index].imagePath),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: MyData.ingradients[index].color
                                            .withOpacity(0.3)),
                                  ),
                                ))
                      ],
                    ),
                    itemExtent: constraints.maxWidth / 3.2,
                    offAxisFraction: -2,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ...List.generate(
                        3,
                        (index) => GestureDetector(
                              onTap: () async {
                                if (canChange) {
                                  double newPos;
                                  if (index == 2) {
                                    newPos = scrollController.offset -
                                        (constraints.maxWidth / 3.2);
                                    _animateListTo(newPos);
                                  } else if (index == 0) {
                                    newPos = scrollController.offset +
                                        (constraints.maxWidth / 3.2);
                                    _animateListTo(newPos);
                                  } else
                                    return;

                                  int newIndex = getSelectedIngredientIndex(
                                      newPos, constraints.maxWidth / 3.2);

                                  widget.onChange(
                                      _quantities[selectedIngredientIndex],
                                      _quantities[newIndex],
                                      newIndex);

                                  selectedIngredientIndex = newIndex;

                                  log("INDEX:$newIndex");
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
