import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:social_media_app/ml_kit/ml_kit_text_recognition.dart';

class TextDetectionBloc extends ChangeNotifier {
  File? chooseImageFile;
  final MLKitTextRecognition _mlKitTextRecognition = MLKitTextRecognition();

  onImageChosen(File imageFile, Uint8List bytes) {
    chooseImageFile = imageFile;
    _mlKitTextRecognition.detectTexts(imageFile);
    notifyListeners();
  }
}
