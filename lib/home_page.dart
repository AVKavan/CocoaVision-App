import 'dart:io';
import 'package:cocoa_classifier/pesticide.dart';
import 'package:cocoa_classifier/rounded_button.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cocoa Classifier'),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/cocoa_bg_img.jpg'),
                fit: BoxFit.cover,
                opacity: 0.4)),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: RoundedButton(
                    title: ' Detect Disease',
                    onpressed: () {
                      Navigator.pushNamed(context, '/test_disease');
                    },
                    icons: Icons.arrow_circle_right_sharp,
                  ))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: RoundedButton(
                    title: ' Health Benefits(Cocoa)',
                    onpressed: () {
                      Navigator.pushNamed(context, '/health_benefits');
                    },
                    icons: Icons.arrow_circle_right_sharp,
                  ))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: RoundedButton(
                    title: ' Growth Requirements for Cocoa',
                    onpressed: () {
                      Navigator.pushNamed(context, '/growth');
                    },
                    icons: Icons.arrow_circle_right_sharp,
                  ))
                ],
              ),
            ]),
      ),
    );
  }
}
