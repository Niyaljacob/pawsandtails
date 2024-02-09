import 'package:flutter/material.dart';
import 'package:paws_and_tail/screens/add_dog_show.dart';
import 'package:paws_and_tail/screens/dogshowlist.dart';

class AddViewDogShows extends StatelessWidget {
  const AddViewDogShows({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add & View dog Show Events'),
        backgroundColor: const Color.fromARGB(255, 96, 182, 252),
      ),
      body:  Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_){
                  return const AddDogShow();
                }));
              },
              child: const SizedBox(
                height: 100,
                child: Card(
                  child: Center(child: Text('Add Dog Shows',style: TextStyle(fontSize: 18.0),)),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_){
                  return const DogShowList();
                }));
              },
              child: const SizedBox(
                height: 100,
                child: Card(
                  child: Center(child: Text('View Add Dog Shows',style: TextStyle(fontSize: 18.0),)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}