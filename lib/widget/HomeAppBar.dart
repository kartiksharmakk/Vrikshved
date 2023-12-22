import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plant_rec/Utils/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_rec/Controller/language_change_controller.dart';
import 'package:provider/provider.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    bool guest = false;
    if (user == null) {
      guest = true;
    }
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(25),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              auth.signOut().then((value) {
                Navigator.pushNamed(context, '/');
              }).onError((error, stackTrace) {
                Utils().toastmessage(error.toString());
              });
            },
            icon: const Icon(
              Icons.logout,
              size: 30,
              color: Color(0xFF4C53A5),
            ),
          ),
          const Padding(padding: EdgeInsets.only(left: 20)),
          Text(
            AppLocalizations.of(context)!.homeappbar_title_vrikshveda,
            style: TextStyle(
                fontSize: 23,
                fontFamily: 'Squada',
                color: Color(0xFF4C53A5),
                fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          guest
              ? Container()
              : Badge(
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/chat');
                    },
                    child: const Icon(
                      Icons.chat_rounded,
                      size: 32,
                      color: Color(0xFF4C53A5),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
