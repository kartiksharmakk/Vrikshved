import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:plant_rec/Utils/utils.dart';
import 'package:plant_rec/widget/HomeAppBar.dart';
class Post extends StatefulWidget {
  const Post({super.key});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  final search = TextEditingController();
  final ref=FirebaseDatabase.instance.ref('data');

  bool check(){
    final auth =FirebaseAuth.instance;
    final user=auth.currentUser;
    bool guest=false;
    if(user==null){
      guest=true;
    }
    return guest;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:check()?Container(): Utils().areyouexpert(),
      body:ListView(
        children: [
          const HomeAppBar(),
          Container(
            padding: const EdgeInsets.only(top: 10),
            height: MediaQuery.of(context).size.height/1.33,
            decoration: const BoxDecoration(
                color: Color(0xFFEDECF2),
                borderRadius: BorderRadius.all(Radius.circular(35))
            ),
            child: Expanded(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 10
                    ),
                    child: const Text(
                      "Expert's Solutions",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Color(0xFF4C53A5),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: TextFormField(
                        controller: search,
                        onChanged: (String val){
                          setState(() {

                          });
                        },
                        decoration: InputDecoration(
                          label: Row(
                            children: const [
                              Icon(Icons.search),
                              Text("Search"),
                            ],
                          ),
                          hintText: "Search",
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
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
                              borderRadius: BorderRadius.circular(10)
                          ),
                        ),

                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 10
                    ),
                    child: const Text(
                      "Solutions",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Color(0xFF4C53A5),
                      ),
                    ),
                  ),
                  Expanded(
                      child:FirebaseAnimatedList(
                        defaultChild: Column(
                          children: const [
                            SizedBox(height: 20,),
                            CircularProgressIndicator(),
                            Text("Loading")
                          ],
                        ),
                        query: ref,
                        itemBuilder: (context,snapshot,animation,index) {
                          final title =snapshot.child('title').value.toString();
                          if(search.text.isEmpty){
                            return ListTile(
                              title: Container(
                                width: double.infinity,
                                margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  // color: const Color(0xFFE9E9DE),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  // border: Border.all(
                                  //     width: 5,
                                  //     color: const Color(0x9145BF1D)
                                  // )
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        snapshot.child('title').value.toString(),
                                        style: const TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF4C53A5)
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot.child('desc').value.toString(),
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black45
                                            ),
                                          ),
                                          const SizedBox(height: 7.5,),
                                          Text(
                                              "by- ${snapshot.child('email').value}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w100,
                                            fontSize: 15
                                          ),)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          else if(title.toLowerCase().contains(search.text.toString().toLowerCase())){
                            return ListTile(
                              title: Container(
                                width: double.infinity,
                                margin: const EdgeInsets.symmetric(horizontal: 15),
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  // color: const Color(0xFFE9E9DE),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  // border: Border.all(
                                  //     width: 5,
                                  //     color: const Color(0x9145BF1D)
                                  // )
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        snapshot.child('title').value.toString(),
                                        style: const TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF4C53A5)
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Text(
                                        snapshot.child('desc').value.toString(),
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black45
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }else{

                            return Container();
                          }
                        },
                      )
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
