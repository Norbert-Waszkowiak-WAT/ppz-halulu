// ignore_for_file: prefer_final_fields

// ignore: unused_import
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:workflow_ro/fav.dart';
import 'package:workflow_ro/main.dart';
import 'package:workflow_ro/userProfile.dart';

class registerEmployeeScreen extends StatefulWidget {
  final User user;
  const registerEmployeeScreen({super.key, required this.user});
  @override
  State<registerEmployeeScreen> createState() =>
      _registerEmployeeScreenState(user);
}

class _registerEmployeeScreenState extends State<registerEmployeeScreen>
    with SingleTickerProviderStateMixin {
  User user;
  _registerEmployeeScreenState(this.user);
  TextEditingController _employeeFName = TextEditingController();
  TextEditingController _employeeSName = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: defaultAppBar(
            context, profileScreen(user: user), "Dodawanie Pracownika"),
        body: Container(
          width: screenWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      border: Border(
                          bottom: BorderSide(width: 1, color: secColor))),
                  height: screenHeight * 0.15,
                  width: screenWidth,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: screenWidth * 0.02,
                      ),
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://cdn-icons-png.flaticon.com/512/4812/4812244.png"),
                        radius: screenWidth * 0.15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: screenWidth * 0.0275,
                              ),
                              Container(
                                width: screenWidth * 0.63,
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    border: Border.all(width: 1),
                                    borderRadius: BorderRadius.circular(16)),
                                child: TextField(
                                  textAlign: TextAlign.center,
                                  style: Oswald(),
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      hintText: "Imię Pracownika",
                                      border: InputBorder.none,
                                      prefixIcon: Icon(Icons.business)),
                                  controller: _employeeFName,
                                ),
                              ),
                              SizedBox(
                                width: screenWidth * 0.02,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: screenWidth * 0.0275,
                              ),
                              Container(
                                width: screenWidth * 0.63,
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    border: Border.all(width: 1),
                                    borderRadius: BorderRadius.circular(16)),
                                child: TextField(
                                  textAlign: TextAlign.center,
                                  style: Oswald(),
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      hintText: "Nazwisko Pracownika",
                                      border: InputBorder.none,
                                      prefixIcon: Icon(Icons.mail)),
                                  controller: _employeeSName,
                                ),
                              ),
                              SizedBox(
                                width: screenWidth * 0.02,
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  )),
              SizedBox(
                height: screenHeight * 0.015,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.lime,
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(
                      16,
                    )),
                width: screenWidth * 0.95,
                height: screenHeight * 0.6,
                child: SingleChildScrollView(
                  //
                  child: Column(
                    children: [
                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
                      form("Dane Użytkownika", userFormFields),
                    ],
                  )
                  //
                  ,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              Container(
                child: OutlinedButton(
                  onPressed: () {
                    List<formField> toAdd = userFormFields;
                    bool success =
                        (addUserToUsers(db, localUser!.nazwaFirmy, toAdd) &&
                            addUserToCompany(db, localUser!.nazwaFirmy, toAdd));
                    print("addutu");
                    print(success);
                  },
                  child: Text(
                    "Dodaj Organizację",
                    style: TextStyle(fontSize: screenWidth * 0.07),
                  ),
                ),
              ),
            ],
          ), //
        ),
      ),
    );
  }
}
