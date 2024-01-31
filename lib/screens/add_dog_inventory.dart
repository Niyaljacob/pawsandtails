import 'package:flutter/material.dart';
import 'package:paws_and_tail/screens/List_of_dogs.dart';
import 'package:paws_and_tail/screens/add_dogs.dart';

class AddDogInventory extends StatelessWidget {
  const AddDogInventory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor: Color.fromARGB(255, 96, 182, 252),
        title: Text('Add Dogs Inventory'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_){
                return AddDogs(); 
              }));
            },
            child: Card(
              elevation: 4.0,
              child: Container(
                height: 100.0,
                alignment: Alignment.center,
                child: Text(
                  'Add Dogs',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          InkWell(
            onTap: () {
               Navigator.of(context).push(MaterialPageRoute(builder: (_){
                return ListOfDogs(); 
              }));
            },
            child: Card(
              elevation: 4.0,
              child: Container(
                height: 100.0,
                alignment: Alignment.center,
                child: Text(
                  'List Of Dogs',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}