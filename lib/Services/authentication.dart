import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  // Firestore instance for storing user data
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firebase Auth instance for handling authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Method for signing in with Google
  Future<UserCredential?> loginWithGoogle() async {
    try {
      // Initiate Google Sign-In
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Check if user is not null
      if (googleUser == null) return null;

      // Get the authentication details from the Google sign-in
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      // Sign in to Firebase with the Google credential
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print("Google Sign-In Error: ${e.toString()}");
      return null;
    }
  }

  // Method for signing up a new user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    String res = "Some error occurred";
    try {
      // Check if the fields are not empty
      if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty && phone.isNotEmpty) {
        // Register the user with Firebase Auth
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Add user data to Firestore
        await _firestore.collection("users").doc(credential.user!.uid).set({
          'name': name,
          'email': email,
          'phone': phone,
          'uid': credential.user!.uid,
        });

        res = "Success"; // Return success message
      } else {
        res = "Please fill all fields"; // Return error if any field is empty
      }
    } catch (e) {
      print("Sign-Up Error: ${e.toString()}"); // Log the error for debugging
      return e.toString(); // Return the error message
    }
    return res; // Return the response
  }

  // Method for logging in a user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";
    try {
      // Check if the fields are not empty
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = "Success"; // Return success message
      } else {
        res = "Please fill all fields"; // Return error if any field is empty
      }
    } catch (e) {
      print("Login Error: ${e.toString()}"); // Log the error for debugging
      return e.toString(); // Return the error message
    }
    return res; // Return the response
  }

  // Method for signing out a user
  Future<void> signOut() async {
    await _auth.signOut(); // Sign out from Firebase Auth
  }

  // Method to get current user ID
  String getCurrentUserId() {
    return _auth.currentUser?.uid ?? ""; // Return current user's UID
  }
}
