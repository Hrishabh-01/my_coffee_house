import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        // alignment: Alignment.center,
        child: Image.asset('assets/images/coffee_splash.jpg'),
      ),
    );
  }
}
