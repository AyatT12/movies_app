import 'package:flutter/material.dart';
import '../widgets/bottom_navigation_bar.dart';

import 'home_tab_screen.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<HomeView> {
  int _selectedIndex = 0;


  final List<Widget> _pages = const [
    HomeTabScreen(),
    Center(child: Text('Search Tab', style: TextStyle(color: Colors.white, fontSize: 18))),
    Center(child: Text('Explore Tab', style: TextStyle(color: Colors.white, fontSize: 18))),
    Center(child: Text('Profile Tab', style: TextStyle(color: Colors.white, fontSize: 18))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121312),
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
      ),

      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}