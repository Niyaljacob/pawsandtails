import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paws_and_tail/common/color_extention.dart';
import 'package:paws_and_tail/screens/update_iot_details.dart';

class IotDeviceList extends StatelessWidget {
  const IotDeviceList({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: const Color.fromARGB(255, 96, 182, 252),
      //   title: const Text('List of IOT Devices'),
      // ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Popular Items',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 200, 
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('IOTPopular').snapshots(),
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
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
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
                              Positioned(
                                top: 4,
                                right: 4,
                                child: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    _deletePopularItem(document.id);
                                  },
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(data['productName']),
                          Text(data['brandName']),
                          Text('Rs ${data['price']}',style: TextStyle(color: TColo.primaryColor1),),
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
            child: Text(
              'IOT Device products',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
           const Center(child: Text('<<<<<sype Left to Delete<<<<<',style: TextStyle(color: Colors.blue),)),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('IOT Device').snapshots(),
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => IotDeviceDetails(
                                productId: document.id,
                                productName: data['productName'],
                              ),
                            ),
                          );
                        },
                        leading: Image.network(
                          data['imageURLs'][0],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(data['productName']),
                        subtitle: Text('Rs ${data['price']}'),
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
      await FirebaseFirestore.instance.collection('IOT Device').doc(documentId).delete();
      print('Item deleted from IOT Device successfully');
    } catch (e) {
      print('Error deleting item: $e');
    }
  }

  Future<void> _deletePopularItem(String documentId) async {
    try {
      await FirebaseFirestore.instance.collection('IOTPopular').doc(documentId).delete();
      print('Item deleted from IOTPopular successfully');
    } catch (e) {
      print('Error deleting popular item: $e');
    }
  }
}
