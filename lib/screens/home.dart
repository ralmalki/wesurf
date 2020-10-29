import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:wesurf/screens/login_screen.dart';
import 'package:wesurf/screens/settings_screen.dart';

import 'feeds_screen.dart';
import 'friends_screen.dart';
import 'map_screen.dart';
import 'notification_screen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PageController _pageController = PageController(initialPage: 2);
  List<Widget> _screens = [
    FeedsScreen(),
    NotificationScreen(),
    MapScreen(),
    FriendsScreen(),
    SettingsScreen()
  ];

  int _selectedIndex = 2;
  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _itemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }

  Future<void> checkIfUserLoggedIn() async {
    //await Firebase.initializeApp();
    try {
      //await Firebase.initializeApp();
      if (FirebaseAuth.instance.currentUser != null) {
        _selectedIndex = 2;
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    checkIfUserLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _screens,
        onPageChanged: _onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 50,
        type: BottomNavigationBarType.fixed,
        onTap: _itemTapped,
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                TablerIcons.home,
                color: _selectedIndex == 0 ? Colors.blue : Colors.grey[600],
              ),
              title: Text("")),
          BottomNavigationBarItem(
              icon: Icon(
                TablerIcons.bell,
                color: _selectedIndex == 1 ? Colors.blue : Colors.grey[600],
              ),
              title: Text("")),
          BottomNavigationBarItem(
              icon: Icon(
                TablerIcons.map_2,
                color: _selectedIndex == 2 ? Colors.blue : Colors.grey[600],
              ),
              title: Text("")),
          BottomNavigationBarItem(
              icon: Icon(
                TablerIcons.users,
                color: _selectedIndex == 3 ? Colors.blue : Colors.grey[600],
              ),
              title: Text("")),
          BottomNavigationBarItem(
              icon: Icon(
                TablerIcons.settings,
                color: _selectedIndex == 4 ? Colors.blue : Colors.grey[600],
              ),
              title: Text("")),
        ],
      ),
    );
  }
}
