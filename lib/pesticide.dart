import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class Pesticide extends StatefulWidget {
  const Pesticide({Key? key}) : super(key: key);

  @override
  State<Pesticide> createState() => _PesticideState();
}

class _PesticideState extends State<Pesticide> {
  @override
  Widget build(BuildContext context) {
    final disease = ModalRoute.of(context)!.settings.arguments;
    String disease_name = disease.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text('Cocoa Classifier'),
      ),
      body: Column(
        children: [RecommendText(disease_name: disease_name)],
      ),
    );
  }
}

class RecommendText extends StatefulWidget {
  late final String disease_name;
  RecommendText({required this.disease_name});

  @override
  State<RecommendText> createState() =>
      _RecommendTextState(disease_name: disease_name);
}

class _RecommendTextState extends State<RecommendText> {
  String data = 'No known disease found';
  late final String disease_name;
  _RecommendTextState({required this.disease_name});

  @override
  void initState() {
    fetchData(disease_name);
  }

  fetchData(String disease) async {
    String response = '';
    response = await rootBundle
        .loadString('assets/recommendation_text/' + disease + '.txt');

    setState(() {
      data = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        scrollDirection: Axis.vertical,
        child: Text(
          data,
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
    );
  }
}
