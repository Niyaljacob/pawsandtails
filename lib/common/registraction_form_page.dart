import 'package:flutter/material.dart';
import 'package:paws_and_tail/common/textform_refac.dart';

class RegistrationFormPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  RegistrationFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: [
            CustomTextField(
              controller: _usernameController,
              labelText: 'Username',
              hintText: 'Enter your username',
              prefixIcon: Icons.person,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a username';
                }
                return null;
              },
            ),
            const SizedBox(height: 25.0),
            CustomTextField(
              controller: _emailController,
              labelText: 'Email',
              hintText: 'Enter your Email',
              prefixIcon: Icons.email,
              obscureText: false,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an email';
                } else if (!RegExp(
                        r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                    .hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 25.0),
            CustomTextField(
              controller: _passwordController,
              labelText: 'Password',
              hintText: 'Enter your password',
              prefixIcon: Icons.lock,
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                } else if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 25.0),
            CustomTextField(
              controller: _phoneController,
              labelText: 'Phone Number',
              hintText: 'Enter your Phone Number',
              prefixIcon: Icons.phone,
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 25.0),
            CustomTextField(
              controller: _ageController,
              labelText: 'Age',
              hintText: 'Enter your Age',
              prefixIcon: Icons.calendar_today,
              obscureText: false,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your age';
                }
                return null;
              },
            ),
            const SizedBox(height: 25.0),
            CustomTextField(
              controller: _genderController,
              labelText: 'Gender',
              hintText: 'Enter your Gender',
              prefixIcon: Icons.person_outline,
              obscureText: false,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your gender';
                }
                return null;
              },
            ),
            const SizedBox(height: 25.0),
            CustomTextField(
              controller: _addressController,
              labelText: 'Address',
              hintText: 'Enter your Address',
              prefixIcon: Icons.location_on,
              obscureText: false,
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
    );
  }
}
