import 'dart:developer';
import 'dart:math' hide log;
import 'package:flutter/material.dart';
import 'package:pizza_order_flutter/data/ingredientModel.dart';

const double SCALEFACTOR = 0.15;

class PizzaView extends StatefulWidget {
  PizzaView({
    Key key,
    this.animation,
    this.isATailleChangingNotifier,
    this.ingredientWidget,
  }) : super(key: key);

  final Animation<double> animation;
  final Widget ingredientWidget;
  final ValueNotifier<int> isATailleChangingNotifier;

  @override
  _PizzaViewState createState() => _PizzaViewState();
}

class _PizzaViewState extends State<PizzaView> {
  final GlobalKey gkey = GlobalKey();

  Offset _pizzaAfterOrderOffset;

/*1 MEDIUM
2 SMALL
3 LARGE*/

  double _pizzaTailleScaleFactor = 1.0;

  bool _isATailleChanging = false;

  Size _pizzaSize;

  Image image;

  @override
  void initState() {
    super.initState();

    image = Image.asset(
      "assets/initial_pizza.png",
      height: MyData.pizzaSize.height,
      width: MyData.pizzaSize.width,
    );

    widget.isATailleChangingNotifier.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _isATailleChanging = widget.isATailleChangingNotifier.value != null;
        if (_isATailleChanging) {
          _pizzaTailleScaleFactor =
              getScaleFactor(widget.isATailleChangingNotifier.value);
        }
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _calculatepizzaOffset();
    });

  }

  void _calculatepizzaOffset() {
    
    final c = gkey.currentContext;

    _pizzaSize = c.size;

    _pizzaAfterOrderOffset = (c.findRenderObject() as RenderBox)
        .localToGlobal(Offset((_pizzaSize.width * (1 - SCALEFACTOR)) / 2,
            _pizzaSize.height * (1 - SCALEFACTOR) / 2))
        .translate(-15.0, -15.0);
  }

  double getScaleFactor(int t) {
    switch (t) {
      case 0:
        return 1.0;
        break;
      case 1:
        return 0.8;
        break;
      default:
        return 1.2;
    }
  }

  @override
  Widget build(BuildContext context) {
    log("PIZZZA VIEW BUILDED");


    return FractionallySizedBox(
      alignment: Alignment.center,
      heightFactor: 0.7,
      widthFactor: 0.7,
      child: AnimatedBuilder(
        animation: widget.animation,
        child: Container(
          key: gkey,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: image.image,
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                  scale: 1.0)),
          child: widget.ingredientWidget,
        ),
        builder: (BuildContext context, Widget child) {
          final double animationValue = widget.animation.value;
          final double scaleValue = _isATailleChanging
              ? _pizzaTailleScaleFactor
              : ((1 - animationValue) * _pizzaTailleScaleFactor)
                  .clamp(SCALEFACTOR, _pizzaTailleScaleFactor);

          return Opacity(
            opacity: _isATailleChanging ? 1 : 1 - animationValue,
            child: Transform(
                alignment: Alignment.center,
                origin: Offset.zero,
                child: child,
                transform: Matrix4.identity()
                  ..translate(
                      _isATailleChanging ||
                              widget.animation.status == AnimationStatus.reverse
                          ? 0.0
                          : animationValue * (_pizzaAfterOrderOffset?.dx ?? 0),
                      _isATailleChanging ||
                              widget.animation.status == AnimationStatus.reverse
                          ? 0.0
                          : -animationValue * (_pizzaAfterOrderOffset?.dy ?? 0))
                  ..scale(
                    scaleValue,
                  )
                  ..rotateZ(2 * pi * animationValue)),
          );
        },
      ),
    );
  }
}
