import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DogCartSaleOrderAdmin extends StatelessWidget {
  const DogCartSaleOrderAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('dog_cart_payment')
            .snapshots(),
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

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No sales available.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot document = snapshot.data!.docs[index];
              final Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;

              return _buildProductContainer(context, data, document.reference);
            },
          );
        },
      ),
    );
  }

  Widget _buildProductContainer(BuildContext context, Map<String, dynamic> data,
      DocumentReference documentReference) {
    final List<dynamic> products = data['products'];

    return Container(
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('User Details:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text('Full Name: ${data['fullName']}'),
          Text('Email: ${data['email']}'),
          Text('Phone Number: ${data['phoneNumber']}'),
          Text('Address: ${data['address']}'),
          Text('Payment Method: ${data['paymentMethod']}'),
          const Divider(),
          const Text('Product Details:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: products.map<Widget>((product) {
              return Text(
                  'Product Name: ${product['name'] ?? 'Name Not Available'}');
            }).toList(),
          ),
          Text('Total Price: Rs ${data['totalPrice']}'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green)),
                onPressed: () {
                  _showAcceptPopup(context, documentReference, data);
                },
                child:
                    const Text('Accept', style: TextStyle(color: Colors.white)),
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red)),
                onPressed: () {
                  _showDeclinePopup(context, documentReference, data);
                },
                child: const Text('Decline',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showAcceptPopup(BuildContext context,
      DocumentReference documentReference, Map<String, dynamic> data) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Accept Order'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you want to accept this order?'),
              ],
            ),
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
                _acceptOrder(documentReference, data);
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _acceptOrder(
      DocumentReference documentReference, Map<String, dynamic> data) async {
    await documentReference.delete();
    FirebaseFirestore.instance
        .collection('dog_cart_payment_accept')
        .add(data);
  }

 Future<void> _showDeclinePopup(BuildContext context,
      DocumentReference documentReference, Map<String, dynamic> data) async {
    TextEditingController reasonController = TextEditingController(); 

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Decline Order'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Are you sure you want to decline this order?'),
                TextField(
                  controller: reasonController,
                  decoration: const InputDecoration(
                    labelText: 'Reason',
                  ),
                ),
              ],
            ),
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
                _declineOrder(documentReference, data, reasonController.text); // Pass reason text
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _declineOrder(DocumentReference documentReference, Map<String, dynamic> data, String reason) async {
    data['reason'] = reason; // Add reason to data
    await documentReference.delete();
    FirebaseFirestore.instance.collection('dog_cart_payment_decline').add(data);
  }

}
