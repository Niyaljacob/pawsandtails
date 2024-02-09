import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:paws_and_tail/common/color_extention.dart';
import 'package:paws_and_tail/common/listview_horizontal.dart';
import 'package:paws_and_tail/common/productcard.dart';
import 'package:paws_and_tail/common/textform_refac.dart';

import 'package:paws_and_tail/screens/events.dart';
import 'package:paws_and_tail/screens/products.dart';
import 'package:paws_and_tail/screens/login.dart';
import 'package:paws_and_tail/screens/user_account.dart';
class HomeScreen extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();
  int _currentIndex = 0;
  final List<Widget> _screens = [
    ProductScreen(),
    DogShowList(),
    
    AccountScreen(),
  ];

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 237, 237, 237),
      appBar: AppBar(
        backgroundColor: TColo.primaryColor1,
        actions: [
          IconButton(
            onPressed: () async {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => LoginScreen(),
                ),
              );
            },
            icon: const Icon(Icons.exit_to_app),
          )
        ],
        title: Padding(
          padding: const EdgeInsets.only(top: 35),
          child: Image.asset('assets/logomini.png'),
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
              const SizedBox(height: 16),
              // Carousel of banners
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('banners').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(color: TColo.gray);
                  }
                  final urls = snapshot.data!.docs.map((doc) => doc['url'] as String).toList();
                  return CarouselSlider(
                    options: CarouselOptions(
                      viewportFraction: 1,
                      height: MediaQuery.of(context).size.height * .35,
                      enableInfiniteScroll: true,
                      autoPlay: true,
                    ),
                    items: urls.map((url) => Image.network(url, fit: BoxFit.contain)).toList(),
                  );
                },
              ),
              HorizontalItemList(
                itemCount: 4,
                getItemText: (index) {
                  switch (index) {
                    case 0:
                      return 'Food';
                    case 1:
                      return 'Vet Items';
                    case 2:
                      return 'Accessories';
                    case 3:
                      return 'IOT Device';
                    default:
                      return '';
                  }
                },
                onTap: (index) {
                  // switch (index) {
                  //   case 0:
                  //     Navigator.of(context).push(MaterialPageRoute(builder: (_) => FoodScreen()));
                  //     break;
                  //   case 1:
                  //     Navigator.of(context).push(MaterialPageRoute(builder: (_) => VetItemsPage()));
                  //     break;
                  //   case 2:
                  //     Navigator.of(context).push(MaterialPageRoute(builder: (_) => AccessoriesPage()));
                  //     break;
                  //   case 3:
                  //     Navigator.of(context).push(MaterialPageRoute(builder: (_) => IOTDevicePage ()));
                  //     break;
                  //   default:
                  //     break;
                  // }
                },
              ),
              const Row(
                children: [
                  Text(
                    "Let's find a puppy you'll love.",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // GridView to display dogs from the 'dogDetails' collection
              ProductCard()
            ],
          ),
        ),
      ),
    );
  }
}
