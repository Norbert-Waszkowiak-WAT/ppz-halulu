// ignore_for_file: prefer_final_fields

// ignore: unused_import
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:workflow_ro/fav.dart';
import 'package:workflow_ro/main.dart';

class registerCompScreen extends StatefulWidget {
  final User user;
  const registerCompScreen({super.key, required this.user});
  @override
  State<registerCompScreen> createState() => _registerCompScreenState(user);
}

class _registerCompScreenState extends State<registerCompScreen>
    with SingleTickerProviderStateMixin {
  User user;
  _registerCompScreenState(this.user);
  TextEditingController _compName = TextEditingController();
  TextEditingController _compMail = TextEditingController();

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
            context, "Dodawanie Organizacji"),
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
                                      hintText: "Nazwa Firmy",
                                      border: InputBorder.none,
                                      prefixIcon: Icon(Icons.business)),
                                  controller: _compName,
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
                                      hintText: "Domena Firmy (@firma.pl)",
                                      border: InputBorder.none,
                                      prefixIcon: Icon(Icons.mail)),
                                  controller: _compMail,
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
                      form("Dane Organizacji", orgFormFields),
                      form("Dane Administratora", adminFormFields),
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
                    db
                        .collection("organizacje")
                        .doc(_compName.text)
                        .set(formToMap(orgFormFields));
                    List<formField> pom = adminFormFields;
                    pom.add(formField("Administrator", true, 'B'));
                    pom[pom.length - 1].inpCtrl.text = "1";
                    addUserToOrg(db, _compName.text, adminFormFields);
                    addUserToUsers(db, _compName.text, adminFormFields);

                    db
                        .collection("organizacje")
                        .doc(_compName.text)
                        .collection("users")
                        .doc(adminFormFields[0].inpCtrl.text)
                        .set(formToMap(adminFormFields));
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
