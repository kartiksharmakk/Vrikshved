import 'dart:io';

// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../classifier/classifier.dart';
import '../styles.dart';
import 'HomeAppBar.dart';
import 'plant_photo_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

//const _labelsFileName = 'assets/labels.txt';
//const _modelFileName = 'model_unquant.tflite';
const _labelsFileName = 'assets/labels_plane_village.txt';
const _modelFileName = 'plant_village.tflite';

class PlantRecogniser extends StatefulWidget {
  const PlantRecogniser({super.key});

  @override
  State<PlantRecogniser> createState() => _PlantRecogniserState();
}

enum _ResultStatus {
  notStarted,
  notFound,
  found,
}

class _PlantRecogniserState extends State<PlantRecogniser> {
  bool _isAnalyzing = false;
  final picker = ImagePicker();
  File? _selectedImageFile;

  // Result
  _ResultStatus _resultStatus = _ResultStatus.notStarted;
  String _plantLabel = ''; // Name of Error Message
  double _accuracy = 0.0;

  late Classifier _classifier;

  @override
  void initState() {
    super.initState();
    _loadClassifier();
  }

  Future<void> _loadClassifier() async {
    debugPrint(
      'Start loading of Classifier with '
      'labels at $_labelsFileName, '
      'model at $_modelFileName',
    );

    final classifier = await Classifier.loadWith(
      labelsFileName: _labelsFileName,
      modelFileName: _modelFileName,
    );
    _classifier = classifier!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        // mainAxisSize: MainAxisSize.max,
        children: [
          const HomeAppBar(),
          Container(
            padding: const EdgeInsets.only(top: 10),
            decoration: const BoxDecoration(
                color: Color(0xFFEDECF2),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                )),
            child: Container(
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
                      AppLocalizations.of(context)!.pr_dieasedetection,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Color(0xFF4C53A5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildPhotolView(),
                  const SizedBox(height: 10),
                  _buildResultView(),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          Container(
            color: const Color(0xFFEDECF2),
            height: 20,
          ),
          _buildPickPhotoButton(
              titleval: AppLocalizations.of(context)!.h1_takepic,
              source: ImageSource.camera,
              iconval: Icons.add_a_photo),
          _buildPickPhotoButton(
              titleval: AppLocalizations.of(context)!.h1_picgallery,
              source: ImageSource.gallery,
              iconval: Icons.photo),
          Container(
            height: 20,
            decoration: const BoxDecoration(
                color: Color(0xFFEDECF2),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
          )
          // const Spacer(flex: ,),
        ],
      ),
    );
  }

  Widget _buildPhotolView() {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        PlantPhotoView(file: _selectedImageFile),
        _buildAnalyzingText(),
      ],
    );
  }

  Widget _buildAnalyzingText() {
    if (!_isAnalyzing) {
      return const SizedBox.shrink();
    }
    return const Text('Analyzing...', style: kAnalyzingTextStyle);
  }

  Widget _buildPickPhotoButton(
      {required ImageSource source,
      required String titleval,
      required IconData iconval}) {
    return Container(
      color: const Color(0xFFEDECF2),
      child: GestureDetector(
        onTap: () => _onPickPhoto(source),
        child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                color: Colors.greenAccent,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            // color: const Color(0xFF45BF1D),
            color: const Color(0xFF4C53A5),
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            child: ListTile(
              leading: Icon(
                iconval,
                color: Colors.white,
              ),
              title: Text(
                titleval,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            )),
      ),
    );
  }

  void _setAnalyzing(bool flag) {
    setState(() {
      _isAnalyzing = flag;
    });
  }

  void _onPickPhoto(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile == null) {
      return;
    }

    final imageFile = File(pickedFile.path);
    setState(() {
      _selectedImageFile = imageFile;
    });

    _analyzeImage(imageFile);
  }

  void _analyzeImage(File image) {
    _setAnalyzing(true);

    final imageInput = img.decodeImage(image.readAsBytesSync())!;

    final resultCategory = _classifier.predict(imageInput);

    final result = resultCategory.score >= 0.8
        ? _ResultStatus.found
        : _ResultStatus.notFound;
    final plantLabel = resultCategory.label;
    final accuracy = resultCategory.score;

    _setAnalyzing(false);

    setState(() {
      _resultStatus = result;
      _plantLabel = plantLabel;
      _accuracy = accuracy;
    });
  }

  Widget _buildResultView() {
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
    var title = '';

    if (_resultStatus == _ResultStatus.notFound) {
      title = 'Fail to recognise';
    } else if (_resultStatus == _ResultStatus.found) {
      title = _plantLabel;
    } else {
      title = '';
    }

    //
    var accuracyLabel = '';
    if (_resultStatus == _ResultStatus.found) {
      accuracyLabel = 'Accuracy: ${(_accuracy * 100).toStringAsFixed(2)}%';
    }

    return Column(
      children: [
        Text(title, style: kResultTextStyle),
        const SizedBox(height: 10),
        Text(accuracyLabel, style: kResultRatingTextStyle),
        GestureDetector(
          onTap: () {
            String b = 'https://www.google.com/search?q=$title';
            if (title != '') {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Icon(Icons.travel_explore_outlined),
                      content: const Text(
                          "Are you sure you want to open google for search."),
                      actions: [
                        TextButton(
                          child: const Text("Cancel"),
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true)
                                .pop('dialog');
                          },
                        ),
                        TextButton(
                          child: const Text("OK"),
                          onPressed: () {
                            setState(() {
                              if (title == '') {
                                // print("hey");
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return alert;
                                  },
                                );
                              } else {
                                final Uri a = Uri.parse(b);
                                launchUrl(a);
                              }
                            });
                            Navigator.of(context, rootNavigator: true)
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
                side: const BorderSide(
                  color: Color(0xFF4C53A5),
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              color: const Color(0xFF4C53A5),
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
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
      ],
    );
  }
}
