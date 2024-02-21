import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:paws_and_tail/common/color_extention.dart';
import 'package:paws_and_tail/common/footer_container.dart';
import 'package:paws_and_tail/common/listview_horizontal.dart';
import 'package:paws_and_tail/common/productcard.dart';
import 'package:paws_and_tail/common/textform_refac.dart';
import 'package:paws_and_tail/screens/events.dart';
import 'package:paws_and_tail/screens/products.dart';
import 'package:paws_and_tail/screens/login.dart';
import 'package:paws_and_tail/screens/user_account.dart';
import 'package:paws_and_tail/screens/view_more_dog.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const ProductScreen(),
    const DogShowList(),
    const AccountScreen(),
  ];

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 237, 237),
      appBar: AppBar(
        backgroundColor: TColo.primaryColor1,
        actions: [
          IconButton(
            onPressed: () {
              _showSignOutDialog(context);
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
              SizedBox(
                height: 45,
                child: SearchTextField(
                  controller: _searchController,
                  labelText: 'Search',
                  hintText: 'Search',
                ),
              ),
              const SizedBox(height: 16),

              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('banners')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(color: TColo.gray);
                  }
                  final urls = snapshot.data!.docs
                      .map((doc) => doc['url'] as String)
                      .toList();
                  return CarouselSlider(
                    options: CarouselOptions(
                      viewportFraction: 1,
                      height: MediaQuery.of(context).size.height * .35,
                      enableInfiniteScroll: true,
                      autoPlay: true,
                    ),
                    items: urls
                        .map((url) => Image.network(url, fit: BoxFit.contain))
                        .toList(),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      switch (index) {
                        case 0:
                          return const ProductScreen();
                        case 1:
                          return const ProductScreen();
                        case 2:
                          return const ProductScreen();
                        case 3:
                          return const ProductScreen();
                        default:
                          return Container();
                      }
                    }),
                  );
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
              const ProductCard(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) {
                        return const DogViewMore();
                      }));
                    },
                    child: Text(
                      'View More >',
                      style: TextStyle(
                        color: TColo.primaryColor1,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 30),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      'At Paws & Tails our top priority is the safety and welfare of all pets rehomed through our App',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 41, 96, 43)),
                      textAlign:
                          TextAlign.center, 
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            const TrustAndSafetyWidget(imagePath: 'assets/savefty.png', 
            title: 'Trust and safety team', 
            description: 'A dedicated team to ensure animal welfare and pet safety.'),
            const SizedBox(height: 20),
            const TrustAndSafetyWidget(imagePath: 'assets/purchise.png', 
            title: 'Home of Pet Payments', 
            description: 'Purchase with peace of mind with our Paws & Tails Guarantee.'),
            const SizedBox(height: 20),
            const TrustAndSafetyWidget(imagePath: 'assets/ticket (1).png', 
            title: 'Canine Exhibitions', 
            description: "Paws & Tails presents Canine Exhibitions, showcasing dogs' beauty and talents."),
            const SizedBox(height: 20),
            const Divider(),
          Container(
  width: double.infinity,
  height: 300,
  color: Colors.grey .withOpacity(0.1), 
  child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(crossAxisAlignment: CrossAxisAlignment.center,
     children: [
      Image.asset('assets/Paws & Tails footer.png'),
      const SizedBox(height: 30,),
      const Text('Find Us',style: TextStyle(fontWeight: FontWeight.bold),),
      const SizedBox(height: 15,),
      const Text('Panampilly Nagar-Ernakulam Road, Vytila'),
      const Text('Ernakulam - Kerala'),
      const Text('Near Park'),
      const Text('Kerala 682036'),
      const SizedBox(height: 15,),
      const Text('Contact Us',style: TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 15,),
      const Text('+91 8590168780'),
      const Text('niyaljacob76@gmail.com'),
     ],
    ),
  ),
)


            ],
          ),
        ),
        
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => LoginScreen(),
                  ),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }
}
