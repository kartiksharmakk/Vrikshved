import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plant_rec/Auth/Login.dart';
import 'package:plant_rec/Utils/utils.dart';
import '../widget/Custom_Scaffold.dart';
import 'package:plant_rec/theme/theme.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formSignupKey = GlobalKey<FormState>();
  bool agreePersonalData = true;
  bool type = false;
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final name = TextEditingController();

  final databaseref = FirebaseDatabase.instance.ref('login');

  FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  bool loading = false;

  void signup() {
    if (_formSignupKey.currentState!.validate() && agreePersonalData) {
      setState(() {
        loading = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.sg_processingdata),
        ),
      );
      _auth
          .createUserWithEmailAndPassword(
              email: emailcontroller.text.toString(),
              password: passwordcontroller.text.toString())
          .then((value) async {
        setState(() {
          loading = false;
        });
        final id = DateTime.now().millisecondsSinceEpoch.toString();
        databaseref.child(id).set({
          'id': id,
          'email': emailcontroller.text.toString(),
          'name': name.text.toString(),
          'type': type ? "Expert" : "User"
        }).then((value) {
          Utils().toastmessage("Go back to login Button");
        }).onError((error, stackTrace) {
          Utils().toastmessage(error.toString());
        });

        await _firestore.collection("user").doc(_auth.currentUser?.uid).set({
          // 'id':id,
          'email': emailcontroller.text.toString(),
          'name': name.text.toString(),
          'type': type ? "Expert" : "User",
          "status": "Unavailable"
        });
        Navigator.pushNamed(context, '/dash');
      }).onError((error, stackTrace) {
        Utils().toastmessage(error.toString());
        setState(() {
          loading = false;
        });
      });
    } else if (!agreePersonalData) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                AppLocalizations.of(context)!.sg_agreetoprocessdataSnackbar)),
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailcontroller.dispose();
    passwordcontroller.dispose();
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
              ),
            ),
            Expanded(
              flex: 7,
              child: Container(
                padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                ),
                child: SingleChildScrollView(
                  // get started form
                  child: Form(
                    key: _formSignupKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // get started text
                        Text(
                          AppLocalizations.of(context)!.sg_getstarted,
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w900,
                            color: lightColorScheme.primary,
                          ),
                        ),
                        const SizedBox(
                          height: 40.0,
                        ),
                        // full name
                        TextFormField(
                          controller: name,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Full name';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label:
                                Text(AppLocalizations.of(context)!.sg_fullname),
                            hintText:
                                AppLocalizations.of(context)!.sg_enterfullname,
                            hintStyle: const TextStyle(
                              color: Colors.black26,
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black12, // Default border color
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black12, // Default border color
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        // email
                        TextFormField(
                          controller: emailcontroller,
                          keyboardType: TextInputType.emailAddress,
                          validator: validateEmail,
                          decoration: InputDecoration(
                            label: Text(AppLocalizations.of(context)!.lg_email),
                            hintText:
                                AppLocalizations.of(context)!.lg_hintemail,
                            hintStyle: const TextStyle(
                              color: Colors.black26,
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black12, // Default border color
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black12, // Default border color
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        // password
                        TextFormField(
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          controller: passwordcontroller,
                          obscuringCharacter: '*',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Password';
                            } else {
                              if (value.length < 6) {
                                return 'Password should Contain more than 6 letters';
                              }
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label: Text(AppLocalizations.of(context)!.lg_pass),
                            hintText: AppLocalizations.of(context)!.lg_hintpass,
                            hintStyle: const TextStyle(
                              color: Colors.black26,
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black12, // Default border color
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black12, // Default border color
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: type,
                              onChanged: (bool? value) {
                                setState(() {
                                  type = value!;
                                });
                              },
                              activeColor: lightColorScheme.primary,
                            ),
                            Text(
                              AppLocalizations.of(context)!.sg_iama,
                              style: TextStyle(
                                color: Colors.black45,
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)!.sg_expspec,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: lightColorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        // i agree to the processing
                        Row(
                          children: [
                            Checkbox(
                              value: agreePersonalData,
                              onChanged: (bool? value) {
                                setState(() {
                                  agreePersonalData = value!;
                                });
                              },
                              activeColor: lightColorScheme.primary,
                            ),
                            Text(
                              AppLocalizations.of(context)!.sg_agreeprocessdata,
                              style: TextStyle(
                                color: Colors.black45,
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)!.sg_personaldata,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: lightColorScheme.primary,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 25.0,
                        ),
                        // signup button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              signup();
                            },
                            child: loading
                                ? const CircularProgressIndicator(
                                    strokeWidth: 3,
                                    color: Colors.white,
                                  )
                                : Text(
                                    AppLocalizations.of(context)!.ws_signup,
                                  ),
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        // sign up divider
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 0.7,
                                color: Colors.grey.withOpacity(0.5),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: 10,
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.lg_sgupwith,
                                style: TextStyle(
                                  color: Colors.black45,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 0.7,
                                color: Colors.grey.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        // sign up social media logo
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
                        // already have an account
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.sg_alreadyacc,
                              style: TextStyle(
                                color: Colors.black45,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (e) => const Login(),
                                  ),
                                );
                              },
                              child: Text(
                                AppLocalizations.of(context)!.ws_signin,
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
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
