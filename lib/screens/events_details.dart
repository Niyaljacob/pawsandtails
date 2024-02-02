import 'package:flutter/material.dart';
import 'package:paws_and_tail/common/color_extention.dart';
import 'package:paws_and_tail/screens/events.dart';

class EventDetails extends StatelessWidget {
  const EventDetails({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColo.primaryColor1,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
        //       return EventScreen();
        //     }));
        //   },
        // ),
        title: Text('Event Details'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Image.asset(
            'assets/event1.png',
            width: double.infinity,
            height: MediaQuery.of(context).size.height*.3,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 16),
          // Event details
          _buildDetailItem(
            context,
            title: 'Posted On',
            value: '30 Dec 2015',
            icon: Icons.timelapse_sharp,
          ),
          _buildDetailItem(
            context,
            title: 'Event',
            value: '35th and 36th All Breeds Championship Dog Show',
          ),
          _buildDetailItem(
            context,
            title: 'Where',
            value: "Zamorin's Higher Secondary School ground,\nPalayam, Calicut",
          ),
          _buildDetailItem(
            context,
            title: 'When',
            value: 'Jan 17, 2016',
          ),
          _buildDetailItem(
            context,
            title: 'Contact',
            value: '0495 270 3520',
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(BuildContext context, {required String title, required String value, IconData? icon}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, color: TColo.primaryColor1),
            SizedBox(width: 8),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
