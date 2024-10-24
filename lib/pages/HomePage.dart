import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:coffee_soffee/Widget/Tile1.dart'; // Assuming this is where your Tile1 widget is.

class Homepage extends StatelessWidget {
  Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background for a premium feel
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header section
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Lottie coffee icon
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.orange,
                        child: ClipOval(
                          child: Lottie.asset(
                            'assets/images/coffee_icon.json',
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Coffee/Soffee brand name
                      const Text(
                        'Coffee/Soffee',
                        style: TextStyle(
                          fontSize: 23,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Featured Coffee Image
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(35)),
                  child: Image.asset(
                    'assets/images/coffee_dash.jpg',
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 20), // Space after image

                // Special Coffee Menu Header
                const Padding(
                  padding: EdgeInsets.only(left: 8.0, bottom: 12.0),
                  child: Text(
                    'Special For You...',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),

                // Coffee Grid Section
                Tile1(), // Updated Tile1 for grid layout

                const SizedBox(height: 30), // Additional space if needed
              ],
            ),
          ),
        ),
      ),
    );
  }
}
