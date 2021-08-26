import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class IngredientQuatitySelector extends StatefulWidget {
  const IngredientQuatitySelector(
      {Key key, this.animation, this.onQChanged, this.canSlide})
      : super(key: key);

  final Animation<double> animation;
  final Function onQChanged;
  final ValueNotifier<bool> canSlide;

  @override
  _IngredientQuatitySelectorState createState() =>
      _IngredientQuatitySelectorState();
}

class _IngredientQuatitySelectorState extends State<IngredientQuatitySelector> {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.center,
      widthFactor: 0.8,
      child: Container(
        child: CustomSlider(
            canSlide: widget.canSlide,
            sliderColor: Colors.black12,
            selectedPartColor: Color(0xff9E1208),
            animation: widget.animation,
            onPosChange: widget.onQChanged),
      ),
    );
  }
}

class CustomSlider extends LeafRenderObjectWidget {
  const CustomSlider(
      {this.canSlide,
      Key key,
      @required this.sliderColor,
      @required this.selectedPartColor,
      this.animation,
      this.onPosChange})
      : super(key: key);

  final Color sliderColor;
  final Color selectedPartColor;
  final Function onPosChange;
  final Animation animation;
  final ValueNotifier<bool> canSlide;

  @override
  RenderCustomSlider createRenderObject(BuildContext context) {
    return RenderCustomSlider(
        sliderColor: sliderColor,
        selectedPartColor: selectedPartColor,
        onPChange: onPosChange,
        canSlide: canSlide,
        animation: animation);
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderCustomSlider renderObject) {
    renderObject
      ..sliderColor = sliderColor
      ..selectedPartColor = selectedPartColor
      ..onPchange = onPosChange
      ..canslide = canSlide
      ..animation = animation;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('sliderColor', sliderColor));
    properties.add(ColorProperty('selectedPartColor', selectedPartColor));
  }
}

class RenderCustomSlider extends RenderBox {
  RenderCustomSlider(
      {@required Color sliderColor,
      @required Color selectedPartColor,
      @required Function onPChange,
      ValueNotifier<bool> canSlide,
      Animation<double> animation})
      : _sliderColor = sliderColor,
        _selectedPartColor = selectedPartColor,
        _onPChange = onPChange,
        _canSlide = canSlide,
        _animation = animation {
    // initialize the gesture recognizer
    _pan = PanGestureRecognizer()
      ..onStart = (DragStartDetails details) {
        _updateThumbPosition(details.localPosition);
      }
      ..onEnd = (_) {
        onPChange(q);
      }
      ..onUpdate = (DragUpdateDetails details) {
        _updateThumbPosition(details.localPosition);
      };
  }

  void _updateThumbPosition(Offset localPosition) {
    var dx = localPosition.dx.clamp(0, size.width);
    q = dx / size.width;
    l0 = (_startPoint * (1 - q) + _controlPoint * q);
    l1 = (_controlPoint * (1 - q) + _endPoint * q);
    q0 = l0 * (1 - q) + l1 * q;
    markNeedsPaint();
  }

  Color get sliderColor => _sliderColor;
  Color _sliderColor;
  set sliderColor(Color value) {
    if (_sliderColor == value) return;
    _sliderColor = value;
    markNeedsPaint();
  }

  Animation get animation => _animation;

  Animation _animation;

  set animation(Animation value) {
    if (_animation == value) return;
    _animation = value;
  }

  Color get selectedPartColor => _selectedPartColor;
  Color _selectedPartColor;
  set selectedPartColor(Color value) {
    if (_selectedPartColor == value) return;
    _selectedPartColor = value;
    markNeedsPaint();
  }

  ValueNotifier get canslide => _canSlide;
  ValueNotifier _canSlide;
  set canslide(ValueNotifier value) {
    if (_canSlide == value) return;
    _canSlide = value;
    markNeedsPaint();
  }

  Function get onPChange => _onPChange;
  Function _onPChange;

  set onPchange(Function value) {
    if (_onPChange == value) return;
    _onPChange = value;
  }

  @override
  double computeMinIntrinsicWidth(double height) => size.width;

  @override
  double computeMaxIntrinsicWidth(double height) => size.width;

  @override
  double computeMinIntrinsicHeight(double width) => size.height;

  @override
  double computeMaxIntrinsicHeight(double width) => size.height;

  PanGestureRecognizer _pan;

  @override
  bool hitTestSelf(Offset position) {
    final x1 = q0.dx - 9;
    final x2 = q0.dx + 9;
    final y1 = q0.dy - 9;
    final y2 = q0.dy + 9;

    if (position.dx >= x1 &&
        position.dx <= x2 &&
        position.dy >= y1 &&
        position.dy <= y2 &&
        canslide.value) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry));
    if (event is PointerDownEvent) {
      _pan.addPointer(event);
    }
  }

  @override
  void performLayout() {
    size = computeDryLayout(constraints);
    _startPoint = Offset(0, size.height / 1.5);
    _endPoint = Offset(size.width, size.height / 1.5);
    _controlPoint = Offset(size.width / 2, 0);
    l0 = (_startPoint * (1 - q) + _controlPoint * q);
    l1 = (_controlPoint * (1 - q) + _endPoint * q);
    q0 = l0 * (1 - q) + l1 * q;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final desiredWidth = constraints.maxWidth;
    final desiredHeight = constraints.maxHeight;
    final desiredSize = Size(desiredWidth, desiredHeight);
    return constraints.constrain(desiredSize);
  }

  double q = 0.0;
  Offset _startPoint;
  Offset _endPoint;
  Offset l0;
  Offset l1;
  Offset q0;
  Offset _controlPoint;
  ui.Image image;

  @override
  void attach(covariant PipelineOwner owner) {
    getImage().then((value) {
      image = value;
      markNeedsPaint();
    });
    animation?.addListener(() => _onanimationValueChanged());
    super.attach(owner);
  }

  @override
  void detach() {
    animation?.removeListener(() => _onanimationValueChanged());
    super.detach();
  }

  void _onanimationValueChanged() {
    q = animation.value;
    l0 = (_startPoint * (1 - q) + _controlPoint * q);
    l1 = (_controlPoint * (1 - q) + _endPoint * q);
    q0 = l0 * (1 - q) + l1 * q;
    markNeedsPaint();
  }

  Future<ui.Image> getImage() async {
    final data = await rootBundle.load("assets/pizza_thumb.png");
    final bytes = data.buffer.asUint8List();
    final image = await decodeImageFromList(bytes);
    return image;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;

    canvas.save();
    canvas.translate(offset.dx, offset.dy);

    final path = Path()
      ..moveTo(_startPoint.dx, _startPoint.dy)
      ..quadraticBezierTo(l0.dx, l0.dy, q0.dx, q0.dy);

    final path2 = Path()
      ..moveTo(_startPoint.dx, _startPoint.dy)
      ..quadraticBezierTo(
          _controlPoint.dx, _controlPoint.dy, _endPoint.dx, _endPoint.dy);

    canvas.drawPath(
        path2,
        Paint()
          ..color = sliderColor
          ..strokeWidth = 10
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke);

    canvas.drawPath(
        path,
        Paint()
          ..color = selectedPartColor
          ..strokeWidth = 10
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke);

    canvas.drawCircle(q0, 18, Paint()..color = selectedPartColor);

    if (image != null)
      paintImage(
          canvas: canvas,
          alignment: Alignment.center,
          fit: BoxFit.cover,
          rect: Rect.fromCenter(center: q0, width: 30, height: 30),
          image: image);

    canvas.restore();
  }

  @override
  bool get isRepaintBoundary => true;
}
