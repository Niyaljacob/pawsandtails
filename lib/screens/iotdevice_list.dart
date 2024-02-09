import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paws_and_tail/screens/update_iot_details.dart';


class IotDeviceList extends StatelessWidget {
  const IotDeviceList({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 96, 182, 252),
        title: const Text('List of IOT Devices'),
      ),
      body: StreamBuilder<QuerySnapshot>(
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
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              return ListTile(
                onTap: () {
                  // Navigate to the details page when tapped
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
                subtitle: Text('\$${data['price']}'),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
