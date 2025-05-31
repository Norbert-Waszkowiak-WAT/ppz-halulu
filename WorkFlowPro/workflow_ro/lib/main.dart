import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:workflow_ro/logowanie.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:workflow_ro/projects.dart';

final navigatorKey = GlobalKey<NavigatorState>();
Map<String, String>? pendingRedirect;
Future<void> handleBackgroundMessage(RemoteMessage message) async{
   if (message.data['screen'] == 'projects') {
    pendingRedirect = {
      'date': message.data['projectDate'],
    };
  }

  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('PL: ${message.data}');
}

void handleMessage(RemoteMessage? message){
  if(message == null) return;

  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('PL: ${message.data}');
  
   if (message.data['screen'] == 'projects') {
    pendingRedirect = {
      'date': message.data['projectDate'],
    };
  }
  print("here");
  print(pendingRedirect);

}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //MobileAds.instance.initialize();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.requestPermission();
  FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
  FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
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
      navigatorKey: navigatorKey,
      title: 'WorkFlowPro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const logowanieScreen(),
    );
  }
}
