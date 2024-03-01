
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paws_and_tail/common/button_refac.dart';
import 'package:paws_and_tail/common/textform_refac.dart';
import 'package:paws_and_tail/screens/admin.dart';
import 'package:paws_and_tail/screens/bottom_nav.dart';
import 'package:paws_and_tail/screens/register.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
   final _formKey = GlobalKey<FormState>();
  LoginScreen({super.key});
 Future<void> _login(BuildContext context) async {
  try {
    if (_formKey.currentState!.validate()) {
      const String adminEmail = 'admin@example.com';
      const String adminPassword = 'admin123';
      if (_emailController.text == adminEmail &&
          _passwordController.text == adminPassword) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const AdminHome(),
          ),
        );
        return;
      }
      // If not an admin login, proceed with Firebase authentication
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const BottomNav(),
        ),
      );
    }
  } on FirebaseAuthException catch (e) {
    String errorMessage = 'Check the User Name and Password.';

    if (e.code == 'user-not-found') {
      errorMessage = 'No user found for that email.';
    } else if (e.code == 'wrong-password') {
      errorMessage = 'Wrong password provided for that user.';
    } else if (e.code == 'invalid-email') {
      errorMessage = 'Invalid email address.';
    }

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  }
}


 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        body: Container(
      color: Colors.grey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
           Container(
            height: MediaQuery.of(context).size.height, 
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/login.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset('assets/Group 250.png'),
                  const SizedBox(height: 40),
                   Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextField(
                    controller: _emailController,
                    labelText: 'Email id',
                    hintText: 'Enter your Email Id',
                    prefixIcon: Icons.email,
                     validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(
                            r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextField(
                    controller: _passwordController,
                    labelText: 'Password',
                    hintText: 'Enter your username',
                    prefixIcon: Icons.lock,
                    obscureText: true,
                    validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  ),
                ),
                const SizedBox(height: 35),
                CustomElevatedButton(
                  label: 'Login',
                  onPressed: () => _login(context),
                  width: 300,
                  height: 50,
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'New to Paws & Tails?',
                      style: TextStyle(fontSize: 17),
                    ),
                    const SizedBox(width: 4),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(color: Colors.red, fontSize: 17),
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
          // Page Content
         
        ],
      ),
    ),
    );
  }
}