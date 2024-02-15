import 'package:flutter/material.dart';
import 'package:paws_and_tail/screens/add_adds.dart';
import 'package:paws_and_tail/screens/add_top_brands.dart';

class Advertisement extends StatelessWidget {
  const Advertisement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 96, 182, 252),
          title: const Text('Advertisement & Top Brands'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Publish Advertisement'),
              Tab(text: 'Add Top Brands'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AddAdds(),
            AddTopBrands(),
          ],
        ),
      ),
    );
  }
}

