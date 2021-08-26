import 'package:flutter/material.dart';
import 'data/ingredientModel.dart';
import 'widgets/ingredientsView.dart';
import 'widgets/pizza_view.dart';
import 'widgets/pizzacontrol.dart';
import 'widgets/topbar.dart';

class PizzaOrder extends StatefulWidget {
  const PizzaOrder({Key key}) : super(key: key);

  @override
  _PizzaOrderState createState() => _PizzaOrderState();
}

class _PizzaOrderState extends State<PizzaOrder>
    with TickerProviderStateMixin, ChangeNotifier {
  
  // define animation controllers ..

  //! for pizza view animations
  AnimationController animationController;

  //! for the slider animations
  AnimationController sliderAnimationController;

  //! for ingredients view animations
  AnimationController ingredientsAnimationController;

  //! for the buttom buttons (ok/continue/repeat?) animations

  AnimationController buttomBAnimationController;

  // define valueNotifiers

  //! PizzaTaille is Just Changed Notifier
  ValueNotifier<int> isChangingTailleNotifier;

  //! Notifier for current selected Ingedient Quantity
  ValueNotifier<double> currentIngredientQNotifier;

  //! notifier for the pizza box on the top right
  ValueNotifier<int> pizzaBoxNotifier;

  //! If Pizza Slider can be Slided
  ValueNotifier<bool> canSlide;

  //! Current ingredient add request Notifier
  ValueNotifier<Map<String, dynamic>> ingredientsAddRequestNotifier;

  int selectedIngredientIndex = 0;

  @override
  void initState() {
    canSlide = ValueNotifier<bool>(true);

    pizzaBoxNotifier = ValueNotifier<int>(0);

    animationController = AnimationController(
        duration: const Duration(milliseconds: 800),
        lowerBound: 0,
        upperBound: 1,
        vsync: this);

    sliderAnimationController = AnimationController(
        duration: const Duration(milliseconds: 600),
        lowerBound: 0,
        upperBound: 1,
        vsync: this);

    ingredientsAnimationController = AnimationController(
        duration: const Duration(seconds: 1, milliseconds: 600),
        lowerBound: 0,
        upperBound: 1,
        vsync: this);

    buttomBAnimationController = AnimationController(
        duration: const Duration(seconds: 1, milliseconds: 400),
        lowerBound: 0,
        upperBound: 1,
        vsync: this);

    isChangingTailleNotifier = ValueNotifier<int>(null);

    currentIngredientQNotifier = ValueNotifier<double>(0.0);

    ingredientsAddRequestNotifier = ValueNotifier<Map<String, dynamic>>(null);

    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    isChangingTailleNotifier?.dispose();
    sliderAnimationController?.dispose();
    currentIngredientQNotifier?.dispose();
    ingredientsAnimationController?.dispose();
    pizzaBoxNotifier?.dispose();
    buttomBAnimationController?.dispose();
    ingredientsAddRequestNotifier?.dispose();
    canSlide?.dispose();

    super.dispose();
  }

  //! on Quantity of current ingredient changed
  void _onQChanged(double v) {
    currentIngredientQNotifier.value = v;
    currentIngredientQNotifier.notifyListeners();
    ingredientsAddRequestNotifier.value = {
      "index": selectedIngredientIndex,
      "q": v
    };
  }

  //! on pizza Taille got changed to (L/M/S)
  void _onTailleChanged(int index) {
    if (!animationController.isAnimating) {
      if (!animationController.isCompleted &&
          isChangingTailleNotifier.value != index + 1) {
        isChangingTailleNotifier.value = index;
        animationController.forward().then((_) {
          isChangingTailleNotifier.value = null;
          animationController.reset();
        });
      }
    }
  }

  //! on current ingredient got changed

  /// - is the last Quantity
  /// -- is the new Quantity
  /// --- is the new Index

  void _onCurrentIngredientChange(_, __, ___) {
    selectedIngredientIndex = ___;
    if (_ > __) {
      sliderAnimationController.value = _;
      sliderAnimationController.animateBack(__,
          duration: Duration(milliseconds: 600), curve: Curves.decelerate);
    } else {
      sliderAnimationController.value = _;
      sliderAnimationController.animateTo(__,
          duration: Duration(milliseconds: 600), curve: Curves.decelerate);
    }
  }

  void _onOrder() {
    if (!animationController.isAnimating &&
        !ingredientsAnimationController.isAnimating) {
      if (buttomBAnimationController.isCompleted) {
        return;
      } else {
        buttomBAnimationController.forward();

        animationController.forward().then((value) {
          pizzaBoxNotifier.value = pizzaBoxNotifier.value + 1;
          animationController.reverse();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xffF1F1F1),
      child: DefaultTextStyle(
          style: TextStyle(
              color: Color(0xff1B1D0A),
              fontSize: 25,
              fontWeight: FontWeight.w900),
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              Align(
                  alignment: Alignment.topCenter,
                  child: TopBar(
                    valueNotifier: pizzaBoxNotifier,
                  )),
              Positioned.fill(
                  top: kToolbarHeight,
                  child: Column(
                    children: [
                      Expanded(
                          flex: 5,
                          child: PizzaView(
                            animation: animationController.view,
                            ingredientWidget: IngredientsView(
                              canSlide: canSlide,
                              size: MyData.pizzaSize,
                              animationController:
                                  ingredientsAnimationController,
                              ingredientsAddRequestNotifier:
                                  ingredientsAddRequestNotifier,
                            ),
                            isATailleChangingNotifier: isChangingTailleNotifier,
                          )),
                      Expanded(
                        flex: 8,
                        child: PizzaControl(
                            canSlide: canSlide,
                            buttonsAnimation: buttomBAnimationController.view,
                            onQChangedNotifier: currentIngredientQNotifier,
                            onQChanged: _onQChanged,
                            slideranimation: sliderAnimationController,
                            onIngredientChange: _onCurrentIngredientChange,
                            onPlusPressed: _onOrder,
                            onTailleChanged: _onTailleChanged),
                      )
                    ],
                  ))
            ],
          )),
    );
  }
}
