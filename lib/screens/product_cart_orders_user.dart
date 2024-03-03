import 'package:blinking_text/blinking_text.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:paws_and_tail/common/color_extention.dart';
import 'package:paws_and_tail/common/textform_refac.dart';

class ProductCartOrdersUser extends StatefulWidget {
  const ProductCartOrdersUser({Key? key}) : super(key: key);

  @override
  _ProductCartOrdersUserState createState() => _ProductCartOrdersUserState();
}

class _ProductCartOrdersUserState extends State<ProductCartOrdersUser> {
  int _currentStep = 0;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _cashOnDeliveryChecked = false;
  bool _orderConfirmed = false;

  @override
  Widget build(BuildContext context) {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    // Get the user's email
    String? userEmail = user?.email;

    return Scaffold(
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('product_cart')
              .where('userId', isEqualTo: userEmail)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print('Error: ${snapshot.error}');
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
                child: Text('No products in the cart'),
              );
            }

            // Calculate total price
            double totalPrice = 0;
            List<Map<String, dynamic>> productsInCart = [];
            for (var doc in snapshot.data!.docs) {
              Map<String, dynamic> productData =
                  doc.data() as Map<String, dynamic>;
              try {
                // Extract the numeric part of the price string and parse it as a double
                String priceString = productData['price'] ?? '0';
                double price = double.parse(priceString.replaceAll('Rs ', ''));
                totalPrice += price;

                // Add product to the list of products in cart
                productsInCart.add({
                  'name': productData['productName'],
                  'image': productData['imageURLs']?[0] ??
                      'https://via.placeholder.com/150',
                });
              } catch (e) {
                // Handle parsing error gracefully
                print('Error parsing price: $e');
              }
            }

            return Column(
              children: [
                Text(
                  '<<<<<<Move left or right to delete>>>>>>',
                  style: TextStyle(color: TColo.primaryColor1),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    Map<String, dynamic> productData =
                        document.data() as Map<String, dynamic>;

                    return Dismissible(
                      key: Key(document.id),
                      onDismissed: (direction) {
                        // Remove the item from Firestore
                        FirebaseFirestore.instance
                            .collection('product_cart')
                            .doc(document.id)
                            .delete()
                            .then((value) => print('Item deleted'))
                            .catchError((error) =>
                                print('Failed to delete item: $error'));
                      },
                      confirmDismiss: (direction) async {
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Confirm'),
                              content: const Text(
                                  'Are you sure you want to delete this item?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text('OK'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text('Cancel'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      background: Container(color: Colors.red),
                      child: ListTile(
                        leading: Image.network(
                          productData['imageURLs']?[0] ??
                              'https://via.placeholder.com/150',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(productData['productName'] ??
                            'Product Name Not Available'),
                        subtitle: Text(
                            '${productData['price'] ?? 'Price Not Available'}'),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Total Price: Rs $totalPrice',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Stepper(
                  currentStep: _currentStep,
                  onStepContinue: _currentStep == 2 && !_isOrderConfirmed()
                      ? null
                      : () {
                          if (_currentStep == 1) {
                            if (!_cashOnDeliveryChecked) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please select Cash on Delivery'),
                                ),
                              );
                            } else {
                              // Move to the next step
                              setState(() {
                                _currentStep += 1;
                              });
                            }
                          } else {
                            setState(() {
                              if (_currentStep < 2) {
                                _currentStep += 1;
                              }
                            });
                          }
                        },
                  onStepCancel: () {
                    setState(() {
                      if (_currentStep > 0) {
                        _currentStep -= 1;
                      }
                    });
                  },
                  steps: <Step>[
                    Step(
                      title: const Text('Details'),
                      isActive: _currentStep >= 0,
                      content: Column(
                        children: [
                          Text(
                            'Total Price: Rs $totalPrice',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          CustomTextField(
                            controller: _fullNameController,
                            labelText: 'Full Name',
                            hintText: 'Enter your Full Name',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your full name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          CustomTextField(
                            controller: _emailController,
                            labelText: 'Email',
                            hintText: 'Enter your Email',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              } else if (!_isValidEmail(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          if (_emailController.text.isNotEmpty &&
                              !_isValidEmail(_emailController.text))
                            const Text(
                              'Please enter a valid email',
                              style: TextStyle(color: Colors.red),
                            ),
                          const SizedBox(height: 20),
                          CustomTextField(
                            controller: _phoneNumberController,
                            labelText: 'Phone Number',
                            hintText: 'Enter your Phone Number',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          CustomTextField(
                            controller: _addressController,
                            labelText: 'Address',
                            hintText: 'Enter your Address',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your address';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    Step(
                      title: const Text('Payment'),
                      isActive: _currentStep >= 1,
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Total Price: Rs $totalPrice',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          Text('Full Name: ${_fullNameController.text}'),
                          Text('Email: ${_emailController.text}'),
                          Text('Phone Number: ${_phoneNumberController.text}'),
                          Text('Address: ${_addressController.text}'),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Checkbox(
                                value: _cashOnDeliveryChecked,
                                onChanged: (value) {
                                  setState(() {
                                    _cashOnDeliveryChecked = value!;
                                  });
                                },
                              ),
                              const Text('Cash on Delivery'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Step(
                      title: const Text('Confirm'),
                      isActive: _currentStep >= 2,
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Number of Products: ${productsInCart.length}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Total Amount: Rs $totalPrice',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Full Name: ${_fullNameController.text}',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Email: ${_emailController.text}',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Phone Number: ${_phoneNumberController.text}',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Address: ${_addressController.text}',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text('Your order place with in 5 Days'),
                          const SizedBox(height: 16),
                          const BlinkText(
                            'Payment Method: Cash on delivery',
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold),
                            beginColor: Colors.black,
                            endColor: Colors.orange,
                            times: 50,
                            duration: Duration(seconds: 1),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'The order will be delivered once the administrator approves it.',
                            style: TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              // Show confirmation dialog before placing the order
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Confirm Order"),
                                    content: const Text(
                                        "Are you sure you want to place this order?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          // Place the order
                                          _placeOrder(productsInCart, totalPrice);
                                          setState(() {
                                            _orderConfirmed = true;
                                          });
                                        },
                                        child: const Text("Confirm"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.green),
                            ),
                            child: const Text(
                              'Place Order',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  bool _isValidEmail(String email) {
    String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regExp = RegExp(emailPattern);
    return regExp.hasMatch(email);
  }

  bool _isOrderConfirmed() {
    return _orderConfirmed;
  }

  Future<void> _storeOrderDetails(
      List<Map<String, dynamic>> productsInCart, double totalPrice) async {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    // Get the user's email
    String? userEmail = user?.email;

    // Store order details in a new collection called product_cart_payment
    try {
      await FirebaseFirestore.instance.collection('product_cart_payment').add({
        'userId': userEmail,
        'totalPrice': totalPrice,
        'products': productsInCart,
        'fullName': _fullNameController.text,
        'email': _emailController.text,
        'phoneNumber': _phoneNumberController.text,
        'address': _addressController.text,
        'paymentMethod': 'Cash on Delivery',
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Delete all products from the product_cart collection
      await FirebaseFirestore.instance
          .collection('product_cart')
          .where('userId', isEqualTo: userEmail)
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order placed successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to place order. Please try again later.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _placeOrder(
      List<Map<String, dynamic>> productsInCart, double totalPrice) async {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    // Get the user's email
    String? userEmail = user?.email;

    // Store order details in a new collection called product_cart_payment
    try {
      await FirebaseFirestore.instance.collection('product_cart_payment').add({
        'userId': userEmail,
        'totalPrice': totalPrice,
        'products': productsInCart,
        'fullName': _fullNameController.text,
        'email': _emailController.text,
        'phoneNumber': _phoneNumberController.text,
        'address': _addressController.text,
        'paymentMethod': 'Cash on Delivery',
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Delete all products from the product_cart collection
      await FirebaseFirestore.instance
          .collection('product_cart')
          .where('userId', isEqualTo: userEmail)
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order placed successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to place order. Please try again later.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
