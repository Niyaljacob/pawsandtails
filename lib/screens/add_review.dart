import 'package:flutter/material.dart';
import 'package:paws_and_tail/common/color_extention.dart';
import 'package:paws_and_tail/screens/review.dart';

class AddReview extends StatelessWidget {
  const AddReview({Key? key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _reviewController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColo.primaryColor1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Add Review'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User profile section
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/profilePhoto.png'),
                    radius: 30,
                  ),
                  SizedBox(width: 16),
                  Text(
                    'Username',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text('Share more about your experience',style: TextStyle(fontSize: 16),),
               SizedBox(height: 16),
              // Text form field for review
              TextFormField(
                controller: _reviewController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: 'Write your review...',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your review';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Submit button
             Container(
  width: MediaQuery.of(context).size.width * 0.9,
  child: ElevatedButton(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(TColo.primaryColor1), // Set the background color
    ),
    onPressed: () {
      if (_formKey.currentState!.validate()) {
        // Submit the review
        // Implement your logic here

        // Show a Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Review submitted successfully!'),
            duration: Duration(seconds: 2), // Adjust the duration as needed
          ),
        );

        // Clear the review text field after submission
        _reviewController.clear();
      }
    },
    child: Text(
      'Submit',
      style: TextStyle(color: Colors.white), // Set the text color to white
    ),
  ),
),


            ],
          ),
        ),
      ),
    );
  }
}
