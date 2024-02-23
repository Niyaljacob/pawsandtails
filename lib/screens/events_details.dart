import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paws_and_tail/common/color_extention.dart';

class EventDetails extends StatelessWidget {
  final String showId;
  final String showName;

  const EventDetails({Key? key, required this.showId, required this.showName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColo.primaryColor1,
        title: Text(showName),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('dog_shows')
            .doc(showId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final data = snapshot.data!.data() as Map<String, dynamic>;
            DateTime whenDate = DateTime.parse(data['when']);
            Duration remainingTime = whenDate.difference(DateTime.now());

            return SingleChildScrollView(
              child: Column(
                children: [
                  // Wrap the Column inside the SingleChildScrollView
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
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
                            (index) => CachedNetworkImage(
                              imageUrl: data['imageUrls'][index],
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Event details
                        ..._buildEventDetails(data),
                      ],
                    ),
                  ),
                  _buildLiveRunningDateWidget(remainingTime),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  List<Widget> _buildEventDetails(Map<String, dynamic> data) {
    List<Map<String, dynamic>> eventDetails = [
      {
        'title': 'Posted On',
        'value': data['postedOn'],
        'icon': Icons.timelapse_sharp
      },
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
    return SingleChildScrollView(
      child: Padding(
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
      ),
    );
  }

  Widget _buildLiveRunningDateWidget(Duration remainingTime) {
    return StreamBuilder<int>(
      stream: Stream.periodic(const Duration(seconds: 1), (i) => i)
          .take(remainingTime.inSeconds),
      builder: (context, snapshot) {
        int secondsRemaining = remainingTime.inSeconds - (snapshot.data ?? 0);
        int days = secondsRemaining ~/ (24 * 3600);
        int hours = (secondsRemaining % (24 * 3600)) ~/ 3600;
        int minutes = ((secondsRemaining % (24 * 3600)) % 3600) ~/ 60;
        int seconds = ((secondsRemaining % (24 * 3600)) % 3600) % 60;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      "Tail-Wagging Days Ahead",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCountdownItem(days, 'Days'),
                  _buildCountdownItem(hours, 'Hours'),
                  _buildCountdownItem(minutes, 'Minutes'),
                  _buildCountdownItem(seconds, 'Seconds'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCountdownItem(int value, String unit) {
    return Container(
      width: 80,
      height: 70,
      decoration: BoxDecoration(
        color: TColo.primaryColor1,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$value',
            style: const TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            unit,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
