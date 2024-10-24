import 'package:coffee_soffee/pages/feedPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:coffee_soffee/pages/Cart_page.dart';
import 'package:coffee_soffee/pages/HomePage.dart';
import 'package:coffee_soffee/pages/Profile_page.dart';
import 'package:coffee_soffee/pages/Search_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  int _selectedIndex =
      2; // Default set to HomePage (index 2, as it will be in the center)

  // List of screens that correspond to the navigation items
  static final List<Widget> _screens = [
    const SearchPage(), // Search Page
    const CartPage(), // Cart Page
    Homepage(), // Home Page (center, default)
    FeedPage(), // Flash/another page
     ProfilePage(), // Profile Page (last item)
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex =
          index; // Update selected index when a navigation item is tapped
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[
          _selectedIndex], // Display the current screen based on the selected index
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent, // Background color of the bar
        color: Colors.brown.shade900, // Bar color
        buttonBackgroundColor: Colors.orange.shade600, // Button color
        height: 60, // Height of the bar
        index: _selectedIndex,

        // Navigation items (icons)
        items: const <Widget>[
          Icon(Icons.search,
              size: 30, color: Colors.white), // Search icon (index 0)
          Icon(Icons.shopping_cart,
              size: 30, color: Colors.white), // Cart icon (index 1)
          Icon(Icons.home,
              size: 30, color: Colors.white), // Home icon (index 2, center)
          Icon(Icons.flash_on,
              size: 30, color: Colors.white), // Flash/other icon (index 3)
          Icon(Icons.person,
              size: 30, color: Colors.white), // Profile icon (index 4, last)
        ],

        // Handle the tap event
        onTap: (index) {
          if (index < _screens.length) {
            _onItemTapped(
                index); // Update the selected index when an item is tapped
          }
        },
      ),
    );
  }
}
