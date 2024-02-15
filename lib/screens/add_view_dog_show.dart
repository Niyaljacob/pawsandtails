import 'package:flutter/material.dart';
import 'package:paws_and_tail/screens/add_dog_show.dart';
import 'package:paws_and_tail/screens/dogshowlist.dart';

class AddViewDogShows extends StatelessWidget {
  const AddViewDogShows({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add & View dog Show Events'),
          backgroundColor: const Color.fromARGB(255, 96, 182, 252),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Add Dog Shows'),
              Tab(text: 'View Dog Shows'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AddDogShow(),
            DogShowList(),
          ],
        ),
      ),
    );
  }
}
