import 'dart:developer';
import 'dart:math' hide log;

import 'package:pizza_order_flutter/data/ingredient_model.dart';
import 'package:flutter/material.dart';

class IngredientsView extends StatefulWidget {
  const IngredientsView(
      {Key key,
      this.size,
      this.animationController,
      this.ingredientsAddRequestNotifier,
      this.canSlide})
      : super(key: key);

  final Size size;
  final ValueNotifier<bool> canSlide;
  final AnimationController animationController;
  final ValueNotifier<Map<String, dynamic>> ingredientsAddRequestNotifier;

  @override
  _IngredientsViewState createState() => _IngredientsViewState();
}

class _IngredientsViewState extends State<IngredientsView> {
  
  List<List<Offset>> offsets;

  List<Animation> animation = <Animation<Offset>>[];

  List<List<Widget>> _widgets = [...List.generate(5, (index) => [])];

  List<Widget> currentWidgets = [];

  int currentIngredientindex = 5;
  int oldIngredientindex;

  List<int> startQ = List.generate(5, (index) => 0);
  List<int> endQ = List.generate(5, (index) => 0);

  int get start => startQ[currentIngredientindex];
  int get end => endQ[currentIngredientindex];
  set start(int value) => startQ[currentIngredientindex] = value;
  set end(int value) => endQ[currentIngredientindex] = value;

  List<int> oldQuantity = List.generate(5, (index) => 0);
  List<int> newQuantity = List.generate(5, (index) => 0);

  int get oldQ => oldQuantity[currentIngredientindex];
  int get newQ => newQuantity[currentIngredientindex];
  set oldQ(int value) => oldQuantity[currentIngredientindex] = value;
  set newQ(int value) => newQuantity[currentIngredientindex] = value;

  void _initAnimations() {
    canSlide = false;

    if (oldIngredientindex != currentIngredientindex) {
      animation.clear();
      offsets[currentIngredientindex].forEach((element) {
        animation.add(CurvedAnimation(
                parent: widget.animationController, curve: Curves.decelerate)
            .drive(Tween<Offset>(begin: (element * 5), end: element)));
      });
    }
    return;
  }

  double get animationValue => widget.animationController.value;
  set animationValue(double value) => widget.animationController.value = value;

//!  will got called in buildIngredient method
  List<Widget> _getCurrentWidget() {
    return [
      for (int i = start; i < end; i++)
        Opacity(
          opacity: (animationValue * 2).clamp(0.0, 1.0),
          child: Transform.translate(
            offset: animation[i].value,
            child: Image.asset(
                MyData.ingradients[currentIngredientindex].imagePath),
          ),
        )
    ];
  }

  int get requestedQ =>
      (widget.ingredientsAddRequestNotifier.value["q"] * 10).ceil();
  int get requestedIndex => widget.ingredientsAddRequestNotifier.value["index"];
  bool get forward => newQ > oldQ;
  bool get reverse => oldQ > newQ;

  set canSlide(bool v) => widget.canSlide.value = v;

  @override
  void initState() {
    _initLastIngredientsOffsets(widget.size);

    widget.ingredientsAddRequestNotifier
        .addListener(() => _onIngredientRequest());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      height: widget.size.height,
      width: widget.size.width,
      alignment: Alignment.center,
      child: AnimatedBuilder(
          animation: widget.animationController,
          builder: (BuildContext context, Widget child) => _buildIngredients()),
    );

  }

  void _onIngredientRequest() {

    oldIngredientindex = currentIngredientindex;

    currentIngredientindex = requestedIndex;

    oldQ = newQ;
    newQ = requestedQ;

    start = min(oldQ, newQ);
    end = max(oldQ, newQ);

    if (forward) {
      _initAnimations();

      animationValue = 0.0;

      log(start.toString());
      log(end.toString());

      widget.animationController.forward().then((_) {
        _widgets[currentIngredientindex].addAll(currentWidgets);
        canSlide = true;
      });
    } else if (reverse) {
      _initAnimations();

      log(start.toString());
      log(end.toString());

      _widgets[currentIngredientindex].removeRange(start, end);

      animationValue = 1.0;

      widget.animationController.reverse().then((value) {
        canSlide = true;
      });
    }
    return;
  }

  Widget _buildIngredients() {
    if (animation.isNotEmpty) {
      if (widget.animationController.isAnimating) {
        currentWidgets = _getCurrentWidget();

        return Stack(children: [
          for (int i = 0; i < _widgets.length; i++) ..._widgets[i],
          ...currentWidgets
        ]);
      }

      return Stack(
          children: [for (int i = 0; i < _widgets.length; i++) ..._widgets[i]]);
    } else {
      return const SizedBox();
    }
  }

  void _initLastIngredientsOffsets(Size _biggestSize) {
    offsets = List.generate(MyData.ingradients.length, (index) {
      return List.generate(10, (index) {
        final rd = Random.secure().nextBool();
        final rd2 = Random.secure().nextBool();
        final dxFactorRandom = Random.secure().nextDouble();

        final dx = rd
            ? (_biggestSize.width / 3.2 * dxFactorRandom)
            : -(_biggestSize.width / 3.2 * dxFactorRandom);

        final dyFactorRandom = Random.secure().nextDouble();

        final dy = rd2
            ? (_biggestSize.height / 3.2 * dyFactorRandom)
            : -(_biggestSize.height / 3.2 * dyFactorRandom);

        return Offset(dx, dy);
      });
    });
  }
}
