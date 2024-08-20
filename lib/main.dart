import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File? _image;
  late ImagePicker picker = ImagePicker();
  String result = 'Result will be show here';
  late ImageLabeler imageLabeler;

  @override
  void initState() {
    super.initState();
    picker = ImagePicker();
    final ImageLabelerOptions options = ImageLabelerOptions(confidenceThreshold: 0.5);
    imageLabeler = ImageLabeler(options: options);
  }


  imgFromGallery() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _image = File(image.path);
      setState(() {
        _image;
      });
      doImageLabeling();
    }
  }

  imgFromCamera() async {
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      _image = File(image.path);
      setState(() {
        _image;
      });
      doImageLabeling();

    }
  }

  doImageLabeling() async {
    InputImage inputImage = InputImage.fromFile(_image!);
    final List<ImageLabel> labels = await imageLabeler.processImage(inputImage);

    result = '';

    for (ImageLabel label in labels) {
      final String text = label.label;
      final int index = label.index;
      final double confidence = label.confidence;
      result += text + "       " + confidence.toStringAsFixed(2) + '\n';
    }
    setState(() {
      return;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _image == null
                  ? Icon(
                      Icons.image,
                      size: 200,
                    )
                  : Image.file(
                      _image!,
                      width: 200,
                      height: 200,
                    ),
              ElevatedButton(
                onPressed: () {
                  imgFromGallery();
                },
                onLongPress: () {
                  imgFromCamera();
                },
                child: Text('Capture/Choose'),
              ),
              Text(result)
            ],
          ),
        ),
      ),
    );
  }
}
