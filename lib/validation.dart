import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class Validation extends StatefulWidget {
  @override
  _ValidationState createState() => _ValidationState();
}

class _ValidationState extends State<Validation> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  String? _prediction;

  Future<void> classifyImage(File imageFile) async {
    final apiUrl = Uri.parse('https://api.plant.id/v2/identify');

    // Read the image file as bytes
    List<int> imageBytes = await imageFile.readAsBytes();

    // Create the multipart request body
    var request = http.MultipartRequest('POST', apiUrl);
    // request.fields['organs'] = 'leaf';
    request.files.add(http.MultipartFile.fromBytes('images', imageBytes));

    // Add the API key to the request headers
    request.headers['Api-Key'] =
        'LdLQLp2NQ1dt8JHyTu4Msikj1GW8Ldod8xelcAN1gMrC5HDtbf';
    request.headers['Content-Type'] = 'application/json';

    try {
      // Send the API request
      final response = await request.send();

      if (response.statusCode == 200) {
        // Parse the response JSON
        final responseJson = await response.stream.bytesToString();
        final decodedJson = jsonDecode(responseJson);

        // Get the first prediction
        final prediction = decodedJson['suggestions'][0]['plant_name'];

        setState(() {
          _prediction = prediction;
        });
      } else {
        // Handle API error
        print('API Error: ${response.statusCode}');
        print(response.reasonPhrase);
      }
    } catch (e) {
      // Handle network or other errors
      print('Error: $e');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.getImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _prediction = null;
      });

      classifyImage(_selectedImage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Leaf Identifier')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _selectedImage != null
                ? Image.file(_selectedImage!)
                : Text('No image selected'),
            SizedBox(height: 16.0),
            _prediction != null
                ? Text('Prediction: $_prediction')
                : Container(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Select Image Source'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      GestureDetector(
                        child: Text('Gallery'),
                        onTap: () {
                          _pickImage(ImageSource.gallery);
                          Navigator.of(context).pop();
                        },
                      ),
                      Padding(padding: EdgeInsets.all(8.0)),
                      GestureDetector(
                        child: Text('Camera'),
                        onTap: () {
                          _pickImage(ImageSource.camera);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
