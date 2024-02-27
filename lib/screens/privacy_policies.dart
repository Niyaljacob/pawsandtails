import 'package:flutter/material.dart';
import 'package:paws_and_tail/common/color_extention.dart';

class PrivacyPolicies extends StatelessWidget {
  const PrivacyPolicies({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policies'),
        backgroundColor: TColo.primaryColor1,
      ),
      body: SingleChildScrollView(
       child: Padding(
         padding: const EdgeInsets.all(8.0),
         child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Information we Collect:',style: TextStyle(color: TColo.primaryColor1,fontWeight: FontWeight.bold),),
            const Divider(),
            const Text('Personal Information:',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize:16 ),),
          const Text('When you create an account, we collect your name, email address, phone number, and other information you provide.'),
          const Text('When you buy the product, we collect details such as location, email.'),
          const Divider(thickness: 5,),
          Text('How we use your information:',style: TextStyle(color: TColo.primaryColor1,fontWeight: FontWeight.bold),),
          const Divider(),
          const Text('Provide Services:',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize:16 ),),
          const Text('We use your personal information to provide the sevices like buying dog and dog products.'),
          const Divider(),
          const Text('Marketing and Communication:',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize:16 ),),
          const Text('We may send you promotional offers, updates, and important information about our services.'),
          const Divider(),
          const Text('Legal Compliance:',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize:16 ),),
          const Text('We use your information to comply with legal obligations and resolve disputes.'),
          const Divider(thickness: 5,),
          Text('Your Choices:',style: TextStyle(color: TColo.primaryColor1,fontWeight: FontWeight.bold),),
          const Divider(),
          const Text('Account Informations:',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize:16 ),),
          const Text('you can review and update your Account information at any time.'),
          const Divider(),
          const Text('Security:',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize:16 ),),
          const Text('We employ industry-standard security measures to protect your information from unauthorized access, disclosure, alteration, anddestruction.'),
          const Divider(),
          const Text('Changes to this Privacy Policy:',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize:16 ),),
          const Text('We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new policy on this page.'),
          const Divider(thickness: 5,),
          const Text('Contact Us:',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize:16 ),),
          const Text('If you have any questions or concerns about this Privacy Policy, Please contact us at on any of the below details'),
          const SizedBox(height: 10,),
          const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('niyal76@gmail.com'),
              Text('Ph: 8590168780'),
            ],
          ),
          ],
         ),
       )
      ),
    );
  }
}