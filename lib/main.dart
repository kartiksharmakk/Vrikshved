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
import 'package:plant_rec/Controller/language_change_controller.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sp = await SharedPreferences.getInstance();
  final String languageCode = sp.getString('language_code') ?? '';

  await Firebase.initializeApp();
  runApp(Splash(locale: languageCode));
}

class MyApp extends StatelessWidget {
  final String locale;
  MyApp({super.key, required this.locale});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LanguageChangeController()),
        ],
        child: Consumer<LanguageChangeController>(
            builder: (context, provider, child) {
          if (locale.isEmpty) {
            provider.changeLanguage(Locale('en'));
          }

          return MaterialApp(
            locale: locale == ''
                ? Locale('en')
                : provider.appLocale == null
                    ? Locale('en')
                    : provider.appLocale,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate
            ],

            supportedLocales: [Locale('en'), Locale('hi'), Locale('pa')],
            debugShowCheckedModeBanner: false,
            title: 'Plant Classification',
            theme: ThemeData(scaffoldBackgroundColor: Colors.white),
            initialRoute: Utils().login() ? '/dash' : '/',
            routes: {
              '/': (context) => WelcomeScreen(),
              '/plant': (context) =>
                  const MyHomePage(title: 'Flutter Demo Home Page'),
              '/disease': (context) => const PlantRecogniser(),
              '/chat': (context) => ChatApp(),
              '/dash': (context) => Dashboard(),
              '/signup': (context) => const Signup()
            },
            // home: Div()
            // home: const MyHomePage(title: 'Flutter Demo Home Page'),
          );
        }));
  }
}
