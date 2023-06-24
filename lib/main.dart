import 'package:cocoa_classifier/healthBenefits.dart';
import 'package:cocoa_classifier/pesticide.dart';
import 'package:cocoa_classifier/tflite_model.dart';
import 'package:cocoa_classifier/validation.dart';
import 'package:cocoa_classifier/welcome_screen.dart';
import 'package:flutter/material.dart';

import 'growth.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.teal, scaffoldBackgroundColor: Colors.white60),
      routes: {
        '/': (context) => Welcome(),
        '/home_page': (context) => HomePage(),
        '/test_disease': (context) => TfLiteModel(),
        '/pesticide_screen': (context) => Pesticide(),
        '/health_benefits': (context) => HealthBenefits(),
        '/growth': (context) => Growth(),
        '/validate': (context) => Validation()
      },
    );
  }
}
