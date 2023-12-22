
import 'package:plant_rec/Chat/chatapp.dart';
import 'package:plant_rec/Dashboard.dart';
import 'package:plant_rec/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'Auth/Signup.dart';
import 'home1.dart';
import 'divider.dart';
import 'widget/plant_recogniser.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Splash_Screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Splash());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Plant Classification',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white
      ),
      initialRoute: Utils().login() ? '/dash':'/',
      routes: {
        '/':(context)=> WelcomeScreen(),
        '/plant':(context)=>const MyHomePage(title: 'Flutter Demo Home Page'),
        '/disease':(context)=>const PlantRecogniser(),
        '/chat':(context)=>ChatApp(),
        '/dash':(context)=> Dashboard(),
        '/signup':(context)=>const Signup()
      },
      // home: Div()
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
