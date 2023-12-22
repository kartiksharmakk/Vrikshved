import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plant_rec/Utils/utils.dart';
import 'package:plant_rec/theme/theme.dart';
import 'package:icons_plus/icons_plus.dart';
import 'Signup.dart';
import '../widget/Custom_Scaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formSignInKey = GlobalKey<FormState>();
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please Enter Your Email";
    }
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    return value.isEmpty || !regex.hasMatch(value)
        ? 'Enter a valid email address'
        : null;
  }

  bool rememberPass = true;
  bool loading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailcontroller.dispose();
    passwordcontroller.dispose();
  }

  void login() {
    if (_formSignInKey.currentState!.validate() && rememberPass) {
      setState(() {
        loading = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Processing Data'),
        ),
      );

      _auth
          .signInWithEmailAndPassword(
              email: emailcontroller.text.toString(),
              password: passwordcontroller.text.toString())
          .then((value) {
        Utils().toastmessage(value.user!.email.toString());
        setState(() {
          loading = false;
        });
        Navigator.pushNamed(context, '/dash');
      }).onError((error, stackTrace) {
        Utils().toastmessage(error.toString());
        setState(() {
          loading = false;
        });
      });
    } else if (!rememberPass) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please agree to the processing of personal data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Custom_Scaffold(
          child: Column(
        children: [
          const Expanded(
              flex: 1,
              child: SizedBox(
                height: 10,
              )),
          Expanded(
              flex: 7,
              child: Container(
                padding: const EdgeInsets.fromLTRB(25, 50, 25, 20),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    )),
                child: SingleChildScrollView(
                  child: Form(
                      key: _formSignInKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.lg_welcomeback,
                            style: TextStyle(
                                color: lightColorScheme.primary,
                                fontSize: 30,
                                fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          TextFormField(
                            validator: validateEmail,
                            controller: emailcontroller,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              label:
                                  Text(AppLocalizations.of(context)!.lg_email),
                              hintText:
                                  AppLocalizations.of(context)!.lg_hintemail,
                              hintStyle: const TextStyle(
                                color: Colors.black26,
                              ),
                              border: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.black12),
                                  borderRadius: BorderRadius.circular(10)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.black12),
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          TextFormField(
                            obscureText: true,
                            obscuringCharacter: "*",
                            controller: passwordcontroller,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please Enter Your Password";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              label:
                                  Text(AppLocalizations.of(context)!.lg_pass),
                              hintText:
                                  AppLocalizations.of(context)!.lg_hintpass,
                              hintStyle: const TextStyle(
                                color: Colors.black26,
                              ),
                              border: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.black12),
                                  borderRadius: BorderRadius.circular(10)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.black12),
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: rememberPass,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        rememberPass = value!;
                                      });
                                    },
                                    activeColor: lightColorScheme.primary,
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!
                                        .lg_agreeprocessdata,
                                    style: TextStyle(color: Colors.black45),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                child: Text(
                                  AppLocalizations.of(context)!.lg_forgotpass,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: lightColorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () {
                                  login();
                                },
                                child: loading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      )
                                    : Text(AppLocalizations.of(context)!
                                        .ws_signin)),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Divider(
                                thickness: 0.7,
                                color: Colors.grey.withOpacity(0.5),
                              )),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 10),
                                child: Text(
                                    AppLocalizations.of(context)!.lg_sgupwith),
                              ),
                              Expanded(
                                  child: Divider(
                                thickness: 0.7,
                                color: Colors.grey.withOpacity(0.5),
                              )),
                            ],
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Logo(Logos.facebook_f),
                              Logo(Logos.twitter),
                              Logo(Logos.google),
                              Logo(Logos.apple),
                            ],
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),
                          // don't have an account
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.lg_donthaveacc,
                                style: TextStyle(
                                  color: Colors.black45,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (e) => const Signup(),
                                    ),
                                  );
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.ws_signup,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: lightColorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                        ],
                      )),
                ),
              ))
        ],
      )),
    );
  }
}
