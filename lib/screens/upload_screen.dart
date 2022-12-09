import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

import '../services/auth.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _UploadImageScreen();
  }
}

class _UploadImageScreen extends State<UploadImageScreen> {
  final AuthService _auth = new AuthService();
  late File _image;
  late List _results;
  bool imageSelect = false;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future loadModel() async {
    Tflite.close();
    String res;
    res = (await Tflite.loadModel(
        model: "assets/model.tflite", labels: "assets/labels.txt"))!;
    print("Models loading status: $res");
/*    FirebaseModelDownloader.instance
        .getModel(
            "Object-Detector",
            FirebaseModelDownloadType.localModel,
            FirebaseModelDownloadConditions(
              iosAllowsCellularAccess: true,
              iosAllowsBackgroundDownloading: false,
              androidChargingRequired: false,
              androidWifiRequired: false,
              androidDeviceIdleRequired: false,
            ))
        .then((customModel) {
      // Download complete. Depending on your app, you could enable the ML
      // feature, or switch from the local model to the remote model, etc.

      // The CustomModel object contains the local path of the model file,
      // which you can use to instantiate a TensorFlow Lite interpreter.
      final localModelPath = customModel.file;

      // ...
    });*/
  }

  Future imageClassification(File image) async {
    final List? recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _results = recognitions!;
      _image = image;
      imageSelect = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SingleChildScrollView(
        child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //if (imageSelect) const CircularProgressIndicator(),
                (!imageSelect)
                    ? Container(
                        width: 300,
                        height: 300,
                        color: Colors.grey[300]!,
                      )
                    : Image.file(_image),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.grey,
                            shadowColor: Colors.grey[400],
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                          ),
                          onPressed: () {
                            pickImage(ImageSource.gallery);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.image,
                                  size: 30,
                                  color: Colors.red,
                                ),
                                Text(
                                  "Gallery",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        )),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.grey,
                            shadowColor: Colors.grey[400],
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                          ),
                          onPressed: () {
                            pickImage(ImageSource.camera);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.camera_alt,
                                  size: 30,
                                  color: Colors.red,
                                ),
                                Text(
                                  "Camera",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        )),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: (imageSelect)
                      ? _results.map((result) {
                          return Card(
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: Text(
                                "${result['label']} - ${result['confidence'].toStringAsFixed(2)}",
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 20),
                              ),
                            ),
                          );
                        }).toList()
                      : [],
                ),
              ],
            )),
      )),
    );
  }

  Future pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    File image = File(pickedFile!.path);
    if (pickedFile != null) {
      imageSelect = true;
      _auth
          .uploadFile(pickedFile.path, pickedFile.name)
          .then((value) => print('Done'));
      setState(() {});
      imageClassification(image);
    }
  }

/*void getImageLabels(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    ImageLabeler imageLabeler = ImageLabeler(options: ImageLabelerOptions());
    List<ImageLabel> labels = await imageLabeler.processImage(inputImage);
    StringBuffer sb = StringBuffer();
    for (ImageLabel imgLabel in labels) {
      String lblText = imgLabel.label;
      double confidence = imgLabel.confidence;
      sb.write(lblText);
      sb.write(" : ");
      sb.write((confidence * 100).toStringAsFixed(2));
      sb.write("%\n");
    }
    imageLabeler.close();
    imageLabel = sb.toString();
    imageSelect = false;
    setState(() {});
  }*/
}

/**
 * return Scaffold(
    body: ListView(
    children: [
    (imageSelect)
    ? Container(
    margin: const EdgeInsets.all(10),
    child: Image.file(_image),
    )
    : Container(
    margin: const EdgeInsets.all(10),
    child: const Opacity(
    opacity: 0.8,
    child: Center(
    child: Text("No image selected"),
    ),
    ),
    ),
    SingleChildScrollView(
    child: Column(
    children: (imageSelect)
    ? _results.map((result) {
    return Card(
    child: Container(
    margin: EdgeInsets.all(10),
    child: Text(
    "${result['label']} - ${result['confidence'].toStringAsFixed(2)}",
    style: const TextStyle(
    color: Colors.red, fontSize: 20),
    ),
    ),
    );
    }).toList()
    : [],
    ),
    ),
    IconButton(
    onPressed: () {
    pickImage(ImageSource.camera);
    },
    icon: Icon(Icons.camera_alt)),
    Center(
    child: ElevatedButton(
    child: Text('Upload File'),
    onPressed: (){
    pickImage(ImageSource.gallery);
    },
    ),
    ),
    ],
    ),
    );
 */
