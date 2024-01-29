import 'package:flutter/material.dart';
import 'package:paws_and_tail/common/color_extention.dart';

class EventCard extends StatelessWidget {
  final String imagePath;
  final String eventName;
  final String eventDate;
   final VoidCallback onTap;

  const EventCard({
    Key? key,
    required this.imagePath,
    required this.eventName,
    required this.eventDate,
     required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () {
      //   Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      //     return EventDetails();
      //   }
      //   ));
      // },
       onTap: () => onTap(),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.asset(
                imagePath,
                width: double.infinity,
                height: 170,
                fit: BoxFit.cover,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.location_on, color: TColo.gray),
                          SizedBox(width: 8),
                          Text(
                            eventName,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4),
                      child: Row(
                        children: [
                          Icon(Icons.timelapse_sharp, color: Colors.grey),
                          SizedBox(width: 8),
                          Text(
                            eventDate,
                            style: TextStyle(fontSize: 14, color: TColo.gray),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Icon(Icons.favorite_border, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
