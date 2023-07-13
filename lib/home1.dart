import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'classifier_Q.dart';
import 'classifier_quant.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Classifier _classifier;

  var logger = Logger();

  File? _image;
  final picker = ImagePicker();

  Image? _imageWidget;

  img.Image? fox;

  Category? category;

  @override
  void initState() {
    super.initState();
    _classifier = ClassifierQuant();
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = File(pickedFile!.path);
      _imageWidget = Image.file(_image!);
      _predict();
    });
  }

  Future getGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile!.path);
      _imageWidget = Image.file(_image!);
      _predict();
    });
  }
  void _predict() async {
    img.Image imageInput = img.decodeImage(_image!.readAsBytesSync())!;
    var pred = _classifier.predict(imageInput);
    setState(() {
      category = pred;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool? _val;
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );
    AlertDialog alert = AlertDialog(
      title: const Text("Wrong Input"),
      content: const Text("There is no image of plant. Please choose the image again."),
      actions: [
        okButton,
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title:
        const Center(
          child: Text(
              'Plant Recognition',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w900,
              )
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/1.jpg"),
                fit: BoxFit.cover
            )
        ),
        child: Expanded(
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: const Color(0x882F6847)
                    ,borderRadius: BorderRadius.circular(10),
                    // border: Border.all(
                    //     width: 5,
                    //     color: const Color(0x7345BF1D)
                    // )
                ),
                child: Column(
                  children: [
                    Center(
                      child: _image == null
                          ? const Text(
                          ''
                      )
                          : Container(
                        constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height / 2.5),
                        decoration: BoxDecoration(
                            border: Border.all(width: 2,color: Colors.black87),
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: _imageWidget,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      category != null ? category!.label : 'No image selected.',
                      style: const TextStyle(color: Colors.white,fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      category != null
                          ? 'Confidence: ${(category!.score * 100).toInt()} %'
                          : '',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16
                      ),
                    ),
                    // const SizedBox(
                    //   height: 8,
                    // ),
                    GestureDetector(
                      onTap: (){
                        String b='https://www.google.com/search?q=${category!.label}';
                        if(category!=null && category!.label!='background'){
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Icon(Icons.travel_explore_outlined),
                                  content: const Text("Are you sure you want to open google for search."),
                                  actions: [
                                    TextButton(
                                      child: const Text("Cancel"),
                                      onPressed: () {
                                      Navigator.of(context, rootNavigator: true).pop('dialog');
                                    },
                                    ),
                                      TextButton(
                                      child: const Text("OK"),
                                      onPressed: () {
                                      setState(() {
                                        if (category==null || category!.label=='background'){
                                          // print("hey");
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return alert;
                                            },
                                          );
                                        }else {
                                          final Uri a = Uri.parse(b);
                                          launchUrl(a);
                                        }
                                      });
                                      Navigator.of(context, rootNavigator: true).pop('dialog');
                                      },
                                    ),
                                  ],
                                );
                              });
                        }

                      },
                      child:Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              color: Colors.greenAccent,
                            ),
                            borderRadius: BorderRadius.circular(20.0),

                          ),
                          color: const Color(0xFF112425),
                          margin: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 30
                          ),
                          child: const ListTile(
                            leading: Icon(
                              Icons.search,
                              color: Colors.white,),
                            title: Text(
                              "Search",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                              ),
                            ),
                          )
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: getImage,
                child: Card(
                  elevation: 5,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: Colors.greenAccent,
                      ),
                      borderRadius: BorderRadius.circular(20.0),

                    ),
                    color: const Color(0x002F6847),
                    margin: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 30
                    ),
                    child: const ListTile(
                      leading: Icon(
                        Icons.add_a_photo,
                        color: Colors.white,),
                      title: Text(
                        "Add from Camera",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                        ),
                      ),
                    )
                ),
              ),
              GestureDetector(
                onTap: getGallery,
                child: Card(
                  elevation: 5,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: Colors.greenAccent,
                      ),
                      borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
                    ),
                    // color: const Color(0xFF45BF1D)
                    color: const Color(0x002F6847),
                    margin: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 30
                    ),
                    child: const ListTile(
                      leading: Icon(
                        Icons.photo,
                        color: Colors.white,),
                      title: Text(
                        "Add from Gallery",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                        ),
                      ),
                    )
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}
