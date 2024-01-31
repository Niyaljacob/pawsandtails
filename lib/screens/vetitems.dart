import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paws_and_tail/common/color_extention.dart';
import 'package:paws_and_tail/screens/bottom_nav.dart';

class VetItemsScreen extends StatelessWidget {
  const VetItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(backgroundColor: TColo.primaryColor1,
         leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('VetItems'),
      ),
    );
  }
}