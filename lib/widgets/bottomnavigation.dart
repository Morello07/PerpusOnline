import 'package:flutter/material.dart';

class Bottomnavigation extends StatefulWidget {
  Bottomnavigation(this.page, {super.key});
  final int page;

  @override
  State<Bottomnavigation> createState() => _BottomNavState();
}

class _BottomNavState extends State<Bottomnavigation> {
  void getpage(int index) {
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/home');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/perpus');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      currentIndex: widget.page,
      onTap: getpage,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.book_online), label: "Perpus"),
      ],
    );
  }
}