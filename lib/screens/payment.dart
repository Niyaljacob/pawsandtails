import 'package:flutter/material.dart';
import 'package:paws_and_tail/common/color_extention.dart';
import 'package:paws_and_tail/common/textform_refac.dart';

class Payment extends StatefulWidget {
  final String dogName;
  final String price;
  final List<String> imageUrls;

  const Payment({
    Key? key,
    required this.dogName,
    required this.price,
    required this.imageUrls,
  }) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> with TickerProviderStateMixin {
  late AnimationController _imageAnimationController;
  late Animation<Offset> _imageAnimation;
  late AnimationController _breedAnimationController;
  late Animation<Offset> _breedAnimation;
  late AnimationController _priceAnimationController;
  late Animation<Offset> _priceAnimation;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Image Animation
    _imageAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _imageAnimation = Tween<Offset>(
  begin: const Offset(1.0, 0.0), // Start from the right
  end: Offset.zero, // Slide to the center
).animate(CurvedAnimation(
  parent: _imageAnimationController,
  curve: Curves.easeInOut,
));


    // Breed Animation
    _breedAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _breedAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _breedAnimationController,
      curve: Curves.easeInOut,
    ));

    // Price Animation
    _priceAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _priceAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _priceAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start the animations
    _startAnimations();
  }

  @override
  void dispose() {
    _imageAnimationController.dispose();
    _breedAnimationController.dispose();
    _priceAnimationController.dispose();
    super.dispose();
  }

  void _startAnimations() {
    _imageAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _breedAnimationController.forward();
      _priceAnimationController.forward();
    });
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
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SlideTransition(
              position: _imageAnimation,
              child: Container(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 211, 211, 211)),
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount:
                      1, 
                  itemBuilder: (context, index) {
                    
                    final imageUrl =
                        widget.imageUrls.isNotEmpty ? widget.imageUrls[0] : '';

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(imageUrl),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SlideTransition(
                    position: _breedAnimation,
                    child: Text(
                      widget.dogName,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SlideTransition(
                    position: _priceAnimation,
                    child: Text(
                      widget.price,
                      style:
                          TextStyle(color: TColo.primaryColor1, fontSize: 15),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                      controller: _fullNameController,
                      labelText: 'Full Name',
                      hintText: 'Enter your Full Name'),
                  const SizedBox(height: 20),
                  CustomTextField(
                      controller: _emailController,
                      labelText: 'Email',
                      hintText: 'Enter your Email'),
                  const SizedBox(height: 20),
                  CustomTextField(
                      controller: _phoneNumberController,
                      labelText: 'Phone Number',
                      hintText: 'Enter your Phone Number'),
                  const SizedBox(height: 20),
                  CustomTextField(
                      controller: _addressController,
                      labelText: 'Address',
                      hintText: 'Enter your Address'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            TColo.primaryColor1)),
                    onPressed: () {
                      // Handle cash on delivery procedure
                    },
                    child: const Text(
                      'Proceed with Cash on Delivery',
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
