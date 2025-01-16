// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workflow_ro/fav.dart';
import 'package:workflow_ro/main.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class appAdminScreen extends StatefulWidget {
  final User user;
  const appAdminScreen({super.key, required this.user});

  @override
  State<appAdminScreen> createState() => _appAdminScreenState(user);
}

//Funkcja znajduje nazwe uzytkownika w firestore uzywajac przy tym emailu zalogowanego uzytkownika

class _appAdminScreenState extends State<appAdminScreen> {
  late User user;
  _appAdminScreenState(this.user);
  String username = "Username_not_found";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            children: [
              SizedBox(height: screenHeight *0.05,),
              Row(
                children: [
                  SizedBox(width: screenWidth * 0.08,),
                  Container(
                    width: screenWidth*0.4,
                    height: screenWidth*0.4,
                    decoration: BoxDecoration(
                        color: Colors.blue, shape: BoxShape.circle),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

Size _textSize(String text, TextStyle style) {
  final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr)
    ..layout(minWidth: 0, maxWidth: double.infinity);
  return textPainter.size;
}
