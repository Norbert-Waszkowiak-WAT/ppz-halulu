import 'package:flutter/material.dart';
import 'package:workflow_ro/logowanie.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //MobileAds.instance.initialize();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

double screenWidth = 0;
double screenHeight = 0;
Color primColor  = const Color.fromARGB(255, 0, 183, 255);
Color primShade  = const Color.fromARGB(255, 5, 0, 146);
Color secColor   = const Color.fromARGB(255, 73, 77, 80);
Color background = const Color.fromARGB(255, 251, 254, 249);
Color textColor  = const Color.fromARGB(255, 0, 0, 4);


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      title: 'WorkFlowPro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const logowanieScreen(),
    );
  }
}
