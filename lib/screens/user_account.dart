import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paws_and_tail/common/color_extention.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:paws_and_tail/screens/login.dart';
import 'package:paws_and_tail/screens/my_order.dart';
import 'package:paws_and_tail/screens/my_products.dart';
import 'package:paws_and_tail/screens/privacy_policies.dart';
import 'package:paws_and_tail/screens/product_cart.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  late String _imageUrl = '';

  File? _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    setState(() {
      _usernameController.text = data['username'];
      _emailController.text = data['email'];
      _phoneController.text = data['phoneNumber'];
      _ageController.text = data['age'];
      _genderController.text = data['gender'];
      _addressController.text = data['address'];
      _imageUrl = data['imageUrl'];
    });
  }

  Future<void> _updateProfile() async {
    User? user = FirebaseAuth.instance.currentUser;

    try {
      // Update user details
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .update({
        'username': _usernameController.text,
        'email': _emailController.text,
        'phoneNumber': _phoneController.text,
        'age': _ageController.text,
        'gender': _genderController.text,
        'address': _addressController.text,
      });

      // Upload image if available
      if (_image != null) {
        String imageUrl = await _uploadImage();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .update({
          'imageUrl': imageUrl,
        });
        setState(() {
          _imageUrl = imageUrl;
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error updating profile')));
    }
  }

  Future<String> _uploadImage() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference =
        FirebaseStorage.instance.ref().child('user_images/$fileName');
    UploadTask uploadTask = reference.putFile(_image!);
    TaskSnapshot storageTaskSnapshot =
        await uploadTask.whenComplete(() => null);
    String imageUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return imageUrl;
  }

  Future<void> _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        const Text('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        backgroundColor: TColo.primaryColor1,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _getImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _image != null
                    ? FileImage(_image!) as ImageProvider<Object>?
                    : (_imageUrl.isNotEmpty
                            ? CachedNetworkImageProvider(_imageUrl)
                            : const AssetImage('assets/dogs1.png'))
                        as ImageProvider<Object>?,
                child: const Padding(
                  padding: EdgeInsets.only(top: 60, left: 70),
                  child: Icon(Icons.edit),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
            TextFormField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Age'),
            ),
            TextFormField(
              controller: _genderController,
              decoration: const InputDecoration(labelText: 'Gender'),
            ),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
              ),
              maxLines: null,
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(TColo.primaryColor1)),
              onPressed: _updateProfile,
              child: const Text(
                'Update Profile',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: TColo.primaryColor1,
              ),
              child: const Text(
                'Paws & Tails',
                style: TextStyle(fontWeight: FontWeight.w800,
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('My Dogs'),
              onTap: () {
                 Navigator.of(context).push(MaterialPageRoute(builder: (_){
                  return const MyOrders();
                }));
              },
            ),
            ListTile(
              title: const Text('My Products'),
              onTap: () {
                 Navigator.of(context).push(MaterialPageRoute(builder: (_){
                  return const MyProducts();
                }));
              },
            ),
            ListTile(
              title: const Text('Product Cart'),
              onTap: () {
                 Navigator.of(context).push(MaterialPageRoute(builder: (_){
                  return const ProductCart();
                }));
              },
            ),
            ListTile(
              title: const Text('Privacy Policies'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_){
                  return const PrivacyPolicies();
                }));
              },
            ),
            ListTile(
              title: const Text('Log Out'),
              onTap: () {
                _showSignOutDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }
   void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => LoginScreen(),
                  ),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }
}
