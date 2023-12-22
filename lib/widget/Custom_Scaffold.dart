import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_rec/Controller/language_change_controller.dart';
import 'package:provider/provider.dart';

enum Language { english, hindi, punjabi }

class Custom_Scaffold extends StatelessWidget {
  const Custom_Scaffold({super.key, this.child});
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Consumer<LanguageChangeController>(
              builder: (context, provider, child) {
            return PopupMenuButton(
                onSelected: (Language item) {
                  if (Language.english.name == item.name) {
                    provider.changeLanguage(Locale('en'));
                  } else if (Language.hindi.name == item.name) {
                    provider.changeLanguage(Locale('hi'));
                  } else if (Language.punjabi.name == item.name) {
                    provider.changeLanguage(Locale('pa'));
                  }
                },
                itemBuilder: (BuildContext contex) =>
                    <PopupMenuEntry<Language>>[
                      const PopupMenuItem(
                          value: Language.english, child: Text("ENGLISH")),
                      const PopupMenuItem(
                          value: Language.hindi, child: Text("HINDI")),
                      const PopupMenuItem(
                          value: Language.punjabi, child: Text("PUNJABI"))
                    ]);
          })
        ],
      ),
      body: Stack(
        children: [
          Image.asset(
            "assets/bg1.png",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(child: child!)
        ],
      ),
    );
  }
}
