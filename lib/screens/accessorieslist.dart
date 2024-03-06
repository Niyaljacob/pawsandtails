import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paws_and_tail/common/color_extention.dart';
import 'package:paws_and_tail/screens/update_accessories_details.dart';

class AccessoriesList extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
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
                                    child: CachedNetworkImage(
                                      imageUrl: data['imageURLs'][0],
                                      width: 150,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => const Center(
                                          child:
                                              CircularProgressIndicator()), 
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error), 
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
                                  _deletePopularItem(context, document.id);
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
                          _deleteItem(context, document.id, data['addToPopularItems']);
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

  Future<void> _deleteItem(BuildContext context, String documentId, bool addToPopularItems) async {
    try {
      await FirebaseFirestore.instance.collection('Accessories').doc(documentId).delete();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item deleted successfully'),
        ),
      );
    
      if (addToPopularItems) {
        await FirebaseFirestore.instance.collection('AccessoriesPopular').doc(documentId).delete();
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Item deleted from AccessoriesPopular successfully'),
          ),
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting item: $e'),
        ),
      );
    }
  }

  Future<void> _deletePopularItem(BuildContext context, String documentId) async {
    try {
      await FirebaseFirestore.instance.collection('AccessoriesPopular').doc(documentId).delete();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Popular item deleted successfully'),
        ),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting popular item: $e'),
        ),
      );
    }
  }
}
