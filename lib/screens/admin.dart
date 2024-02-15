import 'package:flutter/material.dart';
import 'package:paws_and_tail/screens/add_dog_inventory.dart';
import 'package:paws_and_tail/screens/add_view_dog_show.dart';
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

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Sign Out"),
          content: const Text("Are you sure you want to sign out?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("CANCEL"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
                  return LoginScreen();
                }));
              },
              child: const Text("SIGN OUT"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 150, 243).withOpacity(0.3),
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
              _showSignOutDialog(context);
            },
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white.withOpacity(0.7),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/adminchild.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset('assets/adminlogo.png'),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.pets),
              title: const Text('Create new dogs'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return const AddDogInventory();
                }));
              },
            ),
            ListTile(
              leading: const Icon(Icons.ad_units),
              title: const Text('Publish Advertisement'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return const Advertisement();
                }));
              },
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text('Create Dog Products'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return const AddProductsInventory();
                }));
              },
            ),
            ListTile(
              leading: const Icon(Icons.event),
              title: const Text('Organize Canine Exhibitions'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return const AddViewDogShows();
                }));
              },
            )
          ],
        ),
      ),
      body:const Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text('Top Popular Food Items',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),)
            
          ],
        ),
      )
    );
  }
}
