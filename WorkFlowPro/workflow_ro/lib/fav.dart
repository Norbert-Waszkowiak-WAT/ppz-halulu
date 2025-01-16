//Functions And Variabes
//przeróżne funkcje i zmienne tutaj, zeby byl wiekszy porzadek
// ignore_for_file: unused_import

import 'dart:ffi';

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

class localUserData {
  String username;
  String email;
  bool admin = false;
  String nazwaFirmy;
  int numerKontaktowy;
  String stanowisko;
  localUserData(this.username, this.email, this.nazwaFirmy,
      this.numerKontaktowy, this.stanowisko,
      {this.admin = false});
}

Future<localUserData> userToUserData(User user) async {
  DocumentSnapshot userDoc =
      await db.collection("uzytkownicy").doc(user.email).get();
  localUserData ret = localUserData(
      userDoc["Login"],
      userDoc["Adres Email"],
      userDoc["Nazwa Firmy"],
      userDoc["Numer Kontaktowy"],
      userDoc["Stanowisko"],
      admin: (userDoc["Administrator"] == "true") ? true : false);

  return ret;
}

//zmienna przechowująca dane zalogowanego uzytkownika; działa poprawnie dopiero po zalogowaniu
localUserData? localUser;

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
  String type = "S";
  bool required;
  bool obscured = false;
  TextEditingController inpCtrl = TextEditingController();
  int maxLen = 32;
  formField(this.fieldName, this.required, this.type,
      {this.obscured = false, this.maxLen = 32});
}

List<formField> orgFormFields = [
  (formField("Adres Firmy", true, 'S')),
  (formField("Email Kontaktowy", true, 'S')),
  (formField("Numer Kontaktowy", true, 'I')),
  (formField("Adres Strony", false, 'S')),
  (formField("NIP/REGON", false, 'I')),
  (formField("Rodzaj Działalności", false, 'S')),
];

List<formField> adminFormFields = [
  (formField("Login", true, 'S')),
  (formField("Hasło", true, obscured: true, 'S')),
  (formField("Adres Email", true, 'S')),
  (formField("Numer Kontaktowy", false, 'I')),
  (formField("Stanowisko", true, 'S')),
];

List<formField> userFormFields = [
  (formField("Login", true, 'S')),
  (formField("Hasło", true, obscured: true, 'S')),
  (formField("Adres Email", true, 'S')),
  (formField("Numer Kontaktowy", false, 'I')),
  (formField("Stanowisko", true, 'S')),
];

Column form(String title, List<formField> fieldsList) {
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
          controller: field.inpCtrl,
        ),
      ),
      SizedBox(
        height: screenHeight * 0.01,
      ),
    ],
  ]);
}

Map<String, dynamic> formToMap(List<formField> form) {
  final Map<String, dynamic> ret = {};
  for (var field in form) {
    if (field.type == "S") {
      ret[field.fieldName] = field.inpCtrl.text;
    } else if (field.type == "I") {
      ret[field.fieldName] = int.parse(field.inpCtrl.text);
    } else if (field.type == "B") {
      ret[field.fieldName] = (field.inpCtrl.text == '1') ? true : false;
    } else
      ret[field.fieldName] = field.inpCtrl.text;
  }
  return ret;
}

bool addUserToOrg(
    FirebaseFirestore db, String compName, List<formField> UserData) {
  try {
    db
        .collection("organizacje")
        .doc(compName)
        .collection("users")
        .doc(UserData[0].inpCtrl.text)
        .set(formToMap(UserData));
  } catch (e) {
    print(e);
    return false;
  }
  return true;
}

bool addUserToCompany(
    FirebaseFirestore db1, String compName, List<formField> UserData) {
  List<formField> usersUpdate = [];
  for (var f in UserData) {
    usersUpdate.add(f);
  }
  //dodawanie pól niezbędnych w bazie a niezaleznych od inputu uzytkownika
  usersUpdate.add(formField("wfp_admin", false, "B"));
  usersUpdate[usersUpdate.length - 1].inpCtrl.text = "0";
  usersUpdate.add(formField("Nazwa Firmy", false, "S"));
  usersUpdate[usersUpdate.length - 1].inpCtrl.text = compName;
  usersUpdate.add(formField("Administrator", false, "B"));
  usersUpdate[usersUpdate.length - 1].inpCtrl.text = "0";

  try {
    db1
        .collection("organizacje")
        .doc(localUser!.nazwaFirmy)
        .collection("users")
        .doc(UserData[0].inpCtrl.text)
        .set(formToMap(usersUpdate));
  } catch (e) {
    print("Problemos");
    print(e);
    return false;
  }
  return true;
}

bool addUserToUsers(
    FirebaseFirestore db1, String compName, List<formField> UserData) {
  List<formField> usersUpdate = [];
  for (var f in UserData) {
    usersUpdate.add(f);
  }
  // UserData;
  //dodawanie pól niezbędnych w bazie a niezaleznych od inputu uzytkownika
  usersUpdate.add(formField("wfp_admin", false, "B"));
  usersUpdate[usersUpdate.length - 1].inpCtrl.text = "0";
  usersUpdate.add(formField("Nazwa Firmy", false, "S"));
  usersUpdate[usersUpdate.length - 1].inpCtrl.text = compName;
  usersUpdate.add(formField("Administrator", false, "B"));
  usersUpdate[usersUpdate.length - 1].inpCtrl.text = "0";

  try {
    db1
        .collection("uzytkownicy")
        .doc(UserData[2].inpCtrl.text)
        .set(formToMap(usersUpdate));
  } catch (e) {
    print("Problemos");
    print(e);
    return false;
  }
  return true;
}
