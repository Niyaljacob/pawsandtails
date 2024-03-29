import 'package:flutter/material.dart';
import 'package:paws_and_tail/screens/dog_accepte.dart';
import 'package:paws_and_tail/screens/dog_decline.dart';
import 'package:paws_and_tail/screens/dog_oders.dart';

class DogSales extends StatelessWidget {
  const DogSales({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 96, 182, 252),
          title: const Text('Dog Sales'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Orders'),
              Tab(text: 'Accepts'),
              Tab(text: 'Decline'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            DogOrders(),
            DogAcceptes(),
            DogDecline(),
          ],
        ),
      ),
    );
  }
}