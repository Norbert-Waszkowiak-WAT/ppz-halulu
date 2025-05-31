import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workflow_ro/addAnnouncementDrawer.dart';
import 'package:workflow_ro/commentsDrawer.dart';
import 'package:workflow_ro/fav.dart';
import 'package:workflow_ro/main.dart';

class mainScreen extends StatefulWidget {
  final String organization;
  final localUserData locUser;
  const mainScreen(
      {super.key, required this.organization, required this.locUser});

  @override
  State<mainScreen> createState() => _mainScreenState(organization, locUser);
}

class _mainScreenState extends State<mainScreen> {
  String organization;
  localUserData localUser;
  _mainScreenState(this.organization, this.localUser);

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: screenHeight * 0.8,
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("organizacje")
                    .doc(organization)
                    .collection("announcments")
                    .orderBy("Tstamp", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("Brak ogłoszeń"));
                  }
                  final announcements = snapshot.data!.docs;
                  return Container(
                    width: screenWidth,
                    height: screenHeight * 0.8,
                    child: ListView.builder(
                      itemCount: announcements.length,
                      itemBuilder: (context, index) {
                        final data =
                            announcements[index].data() as Map<String, dynamic>;
                        final docId = announcements[index].id;
                        final commentsNum = data['comments_num'] ?? 0;
                        final timestamp = data['Tstamp'];
                        final formattedDate = formatTimestamp(timestamp);

                        return GestureDetector(
                          onTap: () {
                            _showCommentsSheet(context, docId, organization, commentsNum);
                          },
                          onLongPress: () async {
                            if ((data['author'] == localUser.username) ||
                                (localUser.admin == true)) {
                              bool deleteAnnouncement = await aus(context,
                                  "Czy chcesz usunąć ogłoszenie ?");
                              if (deleteAnnouncement) {
                                FirebaseFirestore.instance
                                    .collection("organizacje")
                                    .doc(organization)
                                    .collection("announcments")
                                    .doc(docId)
                                    .delete();
                              }
                            }
                          },
                          child: Card(
                            margin: EdgeInsets.all(8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        data['author'] ?? "Nieznany autor",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.grey),
                                      ),
                                      Text(
                                        formattedDate,
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    data['Title'] ?? "Brak tytułu",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    data['Content'] ?? "Brak treści",
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.comment,
                                            size: 16, color: Colors.grey),
                                        SizedBox(width: 4),
                                        Text("$commentsNum",
                                            style:
                                                TextStyle(color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
          ),
          MaterialButton(
            onPressed: () {
              //odpal drawer z dodawaniem ogloszenia
              showAddAnnouncementSheet(context, "SNL", organization);
            },
            color: primColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text(
              "Dodaj Ogłoszenie",
              style:
                  Oswald(TextStyle(fontWeight: FontWeight.w600, fontSize: 24)),
            ),
          ),
        ],
      ),
    );
  }

  void _showCommentsSheet(
      BuildContext context, String docId, String organization, int cn) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => CommentsSection(
        docId: docId,
        organization: organization,
        localUser: localUser,
        cn: cn
      ),
    );
  }
}
