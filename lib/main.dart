import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

import 'modules/layout/view/layout_view.dart';

void main() {
  runApp(DevicePreview (

      builder:   (context) => MyApp() ,
    enabled: true,

  ));
}
  
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const category(),
    );
  }
}


