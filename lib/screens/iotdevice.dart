import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paws_and_tail/screens/home.dart';

class IotDeviceScreen extends StatelessWidget {
  const IotDeviceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
         leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_){
              return HomeScreen();
            }));
          },
        ),
        title: Text('IotDevice'),
      ),
    );
  }
}