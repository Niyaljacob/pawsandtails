import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paws_and_tail/common/registraction_form_page.dart';
import 'package:paws_and_tail/screens/login.dart';
import 'package:paws_and_tail/common/button_refac.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  File? _image;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();

  Future<void> _register() async {
    try {
      if (_formKey.currentState!.validate()) {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        String imageUrl = await _uploadImage();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'username': _usernameController.text,
          'email': _emailController.text,
          'phoneNumber': _phoneController.text,
          'age': _ageController.text,
          'gender': _genderController.text,
          'address': _addressController.text,
          'imageUrl': imageUrl,
        });

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => LoginScreen(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
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
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.grey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/register_img.png'),
                fit: BoxFit.cover,
              ),
            ),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Text(
                  'Create an Account',
                  style: TextStyle(fontSize: 25),
                ),
                GestureDetector(
                  onTap: _getImage,
                  child: CircleAvatar(backgroundColor: const Color.fromARGB(255, 228, 228, 228),
                    radius: 60,
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child:
                        _image == null ? const Icon(Icons.add_a_photo, size: 40) : null,
                  ),
                ),
                const SizedBox(height: 20.0),
                const SizedBox(height: 20.0),
                const SizedBox(height: 15.0),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                     RegistrationFormPage(),
                      const SizedBox(
                        height: 25,
                      ),
                      CustomElevatedButton(
                        label: 'Register',
                        onPressed: _register,
                        width: 300, // Set custom width
                        height: 50,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account?',
                            style: TextStyle(fontSize: 17),
                          ),
                          const SizedBox(width: 4),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (_) => LoginScreen(),
                                ),
                                (Route<dynamic> route) => false,
                              );
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                color: Color.fromARGB(255, 43, 116, 46),
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
