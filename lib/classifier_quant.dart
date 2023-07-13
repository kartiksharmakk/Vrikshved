import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

import 'classifier_Q.dart';

class ClassifierQuant extends Classifier {
  ClassifierQuant({int numThreads = 1}) : super(numThreads: numThreads);

  @override
  String get modelName => 'lite-model_aiy_vision_classifier_plants_V1_3.tflite';

  @override
  NormalizeOp get postProcessNormalizeOp => NormalizeOp(0, 255);
}
