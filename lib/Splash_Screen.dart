import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'main.dart';

class Splash extends StatelessWidget {
  final String locale;
  const Splash({super.key, required this.locale});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Vrikshveda',
        home: AnimatedSplashScreen(
            // disableNavigation: true,
            splashIconSize: 200,
            // centered: false,
            duration: 3000,
            splash: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/planticon.png',
                  width: 100,
                ),
                const Text(
                  "Vrikshveda",
                  style: TextStyle(
                      fontSize: 70,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
                const Text(
                  "Unleashing the Wisdom of Nature",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                )
              ],
            ),
            nextScreen: MyApp(locale: locale),
            splashTransition: SplashTransition.slideTransition,
            pageTransitionType: PageTransitionType.topToBottom,
            backgroundColor: const Color(0xFF112425)));
  }
}
