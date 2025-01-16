import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workflow_ro/fav.dart';
import 'package:workflow_ro/logowanie.dart';
import 'package:workflow_ro/main.dart';
import 'package:invert_colors/invert_colors.dart';
import 'package:workflow_ro/registerCompany.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class profileScreen extends StatefulWidget {
  final User user;
  const profileScreen({super.key, required this.user});

  @override
  State<profileScreen> createState() => _profileScreenState(user);
}

//Funkcja znajduje nazwe uzytkownika w firestore uzywajac przy tym emailu zalogowanego uzytkownika

class _profileScreenState extends State<profileScreen> {
  User user;
  _profileScreenState(this.user);
  String username = "Username_not_found";
  bool darkMode = false;

  @override
  void initState() {
    
    username = localUser!.username;
     
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: background,
          appBar:
              defaultAppBar(context, registerCompScreen(user: user), "Profil"),
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
                    (!darkMode)
                        ? CircleAvatar(
                            radius: screenHeight * 0.095,
                            backgroundColor: background,
                            backgroundImage: NetworkImage(
                                "https://img.myloview.com/stickers/default-avatar-profile-icon-vector-social-media-user-image-700-205124837.jpg"),
                          )
                        : InvertColors(
                            child: CircleAvatar(
                              radius: screenHeight * 0.095,
                              backgroundColor: background,
                              backgroundImage: NetworkImage(
                                  "https://img.myloview.com/stickers/default-avatar-profile-icon-vector-social-media-user-image-700-205124837.jpg"),
                            ),
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
                      fontWeight: FontWeight.w700,
                      color: textColor)),
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
                    children: [
                      tab(
                        "Ustawienia",
                        Icon(Icons.settings),
                        <Widget>[
                          Column(
                            children: [
                              SizedBox(
                                height: screenHeight * 0.02,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey)),
                                child: ListTile(
                                  leading: Icon(Icons.brightness_4),
                                  title: Text(
                                    "Tryb Ciemny",
                                    style: Oswald(TextStyle(color: textColor)),
                                  ),
                                  trailing: Checkbox(
                                      value: darkMode,
                                      onChanged: (bool? val) {
                                        setState(() {
                                          if (val != null) darkMode = val;

                                          if (darkMode) {
                                            background = darkThemeBackground;
                                            textColor = darkThemeText;
                                          } else {
                                            background = lightThemeBackground;
                                            textColor = lightThemeText;
                                          }
                                        });
                                      }),
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.02,
                              ),
                            ],
                          )
                        ],
                      ),
                      tab("Informacje", Icon(Icons.info)),
                      tab("cos tam", Icon(Icons.question_mark))
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.11,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (c, a1, a2) => logowanieScreen(),
                        transitionsBuilder: (c, anim, a2, child) =>
                            FadeTransition(opacity: anim, child: child),
                        transitionDuration: Duration(milliseconds: 500),
                      ),
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: screenWidth * 0.8,
                    height: screenHeight * 0.08,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.red,
                        border: Border.all(color: secColor, width: 1)),
                    child: Text(
                      "Wyloguj",
                      style: Oswald(TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 32,
                          color: textColor)),
                    ),
                  ),
                )
              ],
            ),
          )),
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
