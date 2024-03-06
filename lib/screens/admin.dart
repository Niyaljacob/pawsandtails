import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paws_and_tail/common/button_refac.dart';
import 'package:paws_and_tail/common/popular_itmes_admin.dart';
import 'package:paws_and_tail/screens/add_dog_inventory.dart';
import 'package:paws_and_tail/screens/add_view_dog_show.dart';
import 'package:paws_and_tail/screens/add_view_product_inventory.dart';
import 'package:paws_and_tail/screens/advertisement.dart';
import 'package:paws_and_tail/screens/dog_cart_sales.dart';
import 'package:paws_and_tail/screens/dog_sales.dart';
import 'package:paws_and_tail/screens/list_product_category.dart';
import 'package:paws_and_tail/screens/login.dart';
import 'package:paws_and_tail/screens/product_cart_sale.dart';
import 'package:paws_and_tail/screens/product_sales.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
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
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
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
        backgroundColor:
            const Color.fromARGB(255, 33, 150, 243).withOpacity(0.3),
         title: Padding(
          padding: const EdgeInsets.only(top: 35),
          child: Image.asset('assets/logomini.png'),
        ),
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
        backgroundColor: Colors.white.withOpacity(0.9),
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
            ),
            ListTile(
              leading: const Icon(Icons.sell),
              title: const Text('Dog Sales'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return  const DogSales();
                }));
              },
            ),
            ListTile(
              leading: const Icon(Icons.sell),
              title: const Text('Product Sales'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return  const ProductSale();
                }));
              },
            ),
            ListTile(
              leading: const Icon(Icons.sell),
              title: const Text('dog Cart Sales'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return  const DogCartSale();
                }));
              },
            ),
            ListTile(
              leading: const Icon(Icons.sell),
              title: const Text('Product Cart Sales'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return  const ProductCartSale();
                }));
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(decoration: const BoxDecoration(
          color: Color.fromARGB(255, 243, 246, 255)
        ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               SizedBox(
              height: 200,
              width: double.infinity,
              child: Image.asset(
                'assets/adminhomemain2.jpg',
                fit: BoxFit.cover,
              ),
            ),
           
                CustomRowWithButton(
                  customText: 'Top Popular Food Items',
                  buttonText: 'View more',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) {
                        return const ListProductCategory(initialTabIndex: 0);
                      }),
                    );
                  },
                ),
                ProductList(
                    stream: FirebaseFirestore.instance
                        .collection('FoodPopular')
                        .snapshots()),
                const Divider(),
                CustomRowWithButton(
                  customText: 'Top Popular Vet Items',
                  buttonText: 'View more',
                  onPressed: () {
                     Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) {
                        return const ListProductCategory(initialTabIndex: 1);
                      }),
                    );
                  },
                ),
                ProductList(
                    stream: FirebaseFirestore.instance
                        .collection('VetPopular')
                        .snapshots()),
                const Divider(),
                CustomRowWithButton(
                  customText: 'Top Accessories Vet Items',
                  buttonText: 'View more',
                  onPressed: () {
                     Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) {
                        return const ListProductCategory(initialTabIndex: 2);
                      }),
                    );
                  },
                ),
                ProductList(
                    stream: FirebaseFirestore.instance
                        .collection('AccessoriesPopular')
                        .snapshots()),
                const Divider(),
                CustomRowWithButton(
                  customText: 'Top IOT Devies',
                  buttonText: 'View more',
                  onPressed: () {
                     Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) {
                        return const ListProductCategory(initialTabIndex: 3);
                      }),
                    );
                  },
                ),
                ProductList(
                    stream: FirebaseFirestore.instance
                        .collection('IOTPopular')
                        .snapshots()),
                        
              ],
            ),
          ),
        ),
      ),
    );
  }
}
