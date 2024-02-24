import 'package:flutter/material.dart';
import 'package:paws_and_tail/common/color_extention.dart';
import 'package:paws_and_tail/common/textform_refac.dart';

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

class _PaymentProductsState extends State<PaymentProducts> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

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
                    final imageUrl = widget.imageURLs.isNotEmpty ? widget.imageURLs[index] : '';

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              errorBuilder: (context, error, stackTrace) {
                                // Handle image loading errors
                                print('Error loading image: $error');
                                return const Icon(Icons.error); // Placeholder for error
                              },
                            )
                          : Container(
                              width: 100,
                              height: 100,
                              color: Colors.grey, // Placeholder for empty URLs
                            ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(-50 * (1 - _animationController.value), 0.0),
                    child: Opacity(
                      opacity: _animationController.value,
                      child: Column(
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
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  CustomTextField(
                    controller: _fullNameController,
                    labelText: 'Full Name',
                    hintText: 'Enter your Full Name',
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _emailController,
                    labelText: 'Email',
                    hintText: 'Enter your Email',
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _phoneNumberController,
                    labelText: 'Phone Number',
                    hintText: 'Enter your Phone Number',
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _addressController,
                    labelText: 'Address',
                    hintText: 'Enter your Address',
                    
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        TColo.primaryColor1,
                      ),
                    ),
                    onPressed: () {
                      // Handle payment processing
                    },
                    child: const Text(
                      'Proceed with Payment',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
