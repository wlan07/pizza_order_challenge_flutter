import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pizza_order_flutter/AddPizzaInteraction.dart';

void main() {
    
    WidgetsFlutterBinding.ensureInitialized();

    SystemChrome.setEnabledSystemUIOverlays([]);
  
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pizza Order Concept',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PizzaOrder(),
    );
  }
}

