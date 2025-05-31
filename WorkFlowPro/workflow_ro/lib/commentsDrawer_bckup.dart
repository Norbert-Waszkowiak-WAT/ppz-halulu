import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workflow_ro/fav.dart';

class CommentsSection extends StatelessWidget {
  final String docId;
  final int cn;
  final localUserData localUser;
  final String organization;
  CommentsSection(
      {required this.docId,
      required this.organization,
      required this.localUser,
      required this.cn});

  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text("Komentarze",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("organizacje")
                  .doc(organization)
                  .collection("announcments")
                  .doc(docId)
                  .collection('comments')
                  .orderBy('Tstamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("Brak komentarzy"));
                }

                final comments = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final data = comments[index].data() as Map<String, dynamic>;
                    final commentId = comments[index].id;

                    return Dismissible(
                      key: Key(commentId),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        color: Colors.red,
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (direction) async {
                        return await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Usuń Komentarz"),
                            content: Text("Czy chcesz usunąć ten komentarz?"),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text("Anuluj"),
                              ),
                              TextButton(
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection("organizacje")
                                      .doc(organization)
                                      .collection("announcments")
                                      .doc(docId)
                                      .collection("comments")
                                      .doc(commentId)
                                      .delete();
                                  Map<String, int> cnUpdate = {
                                    'comments_num': cn - 1
                                  };
                                  FirebaseFirestore.instance
                                      .collection("organizacje")
                                      .doc(organization)
                                      .collection("announcments")
                                      .doc(docId)
                                      .update(cnUpdate);
                                  Navigator.of(context).pop(true);
                                },
                                child: Text("Usuń",
                                    style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      },
                      child: ListTile(
                        title: Text(
                          data['Author'] ?? "Anonim",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(data['Text'] ?? ""),
                        trailing: Text(formatTimestamp(data['Tstamp'])),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Divider(),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(hintText: "Napisz komentarz..."),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send, color: Colors.blue),
                onPressed: () => _addComment(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _addComment(BuildContext context) {
    final commentText = _commentController.text.trim();
    if (commentText.isEmpty) return;

    FirebaseFirestore.instance
        .collection('announcments')
        .doc(docId)
        .collection('comments')
        .add({
      'Author': "Anonim",
      'Text': commentText,
      'Tstamp': Timestamp.now(),
    });

    _commentController.clear();
  }
}
