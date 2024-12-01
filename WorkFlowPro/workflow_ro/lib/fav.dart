//Functions And Variabes
//przeróżne funkcje i zmienne tutaj, zeby byl wiekszy porzadek
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workflow_ro/main.dart';
import 'package:workflow_ro/userProfile.dart';

Color lightThemeBackground = const Color.fromARGB(255, 251, 254, 249);
Color lightThemeText = const Color.fromARGB(255, 0, 0, 4);

Color darkThemeBackground = const Color.fromARGB(255, 0, 0, 4);
Color darkThemeText = const Color.fromARGB(255, 251, 254, 249);

TextStyle Oswald([TextStyle TS = const TextStyle()]) {
  TextStyle ret = GoogleFonts.oswald(textStyle: TS);
  return ret;
}

Future<String> userToUsername(User user) async {
  final usersBase = db.collection("uzytkownicy");
  final userProf = usersBase.doc(user.email);
  String usrname = "";
  await userProf.get().then((DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    usrname = data["username"] as String;
  });
  return usrname;
}

ListTile tab(String title, Icon leading, [List<Widget>? childrenz]) {
  ListTile ret = ListTile(
    title: ExpansionTile(
        leading: leading,
        title: Text(
          title,
          style: Oswald(
            TextStyle(fontWeight: FontWeight.w800, color: textColor),
          ),
        ),
        children: (childrenz == null) ? <Widget>[] : childrenz),
  );

  return ret;
}

AppBar defaultAppBar(context, screen, String title) {
  return AppBar(
      leading: IconButton(
          onPressed: () {
            {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (c, a1, a2) => screen,
                  transitionsBuilder: (c, anim, a2, child) =>
                      FadeTransition(opacity: anim, child: child),
                  transitionDuration: Duration(milliseconds: 500),
                ),
              );
            }
          },
          icon: Icon(Icons.arrow_back)),
      title: Text(title, style: Oswald(TextStyle(color: textColor))),
      centerTitle: true,
      backgroundColor: background,
      elevation: 2);
}

class formField {
  String fieldName;
  bool required;
  bool obscured = false;
  int maxLen = 32;
  formField(this.fieldName, this.required,
      {this.obscured = false, this.maxLen = 32});
}

List<formField> orgFormFields = [
  (formField("Adres Firmy", true)),
  (formField("Email Kontaktowy", true)),
  (formField("Numer Kontaktowy", true)),
  (formField("Adres Strony", false)),
  (formField("NIP/REGON", false)),
  (formField("Rodzaj Działalności", false)),
];

List<formField> adminFormFields = [
  (formField("Login", true)),
  (formField("Hasło", true, obscured: true)),
  (formField("Adres Email", true)),
  (formField("Numer Kontaktowy", false)),
  (formField("Stanowisko", true)),
];

Column form(
  String title,
  List<formField> fieldsList
) {
  return Column(children: [
    Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 2, color: Colors.grey))),
      child: Text(
        title,
        style: Oswald(TextStyle(
            fontWeight: FontWeight.w800, fontSize: screenHeight * 0.025)),
      ),
    ),
    SizedBox(
      height: screenHeight * 0.01,
    ),
    for (var field in fieldsList) ...[
      Container(
        decoration: BoxDecoration(
            color: Colors.grey,
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(16)),
        width: screenWidth * 0.9,
        height: screenHeight * 0.05,
        child: TextField(
          textAlign: TextAlign.center,
          decoration: InputDecoration(
              hintText: field.fieldName, border: InputBorder.none),
        ),
      ),
      SizedBox(
        height: screenHeight * 0.01,
      ),
    ],
  ]);
}
