import 'package:flutter/material.dart';
import 'package:paws_and_tail/common/color_extention.dart';
import 'package:paws_and_tail/common/event_card.dart';
import 'package:paws_and_tail/screens/bottom_nav.dart';
import 'package:paws_and_tail/screens/events_details.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColo.primaryColor1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
              return BottomNav();
            }));
          },
        ),
        title: Text('Events'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          EventCard(
            imagePath: 'assets/event1.png',
            eventName: 'Dog Show At Calicut',
            eventDate: 'Posted On : 30 Dec 2015',
            onTap:  () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                return EventDetails();
              }));
            },
          ),
          SizedBox(height: 16),
          EventCard(
            imagePath: 'assets/events2.png',
            eventName: 'Dog Show At Mumbai',
            eventDate: 'Posted On : 15 Jan 2016',
             onTap:  () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                return EventDetails();
              }));
            },
          ),
        ],
      ),
    );
  }
}