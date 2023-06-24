import 'dart:io';
import 'package:cocoa_classifier/pesticide.dart';
import 'package:cocoa_classifier/rounded_button.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class TfLiteModel extends StatefulWidget {
  const TfLiteModel({Key? key}) : super(key: key);

  @override
  State<TfLiteModel> createState() => _TfLiteModelState();
}

class _TfLiteModelState extends State<TfLiteModel> {
  late File _image;
  late List _result;
  bool imageSelect = false;

  @override
  void initState() {
    loadmodel();
  }

  Future loadmodel() async {
    Tflite.close();
    String res;
    res = (await Tflite.loadModel(
        model: "assets/effnet_model.tflite", labels: "assets/labels.txt"))!;
    print("Model loading status: {$res}");
  }

  Future imageClassification(File image) async {
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    setState(() {
      _result = recognitions!;
      _image = image;
      imageSelect = true;
      print(recognitions);
    });
  }

  bool displaybtn = false;
  String disease = 'none';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cocoa Classifier'),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/cocoa_bg2.jpg'),
                fit: BoxFit.cover,
                opacity: 0.4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            (imageSelect)
                ? Container(
                    margin: const EdgeInsets.all(10),
                    child: Image.file(_image),
                    height: 400,
                    width: 500,
                  )
                : Container(
                    margin: const EdgeInsets.all(10),
                    child: const Opacity(
                      opacity: 0.8,
                      child: Center(
                        child: Text("No image selected"),
                      ),
                    ),
                  ),
            SingleChildScrollView(
              child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: (imageSelect)
                            ? _result.take(1).map((result) {
                                disease = result['label'];
                                displaybtn = true;
                                return Card(
                                  color: Colors.white60,
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    child: Text(
                                      result['label'] == "Healthy"
                                          ? "Healthy"
                                          : "${result['label']} disease detected",
                                      style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                );
                              }).toList()
                            : []),
                    if (displaybtn)
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/pesticide_screen',
                              arguments: disease);
                        },
                        child: Text(
                          'Click for Solution',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(10),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.indigo),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 15)),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      )
                  ]),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: RoundedButton(
                  title: 'Click Image',
                  onpressed: clickImage,
                  icons: Icons.camera_alt,
                ))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: RoundedButton(
                  title: 'Choose from gallery',
                  onpressed: PickImage,
                  icons: Icons.image,
                ))
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future PickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    File image = File(pickedFile!.path);

    imageClassification(image);
  }

  Future clickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );
    File image = File(pickedFile!.path);
    imageClassification(image);
  }
}
