import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paws_and_tail/common/color_extention.dart';
import 'package:paws_and_tail/screens/update_accessories_details.dart';

class AccessoriesList extends StatelessWidget {
  const AccessoriesList({Key? key});

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
                'Popular Accessories',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 200,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('AccessoriesPopular').snapshots(),
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
                    scrollDirection: Axis.horizontal,
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            SizedBox(
                              width: 150,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      data['imageURLs'][0],
                                      width: 150,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    data['productName'],
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(data['brandName']),
                                  Text('Rs ${data['price']}', style: TextStyle(color: TColo.primaryColor1)),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: IconButton(
                                onPressed: () {
                                  _deletePopularItem(document.id);
                                },
                                icon: const Icon(Icons.delete, color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Accessories Products',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            ),
            const Center(child: Text('<<<<< Swipe Left to Delete <<<<<',style: TextStyle(color: Colors.blue),)),
            SizedBox(
              height: MediaQuery.of(context).size.height - 308, // Adjust the value according to your needs
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('Accessories').snapshots(),
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
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
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
                          _deleteItem(document.id, data['addToPopularItems']);
                        },
                        child: ListTile(
                          leading: Image.network(
                            data['imageURLs'][0],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(data['productName']),
                          subtitle: Text('Rs ${data['price']}'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AccessoriesDetails(
                                  productId: document.id,
                                  productName: data['productName'],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteItem(String documentId, bool addToPopularItems) async {
    try {
      await FirebaseFirestore.instance.collection('Accessories').doc(documentId).delete();
      print('Item deleted successfully');
    
      if (addToPopularItems) {
        await FirebaseFirestore.instance.collection('AccessoriesPopular').doc(documentId).delete();
        print('Item deleted from AccessoriesPopular successfully');
      }
    } catch (e) {
      print('Error deleting item: $e');
    }
  }

  Future<void> _deletePopularItem(String documentId) async {
    try {
      await FirebaseFirestore.instance.collection('AccessoriesPopular').doc(documentId).delete();
      print('Popular item deleted successfully');
    } catch (e) {
      print('Error deleting popular item: $e');
    }
  }
}
