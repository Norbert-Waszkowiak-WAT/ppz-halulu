//Functions And Variabes
//przeróżne funkcje i zmienne tutaj, zeby byl wiekszy porzadek
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workflow_ro/logowanie.dart';
import 'package:workflow_ro/main.dart';



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

ListTile tab(String title, Icon leading, [List<Widget>? childrenz ]) {
  ListTile ret = ListTile(
    title: ExpansionTile(
      
      leading: leading,
        title: Text(
      title,
      
      style: Oswald(
        TextStyle(fontWeight: FontWeight.w800,color: textColor),
      ),
    ),
    children: (childrenz == null)? <Widget>[] : childrenz
    ),
  );

  return ret;
}
