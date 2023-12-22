// import 'dart:js';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

import '../AddPost.dart';
class Utils{
  void toastmessage(String message){
  Fluttertoast.showToast(
  msg: message,
  toastLength: Toast.LENGTH_SHORT,
  gravity: ToastGravity.BOTTOM,
  timeInSecForIosWeb: 1,
  backgroundColor: Colors.red,
  textColor: Colors.white,
  fontSize: 16.0
  );
}
  bool login(){
    final auth = FirebaseAuth.instance;
    final user= auth.currentUser;
    if(user != null){
      return true;
    }
    return false;
  }

  areyouexpert(){
    final ref=FirebaseDatabase.instance.ref('login');
    final auth = FirebaseAuth.instance;
    final user= auth.currentUser;

    return StreamBuilder(
      stream: ref.onValue,
        builder: (context,AsyncSnapshot<DatabaseEvent> snapshot){
        if(snapshot.hasData){
          Map<dynamic,dynamic> map=snapshot.data!.snapshot.value as dynamic;
          List<dynamic> list=[];
          list.clear();
          list=map.values.toList();

          int len=snapshot.data!.snapshot.children.length;
          for(int index=0;index<len;index++) {
            if (list[index]['email'] == user!.email.toString()) {
              if(list[index]['type']=='Expert') {
                  return FloatingActionButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>AddPost()));
                    },
                    backgroundColor: const Color(0xFF4C53A5),
                    child: const Icon(Icons.edit),
                  );
                }
              }
          }
        }
        return Container();
        }
    );



  }
}