import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class Chatroom extends StatelessWidget {
  String? email;
  String? chatID;
  String? name;
  Chatroom({super.key,required this.name,required this.email,required this.chatID});
  final _firestore=FirebaseFirestore.instance;


  showstatus(){
    var a=StreamBuilder(
      stream: _firestore.collection("user").where('email',isEqualTo: email).snapshots(),
        builder: (context,snapshot){
        if(snapshot.data!=null){
          return Text(
            snapshot.data!.docs[0]['status']
          );
        }
        return Text("dataqadasd");
        }
    );
    return a;
  }


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

  File? image;

  void sendImage() async{
    ImagePicker _picker=ImagePicker();

    await _picker.pickImage(source: ImageSource.gallery).then((value){
      if(value!=null){
        image=File(value.path);
        uploadImage();
      }
    });
  }

  Future uploadImage() async {
    String fileName = Uuid().v1();
    int status = 1;

    await _firestore
        .collection('chatroom')
        .doc(chatID)
        .collection('chats')
        .doc(fileName)
        .set({
      "sendby": auth.currentUser!.email.toString(),
      "message": "",
      "type": "img",
      "time": FieldValue.serverTimestamp(),
    });

    var ref =
    FirebaseStorage.instance.ref().child('images').child("$fileName.jpg");

    var uploadTask = await ref.putFile(image!).catchError((error) async {
      await _firestore
          .collection('chatroom')
          .doc(chatID)
          .collection('chats')
          .doc(fileName)
          .delete();

      status = 0;
    });

    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();

      await _firestore
          .collection('chatroom')
          .doc(chatID)
          .collection('chats')
          .doc(fileName)
          .update({"message": imageUrl});

      print(imageUrl);
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
        child: msg['type']=="text"?
        Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: align==Alignment.topRight?
              const Color(0xFF4C53A5)
                  :
              const Color(0xAA4C53A5),
            ),
            child:Text(
              msg["message"],
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            )
        )
            :
        Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height/3,
              maxWidth: MediaQuery.of(context).size.width/1.25
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: align==Alignment.topRight?
              const Color(0xFF4C53A5)
                  :
              const Color(0xCC4C53A5),
            ),
            child:InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ShowImage(
                    imageUrl: msg['message'],
                  ),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  msg['message'],
                  ),
              ),
            ),
            )
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFFEDECF1),

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
              color: Color(0xFFEDECF2),
              fontWeight: FontWeight.w900
          ),
        ),
      ),
      body:ListView(
        children: [
          Stack(
            children: [
              Container(
                height: 30,
                decoration: BoxDecoration(
                  color:  const Color(0xFF4C53A5)
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 30,
                  decoration: BoxDecoration(
                      color: Color(0xFFEDECF1),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(50),
                          topLeft: Radius.circular(50)
                      )
                  ),
                child: showstatus(),
              )
            ],
          ),
          SizedBox(height: 10,),
          Container(
            height: MediaQuery.of(context).size.height/1.25,
          child:StreamBuilder<QuerySnapshot>(
                      stream: _firestore
                          .collection("chatroom")
                          .doc(chatID)
                          .collection("chats")
                          .orderBy("time",descending: false)
                          .snapshots(),
                        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
                          if(snapshot.data!=null){
                            // print("objecwt");
                            return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                // print("asdasdas");
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
                    suffixIcon: IconButton(
                      icon:Icon(Icons.image),
                      onPressed: sendImage,
                    ),
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


class ShowImage extends StatelessWidget {
  final String imageUrl;

  const ShowImage({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.black,
        child: Image.network(imageUrl),
      ),
    );
  }
}