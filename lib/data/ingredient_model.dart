import 'package:flutter/rendering.dart';

class MyIngredient{
  
  final String imagePath;
  final Color color;

  const MyIngredient({this.color, this.imagePath});

}


class MyData{

  static const Size pizzaSize = Size(200.0,200.0);

  static const List<MyIngredient> ingradients = [
    MyIngredient(
        imagePath: "assets/ingredient_1.png",
        color: const Color(0xffD89B3C)),
    MyIngredient(
        imagePath: "assets/ingredient_2.png",
        color: const Color(0xff19E1208)),
    MyIngredient(
        imagePath: "assets/ingredient_3.png",
        color: const Color(0xff1688E35)),
    MyIngredient(
        imagePath: "assets/ingredient_4.png",
        color: const Color(0xff1688E35)),
    MyIngredient(
        imagePath: "assets/ingredient_5.png",
        color: const Color(0xff1B1D0A)),
  ];

}