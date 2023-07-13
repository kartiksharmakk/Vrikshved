
import 'package:flutter/material.dart';
import 'home1.dart';
import 'divider.dart';
import 'widget/plant_recogniser.dart';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

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
                Image.asset('assets/planticon.png',width: 100,),
                const Text("Vrikshveda",style: TextStyle(fontSize: 70,color: Colors.white,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),),
                const Text("Unleashing the Wisdom of Nature",style: TextStyle(color: Colors.white,fontSize: 15),)
              ],
            ),
            nextScreen: const MyApp(),
            splashTransition: SplashTransition.slideTransition,
            pageTransitionType: PageTransitionType.topToBottom,
            backgroundColor: const Color(0xFF112425)));
  }
}

void main() => runApp(const Splash());



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Plant Classification',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: Colors.green,
            primary: const Color(0xFF1A3A39),
        ),

        //sRI COLOR SCEME CHANGE KRN WSSTE APA EV EKRDE AA ki
      ),
      initialRoute: '/',
      routes: {
        '/':(context)=>const Div(),
        '/plant':(context)=>const MyHomePage(title: 'Flutter Demo Home Page'),
        '/disease':(context)=>const PlantRecogniser()
      },
      // home: Div()
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
