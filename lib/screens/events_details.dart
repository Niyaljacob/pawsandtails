import 'package:flutter/material.dart';
import 'package:paws_and_tail/common/color_extention.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
 
class EventDetails extends StatelessWidget {
  final String showId;
  final String showName;

  const EventDetails({Key? key, required this.showId, required this.showName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColo.primaryColor1,
        title: Text(showName),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('dog_shows').doc(showId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final data = snapshot.data!.data() as Map<String, dynamic>;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Carousel Slider for images
                CarouselSlider(
                  options: CarouselOptions(
                    
                    aspectRatio: 16 / 9,
                    viewportFraction: 1.0,
                    enableInfiniteScroll: false,
                    autoPlay: true,
                  ),
                  items: List.generate(
                    data['imageUrls'].length,
                    (index) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(data['imageUrls'][index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Event details
                ..._buildEventDetails(data),
              ],
            );
          }
        },
      ),
    );
  }

  List<Widget> _buildEventDetails(Map<String, dynamic> data) {
    List<Map<String, dynamic>> eventDetails = [
      {'title': 'Posted On', 'value': data['postedOn'], 'icon': Icons.timelapse_sharp},
      {'title': 'Event', 'value': data['eventDetails']},
      {'title': 'Where', 'value': data['where']},
      {'title': 'When', 'value': data['when']},
      {'title': 'Contact', 'value': data['contact']},
    ];

    return eventDetails.map((detail) {
      return _buildDetailItem(detail['title'], detail['value'], detail['icon']);
    }).toList();
  }

  Widget _buildDetailItem(String title, String value, IconData? icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, color: TColo.primaryColor1),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
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
