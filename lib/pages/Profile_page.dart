import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../Services/authentication.dart';
import 'Login_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  CollectionReference _collectionReference = FirebaseFirestore.instance.collection('users');
  late AnimationController _animationController;
  late Animation<double> _fadeInProfilePic;

  // User data variables
  String userName = '';
  String userEmail = '';
  String userPhone = '';

  @override
  void initState() {
    super.initState();

    // Fetch user data
    _fetchUserData();

    // AnimationController to handle fade-in animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    // Simple fade-in animation for profile picture
    _fadeInProfilePic = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    // Start animation after page loads
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  Future<void> _fetchUserData() async {
    String uid = AuthServices().getCurrentUserId(); // Method to get current user UID
    DocumentSnapshot userDoc = await _collectionReference.doc(uid).get();

    if (userDoc.exists) {
      setState(() {
        userName = userDoc['name'] ?? 'Unknown'; // Get name
        userEmail = userDoc['email'] ?? 'Unknown'; // Get email
        userPhone = userDoc['phone'] ?? 'Unknown'; // Get phone
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background gradient for better aesthetics
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1C1C1C), // Dark gray
              Color(0xFF0A0A0A), // Almost black
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 80),
                    // Profile Picture with fade-in animation
                    FadeTransition(
                      opacity: _fadeInProfilePic,
                      child: const CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage("assets/images/profile.jpeg"),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      userName, // Dynamically display user's name
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white, // Lighter text color for better contrast
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Coffee Enthusiast | India", // You may want to fetch this as well
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[400], // Light gray for subtle look
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Indian flag emoji
                        const Text(
                          "🇮🇳",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Personal quote or bio section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Text(
                        "\"Life happens, coffee helps.\"",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[500], // Subtle light gray color
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Divider(color: Colors.grey[700], thickness: 1),
                    const SizedBox(height: 50),
                    // Email and Phone Number Section
                    _buildContactInfo(),
                    const SizedBox(height: 130),
                    // Social media or contact buttons
                    _buildSocialButtons(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            // Settings and Edit Buttons
            _buildSettingsAndEditButtons(),
            const SizedBox(height: 20), // Space below the buttons
          ],
        ),
      ),
    );
  }

  // Method to build contact information section
  Widget _buildContactInfo() {
    return Column(
      children: [
        Text(
          "Email: $userEmail", // Dynamically display user's email
          style: const TextStyle(fontSize: 18, color: Colors.white), // White for better visibility
        ),
        const SizedBox(height: 8),
        Text(
          "Phone: $userPhone", // Dynamically display user's phone
          style: const TextStyle(fontSize: 18, color: Colors.white), // White for better visibility
        ),
      ],
    );
  }

  // Social media or contact icons
  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.email, color: Colors.orange),
          onPressed: () {
            // Email action
          },
        ),
        IconButton(
          icon: const Icon(Icons.facebook, color: Colors.orange),
          onPressed: () {
            // Facebook action
          },
        ),
        IconButton(
          icon: const Icon(Icons.phone, color: Colors.orange),
          onPressed: () {
            // Instagram action
          },
        ),
        IconButton(
          icon: const Icon(Icons.linked_camera, color: Colors.orange),
          onPressed: () {
            // Another contact action
          },
        ),
      ],
    );
  }

  Widget _buildSettingsAndEditButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Edit Profile Button
          ElevatedButton(
            onPressed: () {
              // Edit profile action
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Edit Profile", style: TextStyle(color: Colors.white)),
          ),
          // Settings Button
          OutlinedButton.icon(
            onPressed: () async {
              await AuthServices().signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
            },
            icon: const Icon(Icons.settings, color: Colors.orange),
            label: const Text("Log Out", style: TextStyle(color: Colors.orange)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.orange),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
