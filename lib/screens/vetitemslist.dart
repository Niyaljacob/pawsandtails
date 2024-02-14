import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paws_and_tail/screens/update_vetitems_details.dart';

class VetItemList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 96, 182, 252),
        title: const Text('List of Vet Items'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Popular Vet Items',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 200, 
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('VetPopular').snapshots(),
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

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          Container(
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
                                Text('Rs ${data['price']}'),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deletePopularItem(document.id),
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Vet Items Products',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          ),
          const Center(child: Text('<<<<<sype Left to Delete<<<<<',style: TextStyle(color: Colors.blue),)),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Vet Items').snapshots(),
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
                        _deleteItem(document.id);
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
                            MaterialPageRoute(builder: (context) => VetItemsDetails(vetId: document.id, vetName: data['productName'])),
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
    );
  }

  Future<void> _deleteItem(String documentId) async {
    try {
      await FirebaseFirestore.instance.collection('Vet Items').doc(documentId).delete();
      await FirebaseFirestore.instance.collection('VetPopular').doc(documentId).delete();
    } catch (e) {
      print('Error deleting item: $e');
    }
  }

  Future<void> _deletePopularItem(String documentId) async {
    try {
      await FirebaseFirestore.instance.collection('VetPopular').doc(documentId).delete();
      print('Popular item deleted successfully');
    } catch (e) {
      print('Error deleting popular item: $e');
    }
  }
}
