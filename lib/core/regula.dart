import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_face_api/flutter_face_api.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class RegulaFaceRecognition {
  static FaceSDK faceSDK = FaceSDK.instance;
  static MatchFacesImage? cameraImage;
  static String timeInConfidence = ' ';
  static String timeOutConfidence = ' ';
  static bool isFaceDetected = true;
  static initialize() async {
    log("initialize cld");
    var (success, error) = await faceSDK.initialize();
    if (!success) {
      error!.message;
      log("${error.code}: ${error.message}");
    }
  }

  static Future<File?> openCamera() async {
    await initialize();
    log("open camera cld");
    File? imgPath;
    await faceSDK.startFaceCapture().then((result) async {
      var image = result.image;
      if (image != null) {
        imgPath = await setImage(image.image, image.imageType);
      }
    });
    return imgPath;
  }

  static Future<File?> setImage(Uint8List imageFile, ImageType type) async {
    cameraImage = MatchFacesImage(imageFile, type);
    String dir = (await getApplicationDocumentsDirectory()).path;
    var tempImageName =
        "regulaImg_${DateFormat("yyyyMMdd_HHmmss", "en_US").format(DateTime.now())}_${DateTime.now().millisecondsSinceEpoch}.jpg";
    File file = await File("$dir/$tempImageName").create();
    final Uint8List bytes = imageFile.buffer.asUint8List();
    await file.writeAsBytes(bytes);
    return file;
  }
}
