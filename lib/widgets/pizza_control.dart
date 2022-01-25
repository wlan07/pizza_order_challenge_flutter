import 'package:flutter/material.dart';
import 'Pizza_controls_clipper.dart';
import 'bottom_buttons.dart';
import 'ingredient_q_selector.dart';
import 'pizza_ingredients_selector.dart';
import 'pizza_taille_selector.dart';

class PizzaControl extends StatelessWidget {

  const PizzaControl(
      
      {
        Key key,
      this.onPlusPressed,
      this.onQChanged,
      this.onQChangedNotifier,
      this.onTailleChanged,
      this.slideranimation,
      this.onIngredientChange,
      this.buttonsAnimation, this.canSlide
      
      })

      : super(key: key);

  final Function onPlusPressed;
  final Function onTailleChanged;
  final Animation<double> buttonsAnimation;
  final Function onIngredientChange;
  final ValueNotifier onQChangedNotifier;
  final Function onQChanged;
  final Animation<double> slideranimation;
  final ValueNotifier<bool> canSlide;

  @override
  Widget build(BuildContext context) {
    return ClipShadowPath(
      clipper: PizzaControlsClipper(),
      shadow:
          Shadow(color: Color(0xff1B1D0A).withOpacity(0.5), blurRadius: 15.0),
      child: Container(
        color: Color(0xffF1F1F1),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: PizzaTailleSelector(
                onTailleChanged: onTailleChanged,
              ),
            ),
            Expanded(
                flex: 15,
                child: ClipShadowPath(
                    clipper: PizzaControlsClipper(),
                    shadow: Shadow(
                        color: Color(0xff1B1D0A).withOpacity(0.5),
                        blurRadius: 15.0),
                    child: Container(
                        color: Color(0xffF1F1F1),
                        child: Column(
                          children: [
                            Expanded(
                                child: PizzaIngredientSelector(
                              onChange: onIngredientChange,
                              currentQNotifier: onQChangedNotifier,
                            )),
                            Expanded(
                                child: IngredientQuatitySelector(
                              animation: slideranimation,
                              onQChanged: onQChanged,
                              canSlide: canSlide,
                            )),
                            ButtomButtons(
                              onPlusPressed: onPlusPressed,
                              animation: buttonsAnimation,
                            )
                          ],
                        )))),
          ],
        ),
      ),
    );
  }
}
