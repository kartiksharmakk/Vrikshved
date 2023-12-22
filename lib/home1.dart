import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:plant_rec/widget/HomeAppBar.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'classifier_Q.dart';
import 'classifier_quant.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_rec/Controller/language_change_controller.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

enum Language { english, hindi, punjabi }

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
    // bool? _val;
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );
    AlertDialog alert = AlertDialog(
      title: const Text("Wrong Input"),
      content: const Text(
          "There is no image of plant. Please choose the image again."),
      actions: [
        okButton,
      ],
    );
    return Scaffold(
      body: ListView(
        children: [
          HomeAppBar(),
          Container(
            padding: const EdgeInsets.only(top: 10),
            decoration: const BoxDecoration(
                color: Color(0xFFEDECF2),
                borderRadius: BorderRadius.all(Radius.circular(35))),
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    // color: const Color(0xFFE9E9DE),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    // border: Border.all(
                    //     width: 5,
                    //     color: const Color(0x9145BF1D)
                    // )
                  ),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 10),
                        child: Text(
                          AppLocalizations.of(context)!.h1_plantrec,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Color(0xFF4C53A5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: _image == null
                            ? const Text('')
                            : Container(
                                constraints: BoxConstraints(
                                    maxHeight:
                                        MediaQuery.of(context).size.height /
                                            2.5),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2, color: Colors.black87),
                                    borderRadius: BorderRadius.circular(5)),
                                child: _imageWidget,
                              ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        category != null
                            ? category!.label
                            : AppLocalizations.of(context)!.h1_noimageselected,
                        style: const TextStyle(
                            color: Color(0xFF4C53A5),
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        category != null
                            ? 'Confidence: ${(category!.score * 100).toInt()} %'
                            : '',
                        style: const TextStyle(
                            color: Color(0xFF4C53A5), fontSize: 16),
                      ),
                      // const SizedBox(
                      //   height: 8,
                      // ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          String b =
                              'https://www.google.com/search?q=${category!.label}';
                          if (category != null &&
                              category!.label != 'background') {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Icon(
                                        Icons.travel_explore_outlined),
                                    content: const Text(
                                        "Are you sure you want to open google for search."),
                                    actions: [
                                      TextButton(
                                        child: const Text("Cancel"),
                                        onPressed: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop('dialog');
                                        },
                                      ),
                                      TextButton(
                                        child: const Text("OK"),
                                        onPressed: () {
                                          setState(() {
                                            if (category == null ||
                                                category!.label ==
                                                    'background') {
                                              // print("hey");
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return alert;
                                                },
                                              );
                                            } else {
                                              final Uri a = Uri.parse(b);
                                              launchUrl(a);
                                            }
                                          });
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop('dialog');
                                        },
                                      ),
                                    ],
                                  );
                                });
                          }
                        },
                        child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(color: Color(0xFF4C53A5)),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            color: Color(0xFF4C53A5),
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 30),
                            child: ListTile(
                              leading: Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                              title: Text(
                                AppLocalizations.of(context)!.h1_searchonnet,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            )),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: getImage,
                  child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          color: Color(0xFF4C53A5),
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      color: Color(0xFF4C53A5),
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 30),
                      child: ListTile(
                        leading: Icon(
                          Icons.add_a_photo,
                          color: Colors.white,
                        ),
                        title: Text(
                          AppLocalizations.of(context)!.h1_takepic,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      )),
                ),
                GestureDetector(
                  onTap: getGallery,
                  child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          color: Color(0xFF4C53A5),
                        ),
                        borderRadius:
                            BorderRadius.circular(20.0), //<-- SEE HERE
                      ),
                      // color: const Color(0xFF45BF1D)
                      color: Color(0xFF4C53A5),
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 30),
                      child: ListTile(
                        leading: Icon(
                          Icons.photo,
                          color: Colors.white,
                        ),
                        title: Text(
                          AppLocalizations.of(context)!.h1_picgallery,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      )),
                ),
                const SizedBox(height: 20),
              ],
            ),
          )
        ],
      ),
    );
  }
}
