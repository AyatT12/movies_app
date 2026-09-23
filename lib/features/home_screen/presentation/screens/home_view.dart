import 'package:flutter/material.dart';
import '../../../browse/presentation/screens/browse_tab_screen.dart';
import '../../../search/presentation/screens/search_tab_screen.dart';
import '../widgets/bottom_navigation_bar.dart';

import 'home_tab_screen.dart';
import 'profile_tab_screen.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<HomeView> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeTabScreen(
        onSeeMore: () {
          setState(() {
            _selectedIndex = 2;
          });
        },
      ),
      const SearchTabScreen(),
      const BrowseTabScreen(),
      const ProfileTabScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: IndexedStack(index: _selectedIndex, children: _pages),

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
