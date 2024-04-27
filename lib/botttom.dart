import 'package:flutter/material.dart';
import 'package:scanner_app/credit.dart';
import 'package:scanner_app/home.dart';
import 'package:scanner_app/profile.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

// ignore: camel_case_types
class Bottom_Nav extends StatefulWidget {
  Bottom_Nav({Key? key, required int initialIndex}) : super(key: key);

  @override
  State<Bottom_Nav> createState() => _Bottom_NavState();
}

class _Bottom_NavState extends State<Bottom_Nav> {
  int _index = 1; // Declare and initialize index variable here

  @override
  Widget build(BuildContext context) {
    final screens = [
      const CreditNoteSummary(),
      const HomePage(),
      const ProfilePage(),
    ];

    final items = <Widget>[
      Image.asset(
        'assets/history.png',
        width: 30,
        height: 30,
      ),
      Image.asset(
        'assets/scanner.png',
        width: 30,
        height: 30,
      ),
      Image.asset(
        'assets/profile.png',
        width: 30,
        height: 30,
      ),
    ];

    return Container(
      color: Colors.blue,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: screens[_index], // Use _index instead of index
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
              iconTheme: const IconThemeData(color: Colors.black),
            ),
            child: CurvedNavigationBar(
              buttonBackgroundColor: Colors.blue,
              backgroundColor: Colors.white,
              height: 60,
              animationCurve: Curves.easeInOut,
              index: _index, // Use _index instead of index
              items: items,
              onTap: (newIndex) {
                setState(() {
                  _index = newIndex; // Update _index instead of index
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
