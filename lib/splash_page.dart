import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:rider/login_signup.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    // Navigate to LoginSignUp after 7 seconds
    Timer(const Duration(seconds: 7), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginSignUp()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white, // Background color for the splash screen
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Animated glowing avatar with an image
            AvatarGlow(
              glowColor: Colors.red,
              endRadius: 90.0,
              duration: const Duration(milliseconds: 2000),
              repeat: true,
              showTwoGlows: true,
              repeatPauseDuration: const Duration(milliseconds: 100),
              child: Material(
                elevation: 8.0,
                shape: const CircleBorder(),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[100],
                  child: Image.asset(
                    'assets/images/car_ios.png', // Replace with your image asset
                    height: 100,
                    width: 100,
                  ),
                  radius: 60.0,
                ),
              ),
            ),

            // Spacing
            const SizedBox(height: 20),

            // Animated Text
            SizedBox(
              width: 250.0,
              child: TextLiquidFill(
                text: 'Ryflex',
                waveColor: Colors.red,
                boxBackgroundColor: Colors.white,
                textStyle: const TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                ),
                boxHeight: 80.0,
              ),
            ),

            // Spacing
            const SizedBox(height: 40),

            // Progress Indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}
