import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DogOrders extends StatelessWidget {
  const DogOrders({Key? key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DogSaless(),
    );
  }
}

class DogSaless extends StatelessWidget {
  const DogSaless({Key? key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('dog_payment').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
        final List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

        return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            final DocumentSnapshot document = documents[index];
            final List<dynamic> imageUrls = document['imageUrls'];
            final String dogName = document['dogName'];

            // Extract the numerical part of the price string
            final String priceString = document['price'];
            final double price =
                double.tryParse(priceString.split(' ').last) ?? 0.0;

            final String fullName = document['fullName'];
            final String email = document['email'];
            final String phoneNumber = document['phoneNumber'];
            final String address = document['address'];

            return Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CachedNetworkImage(
                        imageUrl: imageUrls[0],
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Dog Name: $dogName'),
                              Text('Price: Rs $price'),
                              Text('Full Name: $fullName'),
                              Text('Email: $email'),
                              Text('Phone Number: $phoneNumber'),
                              Text('Address: $address'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Show confirmation dialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Confirmation'),
                                content: const Text(
                                    'Are you sure you want to accept this Order?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Move details to 'accepted' collection
                                      FirebaseFirestore.instance
                                          .collection('accepted')
                                          .add({
                                        'dogName': dogName,
                                        'price': price,
                                        'fullName': fullName,
                                        'email': email,
                                        'phoneNumber': phoneNumber,
                                        'address': address,
                                        'imageUrls': imageUrls,
                                      }).then((_) {
                                        // Delete details from 'dog_payment' collection
                                        FirebaseFirestore.instance
                                            .collection('dog_payment')
                                            .doc(document.id)
                                            .delete();
                                        // Show a pop-up message
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text('Payment Accepted'),
                                          ),
                                        );
                                      }).catchError((error) {
                                        print(
                                            'Error accepting payment: $error');
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Accept'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text(
                          'Accept',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Show decline dialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              TextEditingController messageController =
                                  TextEditingController();
                              return AlertDialog(
                                title: const Text('Decline Order'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: messageController,
                                      decoration: const InputDecoration(
                                        labelText: 'Message',
                                        hintText: 'Enter your message here',
                                      ),
                                      maxLines: 3,
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      String message =
                                          messageController.text.trim();
                                      if (message.isNotEmpty) {
                                        // Move details to 'dog_decline' collection
                                        FirebaseFirestore.instance
                                            .collection('dog_decline')
                                            .add({
                                          'dogName': dogName,
                                          'price': price,
                                          'fullName': fullName,
                                          'email': email,
                                          'phoneNumber': phoneNumber,
                                          'address': address,
                                          'imageUrls': imageUrls,
                                          'message': message,
                                        }).then((_) {
                                          // Delete details from 'dog_payment' collection
                                          FirebaseFirestore.instance
                                              .collection('dog_payment')
                                              .doc(document.id)
                                              .delete();
                                          // Show a pop-up message
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Payment Declined with Message'),
                                            ),
                                          );
                                        }).catchError((error) {
                                          print(
                                              'Error declining payment: $error');
                                        });
                                        Navigator.of(context).pop();
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content:
                                                Text('Please enter a message'),
                                          ),
                                        );
                                      }
                                    },
                                    child: const Text('Decline'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text(
                          'Decline',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
