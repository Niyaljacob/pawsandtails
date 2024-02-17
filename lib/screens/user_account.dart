import 'package:flutter/material.dart';
import 'package:paws_and_tail/common/color_extention.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        backgroundColor: TColo.primaryColor1,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            GestureDetector(
              onTap: () {
                _tabController.animateTo(0); // Select the first tab
              },
              child: const Tab(
                text: 'User Account',
              ),
            ),
            GestureDetector(
              onTap: () {
                _tabController.animateTo(1); // Select the second tab
              },
              child: const Tab(
                text: 'My Orders',
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          // First tab content: User Account
          Center(
            child: Text('User Account Content'),
          ),
          // Second tab content: Edit Account
          Center(
            child: Text('Edit Account Content'),
          ),
        ],
      ),
    );
  }
}
