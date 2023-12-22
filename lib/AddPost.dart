import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'Utils/utils.dart';
class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final _formSignupKey = GlobalKey<FormState>();
  final _formEditKey = GlobalKey<FormState>();
  bool loading=false;
  final ref=FirebaseDatabase.instance.ref('data');
  final reference=FirebaseDatabase.instance.ref('data');
  final addtitle=TextEditingController();
  final addval=TextEditingController();
  final edittitle=TextEditingController();
  final editval=TextEditingController();
  // final auth = FirebaseAuth.instance;
  // final user= auth.currentUser;

  void add(){
    if(_formSignupKey.currentState!.validate()){
      setState(() {
        loading=true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Adding Values'),
        ),
      );
      final id=DateTime.now().millisecondsSinceEpoch.toString();
      ref.child(id).set({
        'id':id,
        'title' : addtitle.text.toString(),
        'desc' : addval.text.toString(),
        'email': FirebaseAuth.instance.currentUser!.email.toString()
      }).then((value){
        Utils().toastmessage("Value Added");
        setState(() {
          loading=false;
          _formSignupKey.currentState!.reset();
        });
      }).onError((error, stackTrace){
        Utils().toastmessage(error.toString());
        setState(() {
          loading=false;
        });
      });
    }
  }

  Future<void> showmydialog(String title,String des ,String id) async{
    edittitle.text=title;
    editval.text=des;
    return showDialog(
    context: context,
    builder: (BuildContext context){
      return AlertDialog(
      title: const Text('Update'),
      content: SizedBox(
        height: 225,
        child: Form(
          key: _formEditKey,
          child: Column(
            children: [
              TextFormField(
                controller: edittitle,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Title';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  label: const Text("Edit Disease Title"),
                  hintText: "Edit Title",
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
              const SizedBox(height: 15,),
              TextFormField(
                controller: editval,
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Description';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  label: const Text("Edit the Description/Solution"),
                  hintText: "Edit the Description/Solution",
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
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: (){
          Navigator.pop(context);
        },
            child: const Text("Cancel")
        ),
        TextButton(onPressed: (){
          if(_formEditKey.currentState!.validate()){
            ref.child(id).update({
              'title':edittitle.text.toString(),
              'desc':editval.text.toString()
            }).then((value){
              Utils().toastmessage("Solution Edited");
            }).onError((error, stackTrace){
              Utils().toastmessage(error.toString());
            });
            Navigator.pop(context);
          }
        },
            child: const Text("Update")
        ),
      ],
      );
  }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Color(0xFF4C53A5)
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Solutions",
          style: TextStyle(
              fontSize: 23,
              fontFamily: 'Squada',
              color: Color(0xFF4C53A5),
              fontWeight: FontWeight.bold
          ),
        ),
      ),
      body:
      ListView(
        children: [
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Form(
                          key:_formSignupKey,
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: const Text(
                                  "Add Solution",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                    color: Color(0xFF4C53A5),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10,),
                              TextFormField(
                                controller: addtitle,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter Title';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  label: const Text("Enter Disease Title"),
                                  hintText: "Title",
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
                              const SizedBox(height: 15,),
                              TextFormField(
                                controller: addval,
                                maxLines: 5,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter Description';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  label: const Text("Enter the Description/Solution"),
                                  hintText: "Enter the Description/Solution",
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
                              const SizedBox(height: 15,),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF4C53A5)
                                  ),
                                  onPressed: () {
                                    add();
                                  },
                                  child: loading?const CircularProgressIndicator(
                                    strokeWidth: 3 ,
                                    color: Colors.white,
                                  ): const Text(
                                    'Add',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
                      "Solutions Provided by you",
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
                          final title =snapshot.child('email').value.toString();
                          if(title.toLowerCase().contains(FirebaseAuth.instance.currentUser!.email.toString().toLowerCase())){
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
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
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
                                    PopupMenuButton(
                                      itemBuilder: (context)=>[
                                        PopupMenuItem(
                                          onTap: (){
                                            // Navigator.pop(context);
                                            showmydialog(
                                              snapshot.child('title').value.toString(),
                                              snapshot.child('desc').value.toString(),
                                              snapshot.child('id').value.toString(),
                                            );
                                          },
                                            value:1,
                                            child: const ListTile(
                                              leading: Icon(Icons.edit),
                                              trailing: Text("Edit"),
                                            )
                                        ),
                                        PopupMenuItem(
                                            onTap: (){
                                              ref.child(snapshot.child('id').value.toString()).remove();
                                            },
                                            value:2,

                                            child: const ListTile(
                                              leading: Icon(Icons.delete),
                                              trailing: Text("Delete"),
                                            )
                                        )
                                      ],
                                      icon: const Icon(Icons.more_horiz),
                                    )
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
