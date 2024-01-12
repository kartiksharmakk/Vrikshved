import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plant_rec/widget/plant_recogniser.dart';
import 'package:provider/provider.dart';
import 'Controller/language_change_controller.dart';
import 'Post.dart';
import 'home1.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with WidgetsBindingObserver{
  final List<Widget> _children = [
    const PlantRecogniser(),
    const MyHomePage(),
    const Post()
    // Profile(),
  ];

  final _firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setStatus("Online");
  }

  void setStatus(String status) async{
    await _firestore.collection("user").doc(auth.currentUser?.uid).update({
      "status":status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if(state==AppLifecycleState.resumed){
      setStatus("Online");
      print("Asdasnjkdansdkjasndkjasndskajndsndkjasd");
    }
    else{
      setStatus("Offline");
    }
  }


  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  int _page=0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        body: _children[_page],
        bottomNavigationBar: CurvedNavigationBar(
            backgroundColor: Colors.transparent,
            key: _bottomNavigationKey,
            index: _page,
            height: 70,
            animationCurve: Curves.easeInOut,
            animationDuration: const Duration(milliseconds: 600),
            onTap: (index){
              setState(() {
                _page=index;
                // print(_page);
                // _bottomNavigationKey.currentState?.setPage(_page);
              });

            },
            letIndexChange: (index) => true,
            color: const Color(0xFF4C53A5),
            items: const [
              Icon(
                Icons.medical_services,
                size: 30,
                color: Colors.white,
              ),
              Icon(
                Icons.search_off,
                size: 30,
                color: Colors.white,
              ),
              Icon(
                Icons.healing,
                size: 30,
                color: Colors.white,
              )
            ]
        ),
      ),
    );
  }
}
