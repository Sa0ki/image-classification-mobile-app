import "dart:io";

import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "package:tflite_v2/tflite_v2.dart";

class ImageScreen extends StatefulWidget {
  const ImageScreen({Key? key}) : super(key: key);

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  bool imageSelected = false;
  late File _image;
  late List _results;
  final ImagePicker imagePicker = ImagePicker();

  @override
  void initState(){
    loadModel();
  }

  Future<void> loadImage() async {
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    classifyImage(File(pickedImage!.path));
  }

  Future<void> loadModel() async {
    String result = (await Tflite.loadModel(model: "assets/model.tflite", labels: "assets/labels.txt"))!;
    print("Model is available, status: $result");
  }

  Future<void> classifyImage(File img) async {
    var response = await Tflite.runModelOnImage(
      path: img.path,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
      numResults: 6
    );
    setState(() {
      _results = response!;
      _image = img;
      imageSelected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text("Image classification", style: TextStyle(color: Colors.white)),
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.all(5),
            child:  Column(
              children: [
                const SizedBox(height: 20),
                (imageSelected) ? Image.file(_image) : const CircularProgressIndicator()
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(5),
            child: Column(
                children:
                (imageSelected) ? _results.map((object){
                  return Card(
                    child: Text("${object["label"]}: ${object["confidence"].toStringAsFixed(3)}", style: const TextStyle(color: Colors.black, fontSize: 20)),
                    elevation: 10,
                  );
                }).toList() : []
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: loadImage,
        backgroundColor: Colors.lightBlue,
        child: const Icon(Icons.image),
      ),
    );
  }
}
