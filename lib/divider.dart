import 'package:flutter/material.dart';
import 'widget/Custom_Scaffold.dart';
import 'widget/Welcome_Button.dart';
import 'Auth/Login.dart';
import 'theme/theme.dart';
import 'Auth/Signup.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Div extends StatelessWidget {
  const Div({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Vrikshveda',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w900,
              )),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/1.jpg"), fit: BoxFit.cover)),
        child: Expanded(
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/plant');
                  },
                  child: Expanded(
                    child: Card(
                      elevation: 500,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Image.asset(
                        'assets/project.png',
                        alignment: Alignment.center,
                        width: double.infinity,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/disease');
                  },
                  child: Expanded(
                    child: Card(
                      elevation: 500,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        'assets/project1.png',
                        alignment: Alignment.center,
                        width: double.infinity,
                        fit: BoxFit.fill,
                        // color: Color(0xFF2F6847),
                        // opacity: AlwaysStoppedAnimation(.5),
                        // colorBlendMode: BlendMode.hardLight,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Custom_Scaffold(
      child: Column(
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 40),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                            text: AppLocalizations.of(context)!.ws_welcomeback,
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 45)),
                        TextSpan(
                            text: AppLocalizations.of(context)!.ws_enterdetail,
                            style: TextStyle(fontSize: 20)),
                      ]),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/dash');
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.white),
                        child: Text(AppLocalizations.of(context)!.ws_guestuser,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF5A73B3))),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Flexible(
              flex: 0,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  children: [
                    Expanded(
                        child: WelcomeButton(
                      text: AppLocalizations.of(context)!.ws_signin,
                      ontap: Login(),
                      clr: Colors.transparent,
                      txtclr: Colors.white,
                    )),
                    Expanded(
                        child: WelcomeButton(
                      text: AppLocalizations.of(context)!.ws_signup,
                      ontap: Signup(),
                      clr: Colors.white,
                      txtclr: lightColorScheme.primary,
                    )),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
