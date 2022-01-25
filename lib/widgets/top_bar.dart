import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {

  const TopBar({Key key, this.valueNotifier}) : super(key: key);

  final ValueNotifier<int> valueNotifier;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: kToolbarHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.arrow_back_outlined),
            Text("Pepperoni Pizza"),
            Container(
              alignment: Alignment.center,
              height: kToolbarHeight * 0.7,
              width: kToolbarHeight * 0.7,
              child: ValueListenableBuilder(
                valueListenable: valueNotifier,
                builder: (BuildContext context, int value, Widget child) {
                  return TopBarPizzaBox(
                    nbOrder: value,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TopBarPizzaBox extends StatefulWidget {
  const TopBarPizzaBox({Key key, this.nbOrder}) : super(key: key);

  final int nbOrder;

  @override
  _TopBarPizzaBoxState createState() => _TopBarPizzaBoxState();
}

class _TopBarPizzaBoxState extends State<TopBarPizzaBox> {
  Tween<double> tween;

  @override
  void initState() {
    tween = Tween<double>(begin: 15, end: 20);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      fit: StackFit.expand,
      children: [
        Image.asset("assets/pizza_box.png"),
        if (widget.nbOrder > 0)
          Align(
            alignment: Alignment.topRight,
            child: TweenAnimationBuilder(
              onEnd: () {
                if (tween.begin == 15.0)
                  setState(() {
                    tween = Tween<double>(begin: tween.end, end: tween.begin);
                  });
              },
              key: UniqueKey(),
              duration: const Duration(milliseconds: 600),
              tween: tween,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: FittedBox(
                  alignment: Alignment.center,
                  child: Text(
                    widget.nbOrder.toString(),
                    style: TextStyle(color: Color(0xffF1F1F1)),
                  ),
                  fit: BoxFit.scaleDown,
                ),
              ),
              curve: Curves.decelerate,
              builder: (BuildContext context, double value, Widget child) {
                return Container(
                  alignment: Alignment.center,
                  child: child,
                  width: value,
                  height: value,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffF1F1F1)),
                      color: Color(0xff9E1208),
                      shape: BoxShape.circle),
                );
              },
              
            ),

          )
          
      ],

    );

  }

}
