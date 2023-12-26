import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plant_rec/Utils/utils.dart';
import 'package:plant_rec/theme/theme.dart';
import 'package:icons_plus/icons_plus.dart';
import 'Signup.dart';
import '../widget/Custom_Scaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Forget extends StatefulWidget {
  const Forget({super.key});

  @override
  State<Forget> createState() => _ForgetState();
}

class _ForgetState extends State<Forget> {
  final _formSignInKey = GlobalKey<FormState>();
  final emailcontroller = TextEditingController();

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
  }

  @override
  Widget build(BuildContext context) {
    return Custom_Scaffold(
        child: Column(
      children: [
        const Expanded(
            flex: 1,
            child: SizedBox(
              height: 10,
            )),
        Expanded(
            flex: 3,
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
                          AppLocalizations.of(context)!.fg_reseturpass,
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
                            label: Text(AppLocalizations.of(context)!.lg_email),
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
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () {
                                _auth
                                    .sendPasswordResetEmail(
                                        email: emailcontroller.text.toString())
                                    .then((value) {
                                  Utils().toastmessage(
                                      "We have sent you a mail to recover your password");
                                }).onError((error, stackTrace) {
                                  Utils().toastmessage(error.toString());
                                });
                              },
                              child: loading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    )
                                  : Text(AppLocalizations.of(context)!
                                      .fg_resetpass)),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                      ],
                    )),
              ),
            ))
      ],
    ));
  }
}
