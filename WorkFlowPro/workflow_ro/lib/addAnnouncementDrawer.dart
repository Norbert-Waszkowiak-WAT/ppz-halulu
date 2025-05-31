import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workflow_ro/fav.dart';
import 'package:workflow_ro/main.dart';

void showAddAnnouncementSheet(
    BuildContext context, String author, String organization) {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  String formattedDate = getCurrentTimestamp();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: screenWidth * 0.05,
          right: screenWidth * 0.05,
          top: screenHeight * 0.02,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(author,
                    style: Oswald(TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.045,
                      color: primShade,
                    ))),
                Text(
                  formattedDate,
                  style: Oswald(TextStyle(
                    fontSize: screenWidth * 0.035,
                    color: secColor,
                  )),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),
            TextField(
              controller: titleController,
              style: Oswald(
                TextStyle(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                ),
              ),
              decoration: InputDecoration(
                hintText: "Podaj tytuł ogłoszenia",
                hintStyle: Oswald(
                  TextStyle(
                    color: secColor,
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: primColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            TextField(
              controller: contentController,
              maxLines: 6,
              style: Oswald(
                TextStyle(fontSize: screenWidth * 0.045),
              ),
              decoration: InputDecoration(
                hintText: "Wpisz tekst ogłoszenia",
                hintStyle: Oswald(
                  TextStyle(
                    color: secColor,
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: primColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: EdgeInsets.all(12),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Container(
              alignment: Alignment.center,
              child: MaterialButton(
                onPressed: () {
                  _addAnnouncementToFirestore(titleController.text,
                      contentController.text, author, organization);
                  Navigator.pop(context);
                },
                color: primColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  "Dodaj ogłoszenie",
                  style: Oswald(
                    TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenHeight * 0.03),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
          ],
        ),
      );
    },
  );
}

void _addAnnouncementToFirestore(
    String title, String content, String author, String organization) {
  if (title.isEmpty || content.isEmpty) return;

  FirebaseFirestore.instance
      .collection("organizacje")
      .doc(organization)
      .collection("announcments")
      .add({
    'Title': title,
    'Content': content,
    'author': author,
    'Tstamp': Timestamp.now(),
    'comments_num': 0,
  }).then((docRef) {
    docRef.collection("comments").doc("init").set({});
  });
}
