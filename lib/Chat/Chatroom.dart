import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Chatroom extends StatelessWidget {
  String? email;
  String? chatID;
  String? name;
  Chatroom({super.key,required this.name,required this.email,required this.chatID});
  final _firestore=FirebaseFirestore.instance;


  void sendMessage() async {
    if (msg.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendby": auth.currentUser!.email.toString(),
        "message": msg.text,
        "type": "text",
        "time": FieldValue.serverTimestamp(),
      };

      msg.clear();
      await _firestore
          .collection('chatroom')
          .doc(chatID)
          .collection('chats')
          .add(messages);
    } else {
      print("Enter Some Text");
    }
  }

  // ChatRoom({required this.chatRoomId, required this.userMap});
  final auth=FirebaseAuth.instance;

  final msg=TextEditingController();

  @override
  Widget build(BuildContext context) {

    Widget message(align,msg){
      return Container(
        width: MediaQuery.of(context).size.width,
        alignment: align,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: align==Alignment.topRight?
            const Color(0xFF4C53A5)
                :
            const Color(0xCC4C53A5),
          ),
          child: Text(
            msg["message"],
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF4C53A5),
        elevation: 0,
        title: Text(
          name!,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 30,
              fontFamily: 'Squada',
              color: Colors.white,
              fontWeight: FontWeight.w900
          ),
        ),
      ),
      body:ListView(
        children: [
          Container(
            margin: EdgeInsets.only(top: 20),
            height: MediaQuery.of(context).size.height/1.23,
          decoration: BoxDecoration(
          color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.elliptical(500, 50),
                  topLeft: Radius.elliptical(500, 50)
              )
          ),
          child:StreamBuilder<QuerySnapshot>(
                      stream: _firestore
                          .collection("chatroom")
                          .doc(chatID)
                          .collection("chats")
                          .orderBy("time",descending: false)
                          .snapshots(),
                        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
                          if(snapshot.data!=null){
                            print("objecwt");
                            return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                print("asdasdas");
                                if(snapshot.data?.docs[index]["sendby"]==auth.currentUser!.email.toString()){
                                  return message(Alignment.topRight,snapshot.data?.docs[index]);
                                }
                                return message(Alignment.topLeft,snapshot.data?.docs[index]);
                              },
                            );
                          }
                          else{
                            return Container();
                          }
                        }
                    ),

          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: TextFormField(
                  controller: msg,
                  decoration: InputDecoration(
                    label: const Text("Your Message"),
                    hintText: "Type Your Message Here...",
                    hintStyle: const TextStyle(
                      color: Colors.black26,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.all(8),
                    // enabledBorder: OutlineInputBorder(
                    // borderRadius: BorderRadius.circular(30),
                    // borderSide: BorderSide(
                    // color: Colors.grey.shade100
                    // )
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.black12
                        ),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.black12
                        ),
                        borderRadius: BorderRadius.circular(50)
                    ),
                  ),
                  )
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: IconButton(
                    icon:Icon(Icons.send),
                  onPressed: sendMessage,
                )
              )
            ],
          ),
        ],
      ),
    );
  }
}
