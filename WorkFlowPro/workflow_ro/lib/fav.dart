//Functions And Variabes
//przeróżne funkcje i zmienne tutaj, zeby byl wiekszy porzadek
// ignore_for_file: unused_import

import 'dart:async';
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
  bool admin;
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
  print("CzyAdmin? ${userDoc["Administrator"]}");
  localUserData ret = localUserData(
    userDoc["Login"],
    userDoc["Adres Email"],
    userDoc["Nazwa Firmy"],
    userDoc["Numer Kontaktowy"],
    userDoc["Stanowisko"],
    admin: userDoc["Administrator"],
  );

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

AppBar defaultAppBar(context, String title) {
  return AppBar(
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

String formatTimestamp(dynamic timestamp) {
  if (timestamp is Timestamp) {
    DateTime date = timestamp.toDate();
    String day = date.day.toString().padLeft(2, '0'); // Dodanie zera do dnia
    String month =
        date.month.toString().padLeft(2, '0'); // Dodanie zera do miesiąca
    String year = date.year.toString();

    return "$day.$month.$year";
  }
  return "Brak daty";
}

Future<bool> aus(context, String text, {bool def = false}) async {
  final Completer<void> completer = Completer<void>();
  bool ret = def;
  SnackBar sb = SnackBar(
      content: Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: Oswald(),
        ),
        MaterialButton(
          color: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          onPressed: () {
            ret = true;
            completer.complete();
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
          child: Text(
            "Tak",
            style: Oswald(),
          ),
        ),
      ],
    ),
  ));

  ScaffoldMessenger.of(context).showSnackBar(sb);
  await completer.future;

  return ret;
}

String getCurrentTimestamp() {
  DateTime now = DateTime.now();
  String day = now.day.toString().padLeft(2, '0');
  String month = now.month.toString().padLeft(2, '0');
  String year = now.year.toString();
  return "$day.$month.$year";
}

Future<List<String>?> showDialogSelectUsers(
    BuildContext context, String organizationId, List<String>? selectedLogins) {
    selectedLogins ??= [];
  return showDialog<List<String>>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Wybierz użytkowników"),
        content: SizedBox(
          width: double.maxFinite,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("organizacje")
                .doc(organizationId)
                .collection("users")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Text("Błąd: ${snapshot.error}");
              }

              final users = snapshot.data!.docs;

              return ListView.builder(
                shrinkWrap: true,
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index].data() as Map<String, dynamic>;
                  final login = user['Login'];
                  final stanowisko = user['Stanowisko'];
                  final email = user['Adres Email'];

                  return StatefulBuilder(
                    builder: (context, setState) {
                      final isSelected = selectedLogins!.contains(email);
                      return CheckboxListTile(
                        title: Text("$login - $stanowisko"),
                        subtitle: Text(email),
                        value: isSelected,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              selectedLogins!.add(email);
                            } else {
                              selectedLogins!.remove(email);
                            }
                          });
                        },
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: Text("Anuluj"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, selectedLogins),
            child: Text("Dalej"),
          ),
        ],
      );
    },
  );
}
