// ignore_for_file: camel_case_types, avoid_unnecessary_containers, prefer_const_constructors
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workflow_ro/fav.dart';
import 'package:workflow_ro/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workflow_ro/mainScreenHandler.dart';
import 'package:workflow_ro/projects.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class logowanieScreen extends StatefulWidget {
  const logowanieScreen({super.key});

  @override
  State<logowanieScreen> createState() => _logowanieScreenState();
}

class _logowanieScreenState extends State<logowanieScreen> {
  TextEditingController login =
      TextEditingController(text: "madebysnl@gmail.com");
  TextEditingController pass = TextEditingController(text: "Qwerty123!@#");

  static Future<User?> loginUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-email") {
      } else if (e.code == "wrong-password") {}
    }

    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                FlutterLogo(
                  size: 128,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Container(
                    child: Text(
                  "WorkFlowPro",
                  style: Oswald(
                    TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 32,
                      color: textColor,
                    ),
                  ),
                )),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                ),
                Container(
                  child: SizedBox(
                      width: 240,
                      child: TextField(
                        style: Oswald(),
                        controller: login,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          hintText: "Login",
                          prefixIcon: Icon(Icons.person),
                        ),
                      )),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Container(
                    width: 240,
                    child: TextField(
                      style: Oswald(),
                      controller: pass,
                      obscureText: true,
                      decoration: const InputDecoration(
                          hintText: "Password",
                          prefixIcon: Icon(
                            Icons.lock,
                          )),
                    )),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.075,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: background,
                      foregroundColor: primColor,
                      shadowColor: primShade,
                    ),
                    onPressed: () async {
                      User? user = await loginUsingEmailPassword(
                          email: login.text,
                          password: pass.text, //_passwordController.text,
                          context: context);

                      if (user != null) {
                        localUser = await userToUserData(user);
                        final usersBase = db.collection("uzytkownicy");
                        final userProf = usersBase.doc(login.text);
                        FirebaseMessaging messaging =
                            FirebaseMessaging.instance;
                        String? token = await messaging.getToken();
                        await FirebaseFirestore.instance
                            .collection('uzytkownicy')
                            .doc(login.text)
                            .update({'fcmToken': token});
                        userProf.get().then((DocumentSnapshot doc) {
                          final data = doc.data() as Map<String, dynamic>;

                          if (pendingRedirect != null) {
                            final selectedDate =
                                DateTime.tryParse(pendingRedirect!['date']!);
                            final org = localUser!.nazwaFirmy;
                            print("organizacja: $org");
                            print(selectedDate);
                            if (selectedDate != null && org != null) {
                              print("pass");
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (_) => ProjectsScreen(
                                  organization: org,
                                  locUser: localUser!,
                                  selectedDate: selectedDate,
                                ),
                              ));
//zyść po przekierowaniu
                            }
                          } else {
                            if (data["wfp_admin"]) {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (c, a1, a2) =>
                                      mainScreensHandler(
                                          user: user,
                                          organization: localUser!.nazwaFirmy,
                                          locUser: localUser!),
                                  transitionsBuilder: (c, anim, a2, child) =>
                                      FadeTransition(
                                          opacity: anim, child: child),
                                  transitionDuration:
                                      Duration(milliseconds: 500),
                                ),
                              );
                            } else {
                              //navigator -> strona glowna
                            }
                          }
                        },
                            onError: (e) => print(
                                "Blad podczas pobierania dokumentu z firebase: $e"));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("no u"),
                          ),
                        );
                      }
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Text(
                        "Zaloguj",
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 24),
                        textAlign: TextAlign.center,
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
