import 'dart:math';
import 'package:flutter/material.dart';

class ButtomButtons extends StatelessWidget {
  const ButtomButtons({
    Key key,
    this.onPlusPressed,
    this.animation,
  }) : super(key: key);

  final Function onPlusPressed;
  final Animation animation;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: FittedBox(
        alignment: Alignment.center,
        fit: BoxFit.scaleDown,
        child: AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, Widget child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: onPlusPressed,
                  child: Container(
                    width: (((120.0 * animation.value * 2) + 60.0))
                        .clamp(60.0, 180)
                        .toDouble(),
                    height: 60,
                    decoration: BoxDecoration(
                        color: Color(0xff9E1208),
                        borderRadius: BorderRadius.circular(
                            animation.status == AnimationStatus.forward
                                ? ((20 * (1 - animation.value) * 2) + 30)
                                    .clamp(30.0, 50)
                                    .toDouble()
                                : 30)),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Opacity(
                          opacity: (animation.value) > 0.35
                              ? 0.0
                              : 1 - animation.value,
                          child: Transform.rotate(
                            alignment: Alignment.center,
                            origin: Offset.zero,
                            angle: 2 * pi * animation.value,
                            child: Icon(
                              Icons.add,
                              size: 35,
                              color: Color(0xffF1F1F1),
                            ),
                          ),
                        ),
                        Opacity(
                          opacity: animation.value > 0.4
                              ? (animation.value * 2).clamp(0, 1).toDouble()
                              : 0.0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FittedBox(
                              alignment: Alignment.center,
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "Continue",
                                style: TextStyle(
                                    fontSize: 28,
                                    color: Color(0xffF1F1F1),
                                    letterSpacing: 1.0),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                if (animation.value >= 0.8)
                  Container(
                      height: 60.0,
                      alignment: Alignment.center,
                      child: Opacity(
                        opacity: animation.value,
                        child: FittedBox(
                          alignment: Alignment.center,
                          fit: BoxFit.scaleDown,
                          child: Text("Repeat ?",
                              style: TextStyle(
                                  fontSize: 28,
                                  color: Color(0xff9E1208),
                                  letterSpacing: 1.0)),
                        ),
                      ),
                      width: ((120.0 * (animation.value) + 60.0)))
              ],
            );
          },
        ),
      ),
    );
  }
}
