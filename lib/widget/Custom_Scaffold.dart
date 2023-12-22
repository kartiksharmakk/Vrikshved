import 'package:flutter/material.dart';

class Custom_Scaffold extends StatelessWidget {
  const Custom_Scaffold({super.key,this.child});
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Image.asset(
            "assets/bg1.png",
            fit: BoxFit.cover ,
            width: double.infinity,
            height: double.infinity,),
          SafeArea(child: child!)
        ],
      ),
    );
  }
}
