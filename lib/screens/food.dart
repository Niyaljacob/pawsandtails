import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paws_and_tail/common/color_extention.dart';
import 'package:paws_and_tail/common/textform_refac.dart';
import 'package:paws_and_tail/screens/home.dart';

class FoodScreen extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();
 FoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: TColo.primaryColor1,
         leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_){
              return HomeScreen();
            }));
          },
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 100),
          child: Text('food'),
        ),
      ),
       body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 45,
                child: SearchTextField(
                  controller: _searchController,
                  labelText: 'Search',
                  hintText: 'Search',
                ),
              ),
            ],
          ),
        ),
       ),
    );
  }
}