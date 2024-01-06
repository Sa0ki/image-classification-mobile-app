import "package:flutter/material.dart";
import "package:image_prediction_ia/image_screen.dart";

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ImageScreen(),
    );
  }
}
