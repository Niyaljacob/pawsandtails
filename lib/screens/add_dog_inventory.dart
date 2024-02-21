import 'package:flutter/material.dart';
import 'package:paws_and_tail/screens/List_of_dogs.dart';
import 'package:paws_and_tail/screens/add_dogs.dart';

class AddDogInventory extends StatelessWidget {
  const AddDogInventory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 96, 182, 252),
          title: const Text('Add Dogs Inventory'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Add Dogs'),
              Tab(text: 'List Of Dogs'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AddDogs(),
            ListOfDogs(),
          ],
        ),
      ),
    );
  }
}
