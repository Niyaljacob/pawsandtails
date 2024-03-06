import 'package:flutter/material.dart';
import 'package:paws_and_tail/common/color_extention.dart';
import 'package:paws_and_tail/common/tabButton.dart';
import 'package:paws_and_tail/screens/events.dart';
import 'package:paws_and_tail/screens/products.dart';
import 'package:paws_and_tail/screens/home.dart';
import 'package:paws_and_tail/screens/user_account.dart';

class BottomNav extends StatefulWidget {

 const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int selectedTab=0;

  @override
  Widget build(BuildContext context) {
    List pages = [
      const HomeScreen(),
      const ProductScreen(),
      const DogShowList(),
      const AccountScreen(),
    ];
    return Scaffold(
      body: pages[selectedTab],
      bottomNavigationBar: BottomAppBar(
        color: TColo.primaryColor1,
        child: SafeArea(
          child: SizedBox(
            height: kToolbarHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [TAbButton(
                isActive: selectedTab==0,
                 onTap:(){
                   selectedTab=0;
                 if(mounted){
                  setState(() {
                    
                  });
                 } 
                 },
                 selectIcon: 'assets/home.png', 
                 icon: 'assets/home.png'),
                 TAbButton(
                isActive: selectedTab==1,
                 onTap:(){
                   selectedTab=1;
                 if(mounted){
                  setState(() {
                    
                  });
                 } 
                 },
                 selectIcon: 'assets/pet-food (1).png', 
                 icon: 'assets/pet-food (1).png'),
                 TAbButton(
                isActive: selectedTab==2,
                 onTap:(){
                   selectedTab=2;
                 if(mounted){
                  setState(() {
                    
                  });
                 } 
                 },
                 selectIcon: 'assets/event.png', 
                 icon: 'assets/event.png'),
                 TAbButton(
                isActive: selectedTab==3,
                 onTap:(){
                   selectedTab=3;
                 if(mounted){
                  setState(() {
                    
                  });
                 } 
                 },
                 selectIcon: 'assets/accounticon.png', 
                 icon: 'assets/accounticon.png'),
                 ],
            ),
          )
        ),
      ),
    );
  }
}