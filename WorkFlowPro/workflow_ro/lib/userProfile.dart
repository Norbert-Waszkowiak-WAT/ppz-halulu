import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workflow_ro/appAdmin.dart';
import 'package:workflow_ro/fav.dart';
import 'package:workflow_ro/main.dart';
import 'package:google_fonts/google_fonts.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class profileScreen extends StatefulWidget {
  final User user;
  const profileScreen({super.key, required this.user});

  @override
  State<profileScreen> createState() => _profileScreenState(user);
}

class _profileScreenState extends State<profileScreen> {
  User user;
  _profileScreenState(this.user);
  String username = "Username_not_found";

  @override
  void initState() {
    userToUsername(user).then((result) {
      setState(() {
        username = result;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: background,
          appBar: AppBar(
              title: Text(
                "Profil",
                style: Oswald(),
              ),
              centerTitle: true,
              backgroundColor: background,
              elevation: 2),
          body: Container(
            width: screenWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                Stack(
                  alignment: AlignmentDirectional.bottomEnd,
                  children: [
                    CircleAvatar(
                      radius: screenHeight * 0.095,
                      backgroundImage: NetworkImage(
                          "https://img.myloview.com/stickers/default-avatar-profile-icon-vector-social-media-user-image-700-205124837.jpg"),
                    ),
                    Positioned(
                      right: screenHeight * 0.0225,
                      bottom: screenHeight * 0.0225,
                      child: GestureDetector(
                        onTap: () {},
                        child: CircleAvatar(
                          radius: screenHeight * 0.02,
                          backgroundColor: primColor,
                          child: Icon(Icons.edit),
                        ),
                      ),
                    )
                  ],
                ),
                Text(
                  username,
                  style: Oswald(TextStyle(
                      fontSize: screenWidth * 0.075,
                      fontWeight: FontWeight.w700)),
                ),
                SizedBox(
                  height: screenHeight * 0.002,
                ),
                Text(user.email!),
                SizedBox(
                  height: screenHeight * 0.075,
                ),
                Container(
                  height: screenHeight * 0.3,
                  width: screenWidth * 0.9,
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      tab("Ustawienia", Icon(Icons.settings)),
                      tab("Informacje", Icon(Icons.info)),
                      tab("cos tam", Icon(Icons.question_mark))
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.11,
                ),
                Container(
                  alignment: Alignment.center,
                  width: screenWidth * 0.8,
                  height: screenHeight * 0.08,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.red,
                    border: Border.all(color: secColor, width: 1)
                  ),
                  child: Text("Wyloguj", style: Oswald(TextStyle(fontWeight: FontWeight.w900, fontSize: 32)),),
                )
              ],
            ),
          )),
    );
  }
}

