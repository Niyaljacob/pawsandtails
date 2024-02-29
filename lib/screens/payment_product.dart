import 'package:blinking_text/blinking_text.dart';
import 'package:flutter/material.dart';
import 'package:paws_and_tail/common/color_extention.dart';
import 'package:paws_and_tail/common/textform_refac.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentProducts extends StatefulWidget {
  final String productName;
  final String price;
  final List<String> imageURLs;

  const PaymentProducts({
    Key? key,
    required this.productName,
    required this.price,
    required this.imageURLs,
  }) : super(key: key);

  @override
  _PaymentProductsState createState() => _PaymentProductsState();
}

class _PaymentProductsState extends State<PaymentProducts>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool _isCashOnDeliverySelected = false;

  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _animation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      curve: Curves.easeInOut,
      parent: _animationController,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: TColo.primaryColor1,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SlideTransition(
              position: _animation,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 211, 211, 211),
                ),
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.imageURLs.length,
                  itemBuilder: (context, index) {
                    final imageUrl = widget.imageURLs.isNotEmpty
                        ? widget.imageURLs[index]
                        : '';

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              errorBuilder: (context, error, stackTrace) {
                                // Handle image loading errors
                                print('Error loading image: $error');
                                return const Icon(Icons.error);
                              },
                            )
                          : Container(
                              width: 100,
                              height: 100,
                              color: Colors.grey,
                            ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Stepper(
              currentStep: _currentStep,
              onStepContinue: () {
                if (_currentStep < 3 - 1) {
                  if (_validateStep()) {
                    if (_currentStep == 1) {
                      if (_isCashOnDeliverySelected) {
                        setState(() {
                          _currentStep += 1;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select Cash on Delivery'),
                          ),
                        );
                      }
                    } else {
                      setState(() {
                        _currentStep += 1;
                      });
                    }
                  }
                } else {
                  _showConfirmationDialog();
                }
              },
              onStepCancel: () {
                if (_currentStep > 0) {
                  setState(() {
                    _currentStep -= 1;
                  });
                } else {
                  _currentStep = 0;
                }
              },
              steps: [
                Step(
                  title: const Text('Details'),
                  isActive: _currentStep >= 0,
                  content: Column(
                    children: [
                      Text(
                        widget.productName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.price,
                        style: TextStyle(
                          color: TColo.primaryColor1,
                          fontSize: 15,
                        ),
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
                  content: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Product Name: ${widget.productName}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Price: ${widget.price}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: TColo.primaryColor1),
                      ),
                      Text(
                        'Full Name: ${_fullNameController.text}',
                      ),
                      Text(
                        'Email: ${_emailController.text}',
                      ),
                      Text(
                        'Phone Number: ${_phoneNumberController.text}',
                      ),
                      Text(
                        'Address: ${_addressController.text}',
                      ),
                      const SizedBox(height: 16),
                      CheckboxListTile(
                        title: const Text('Cash on Delivery'),
                        value: _isCashOnDeliverySelected,
                        onChanged: (value) {
                          setState(() {
                            _isCashOnDeliverySelected = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Step(
                  title: const Text('Confirm'),
                  isActive: _currentStep >= 2,
                  content: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Product Name: ${widget.productName}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Price: ${widget.price}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: TColo.primaryColor1),
                      ),
                      Text(
                        'Full Name: ${_fullNameController.text}',
                      ),
                      Text(
                        'Email: ${_emailController.text}',
                      ),
                      Text(
                        'Phone Number: ${_phoneNumberController.text}',
                      ),
                      Text(
                        'Address: ${_addressController.text}',
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
                       const Text('The order will be delivered once the administrator approves it.',style: TextStyle(color: Colors.red),),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to confirm the Order?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _storePaymentData();
                _clearFields();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Order placed successfully!"),
                  ),
                );
                Navigator.of(context).pop(); 
              },
              child: const Text('Confirm'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _storePaymentData() {
    // Store payment data in the Firestore collection
    FirebaseFirestore.instance.collection('product_payment').add({
      'productName': widget.productName,
      'price': widget.price,
      'fullName': _fullNameController.text,
      'email': _emailController.text,
      'phoneNumber': _phoneNumberController.text,
      'address': _addressController.text,
      'imageURLs': widget.imageURLs,
    }).then((value) {
      print('Payment data stored successfully');
    }).catchError((error) {
      print('Failed to store payment data: $error');
    });
  }

  bool _validateStep() {
    switch (_currentStep) {
      case 0:
        if (_fullNameController.text.isEmpty ||
            _emailController.text.isEmpty ||
            _phoneNumberController.text.isEmpty ||
            _addressController.text.isEmpty) {
          return false;
        }
        break;
    }
    return true;
  }

  bool _isValidEmail(String email) {
    String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regExp = RegExp(emailPattern);
    return regExp.hasMatch(email);
  }

  void _clearFields() {
    _fullNameController.clear();
    _emailController.clear();
    _phoneNumberController.clear();
    _addressController.clear();
    setState(() {
      _isCashOnDeliverySelected = false;
      _currentStep = 0;
    });
  }
}
