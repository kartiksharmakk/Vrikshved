

import 'package:tflite_flutter/tflite_flutter.dart';

class ClassifierModel {
  Interpreter interpreter;

  List<int> inputShape;
  List<int> outputShape;

  TfLiteType inputType;
  TfLiteType outputType;

  ClassifierModel({
    required this.interpreter,
    required this.inputShape,
    required this.outputShape,
    required this.inputType,
    required this.outputType,
  });
}
