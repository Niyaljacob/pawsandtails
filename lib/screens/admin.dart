import 'package:flutter/material.dart';
import 'package:paws_and_tail/screens/add_adds.dart';
import 'package:paws_and_tail/screens/add_dog_inventory.dart';
import 'package:paws_and_tail/screens/add_dogs.dart';
import 'package:paws_and_tail/screens/add_view_product_inventory.dart';
import 'package:paws_and_tail/screens/advertisement.dart';
import 'package:paws_and_tail/screens/login.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor:const Color.fromARGB(255, 33, 150, 243).withOpacity(0.3),
        title: const Text('Admin'),
        leading: IconButton(
          icon: const Icon(Icons.menu), 
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
         actions: [
    IconButton(
      icon: const Icon(Icons.logout),
      onPressed: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
          return LoginScreen();
        }));
      },
    ),
  ],
      ),
      drawer: Drawer(backgroundColor: Colors.white.withOpacity(0.7),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/adminchild.png'),fit: BoxFit.cover, ),
                
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/adminlogo.png'),
                ],
              )
            ),
            ListTile(
              title: const Text('Add dogs'),
              onTap: () {
                 Navigator.of(context).push(MaterialPageRoute(builder: (_){
                  return const AddDogInventory();
                }));
              },
            ),
            ListTile(
              title: const Text('Add Advertisement'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_){
                  return const Advertisement();
                }));
              },
            ),
            ListTile(
              title: const Text('Add Products'),
              onTap: () {
                 Navigator.of(context).push(MaterialPageRoute(builder: (_){
                  return const AddProductsInventory();
                }));
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/adminhome.png'), // Your background image asset
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

