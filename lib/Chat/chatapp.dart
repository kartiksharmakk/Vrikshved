import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:plant_rec/Chat/Chatroom.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatApp extends StatefulWidget {
  const ChatApp({super.key});

  @override
  State<ChatApp> createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  final search = TextEditingController();

  final ref = FirebaseDatabase.instance.ref('login');

  late final Map<String, dynamic> userMap;
  final _firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  Widget chatval(val, email) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Chatroom(
                    name: val,
                    email: email,
                    chatID:
                        chatRoomId(email, auth.currentUser!.email.toString()),
                  )),
        );
      },
      child: ListTile(
        title: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            // color: const Color(0xFFE9E9DE),
            color: const Color(0x224C53A5),
            borderRadius: BorderRadius.circular(15),
            // border: Border.all(
            //     width: 5,
            //     color: const Color(0x9145BF1D)
            // )
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.contacts_rounded,
                    size: 30,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      val,
                      style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4C53A5)),
                    ),
                  ),
                ],
              ),
              const Icon(Icons.message)
            ],
          ),
        ),
      ),
    );
  }

  check() {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection("user")
            .where("email", isEqualTo: auth.currentUser?.email.toString())
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data?.docs[0]["type"] == "Expert") {
            print(auth.currentUser?.email.toString());

            return StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('user')
                    .where("type", isEqualTo: "User")
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data != null) {
                    return ListView.builder(
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, index) {
                          if (search.text.isEmpty) {
                            return chatval(snapshot.data?.docs[index]['name'],
                                snapshot.data?.docs[index]['email']);
                          } else {
                            if (snapshot.data?.docs[index]['name']
                                .toLowerCase()
                                .contains(
                                    search.text.toString().toLowerCase())) {
                              return chatval(snapshot.data?.docs[index]['name'],
                                  snapshot.data?.docs[index]['email']);
                            } else {
                              return Container();
                            }
                          }
                        });
                  } else {
                    return Container();
                  }
                });
          }
          print("Asd");
          return StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('user')
                  .where("type", isEqualTo: "Expert")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.data != null) {
                  return ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        if (search.text.isEmpty) {
                          return chatval(snapshot.data?.docs[index]['name'],
                              snapshot.data?.docs[index]['email']);
                        } else {
                          if (snapshot.data?.docs[index]['name']
                              .toLowerCase()
                              .contains(search.text.toString().toLowerCase())) {
                            return chatval(snapshot.data?.docs[index]['name'],
                                snapshot.data?.docs[index]['email']);
                          } else {
                            return Container();
                          }
                        }
                      });
                } else {
                  return Container();
                }
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4C53A5),
      body: ListView(physics: const BouncingScrollPhysics(), children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Text(
            AppLocalizations.of(context)!.chat_chats,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 30,
                fontFamily: 'Squada',
                color: Colors.white,
                fontWeight: FontWeight.w900),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: TextFormField(
            controller: search,
            onChanged: (String val) {
              setState(() {});
            },
            decoration: InputDecoration(
              label: Text(AppLocalizations.of(context)!.post_search),
              hintText: AppLocalizations.of(context)!.chat_search,
              hintStyle: const TextStyle(
                color: Colors.black26,
              ),

              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey.shade400,
                size: 20,
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
                  borderSide: const BorderSide(color: Colors.black12),
                  borderRadius: BorderRadius.circular(10)),
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black12),
                  borderRadius: BorderRadius.circular(50)),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          height: MediaQuery.of(context).size.height / 1.235,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50), topRight: Radius.circular(50))),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                AppLocalizations.of(context)!.chat_convo,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Color(0xFF4C53A5),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(child: check()),
            ],
          ),
        )
      ]),
    );
  }
}
