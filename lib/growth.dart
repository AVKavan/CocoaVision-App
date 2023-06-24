import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Growth extends StatefulWidget {
  const Growth({Key? key}) : super(key: key);

  @override
  State<Growth> createState() => _GrowthState();
}

class _GrowthState extends State<Growth> {
  String data = 'Error';

  fetchData() async {
    String response = '';
    response =
        await rootBundle.loadString('assets/recommendation_text/growth.txt');
    setState(() {
      data = response;
      print(data);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    // getWeb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Cocoa Growth Requirements'),
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/cocoa_bg2.jpg'),
                  fit: BoxFit.cover,
                  opacity: 0.1)),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  scrollDirection: Axis.vertical,
                  child: Text(
                    data,
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
