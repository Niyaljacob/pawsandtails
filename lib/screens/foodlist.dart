import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paws_and_tail/common/color_extention.dart';
import 'package:paws_and_tail/screens/update_food_details.dart';

class FoodList extends StatelessWidget {
  const FoodList({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Popular Items',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('FoodPopular')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError ||
                    !snapshot.hasData ||
                    snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No popular items available'),
                  );
                }

                return SizedBox(
                  height: 190,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = snapshot.data!.docs[index];
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: CachedNetworkImage(
                                    imageUrl: data['imageURLs'][0],
                                    width: 150,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const Center(
                                        child:
                                            CircularProgressIndicator()), // Placeholder widget
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error), // Error widget
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      _deletePopularItem(document.id);
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(data['productName']),
                            Text(data['brandName']),
                            Text('Rs ${data['price']}',
                                style: TextStyle(color: TColo.primaryColor1)),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Food Products',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const Center(
                child: Text('<<<<< Swipe Left to Delete <<<<<',
                    style: TextStyle(color: Colors.blue))),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Food').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    return Dismissible(
                      key: Key(document.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        _deleteItem(document.id);
                      },
                      child: ListTile(
                        leading: CachedNetworkImage(
                                    imageUrl: data['imageURLs'][0],
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const Center(
                                        child:
                                            CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error), 
                                  ),
                        title: Text(data['productName']),
                        subtitle: Text('Rs ${data['price']}',
                            style: TextStyle(color: TColo.primaryColor1)),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FoodDetails(
                                    foodId: document.id,
                                    foodName: data['productName'])),
                          );
                        },
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteItem(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('Food')
          .doc(documentId)
          .delete();
      await FirebaseFirestore.instance
          .collection('FoodPopular')
          .doc(documentId)
          .delete();
      print('Item deleted successfully');
    } catch (e) {
      print('Error deleting item: $e');
    }
  }

  Future<void> _deletePopularItem(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('FoodPopular')
          .doc(documentId)
          .delete();
      print('Popular item deleted successfully');
    } catch (e) {
      print('Error deleting popular item: $e');
    }
  }
}
