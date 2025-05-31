import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:workflow_ro/fav.dart';
import 'package:workflow_ro/main.dart';

class ProjectsScreen extends StatefulWidget {
  final String organization;
  final localUserData locUser;
  final DateTime? selectedDate;
  const ProjectsScreen(
      {super.key, required this.organization, required this.locUser, this.selectedDate});

  @override
  State<ProjectsScreen> createState() =>
      _ProjectsScreenState(organization, locUser, selectedDate);
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  List<String>? loginy;
  DateTime? _selectedDate;
  String organization;
  localUserData localUser;
  _ProjectsScreenState(this.organization, this.localUser, this._selectedDate);
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  Map<DateTime, bool> _markedDays = {};
  bool _weekView = false;
  @override
  void initState() {
    print(_selectedDate);
    super.initState();
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Stream<Map<DateTime, bool>> _getMarkedDaysStream() {
    return FirebaseFirestore.instance
        .collection("organizacje")
        .doc(organization)
        .collection("projects")
        .snapshots()
        .map((snapshot) {
      Map<DateTime, bool> markedDays = {};
      for (var doc in snapshot.docs) {
        DateTime day = (doc['date'] as Timestamp).toDate();
        markedDays[DateTime(day.year, day.month, day.day)] = true;
      }
      return markedDays;
    });
  }

  Stream<List<Map<String, dynamic>>> _getProjectsForDayStream(DateTime date) {
    return FirebaseFirestore.instance
        .collection("organizacje")
        .doc(organization)
        .collection("projects")
        .where('date',
            isGreaterThanOrEqualTo:
                Timestamp.fromDate(date.add(Duration(hours: -2))))
        .where('date',
            isLessThan:
                Timestamp.fromDate(date.add(Duration(days: 1, hours: -2))))
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {
                  'title': doc['title'],
                  'description': doc['description'],
                  'date': (doc['date'] as Timestamp).toDate(),
                  'author': doc['author'],
                  'assigned': doc['assigned']
                })
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: _getMarkedDaysStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                    child: Text("Błąd ładowania projektów: ${snapshot.error}"));
              }
              if (snapshot.hasData) {
                _markedDays = snapshot.data!;
                return Column(
                  children: [
                    Container(
                        height: 400,
                        child: Column(
                          children: [
                            TableCalendar(
                              focusedDay: _focusedDay,
                              firstDay: DateTime(2000),
                              lastDay: DateTime(2100),
                              selectedDayPredicate: (day) =>
                                  isSameDay(_selectedDay, day),
                              onDaySelected: (selectedDay, focusedDay) {
                                if (_calendarFormat == CalendarFormat.month) {
                                  _calendarFormat = CalendarFormat.week;
                                  _weekView = true;
                                }
                                setState(() {
                                  _selectedDay = selectedDay;
                                  _focusedDay = focusedDay;
                                });
                                print("Kliknięto: ${selectedDay.day}");
                              },
                              calendarFormat: _calendarFormat,
                              onFormatChanged: (format) {
                                _calendarFormat = format;
                                setState(() {
                                  _weekView = (format == CalendarFormat.week);
                                });
                              },
                              availableCalendarFormats: {
                                CalendarFormat.week: "Widok Tygodnia",
                                CalendarFormat.month: "Widok Miesiąca"
                              },
                              calendarBuilders: CalendarBuilders(
                                defaultBuilder: (context, day, focusedDay) {
                                  bool isMarked = _markedDays[DateTime(
                                          day.year, day.month, day.day)] ??
                                      false;
                                  return Container(
                                    margin: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: isMarked
                                          ? Colors.blue.withOpacity(0.5)
                                          : null,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(child: Text('${day.day}')),
                                  );
                                },
                              ),
                            ),
                            if (_weekView)
                              Expanded(
                                child:
                                    StreamBuilder<List<Map<String, dynamic>>>(
                                  stream:
                                      _getProjectsForDayStream(_selectedDay),
                                  builder: (context, projectSnapshot) {
                                    print(_selectedDay);
                                    if (projectSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    }
                                    if (projectSnapshot.hasError) {
                                      return Center(
                                          child: Text(
                                              "Błąd ładowania projektów: ${projectSnapshot.error}"));
                                    }
                                    if (projectSnapshot.hasData &&
                                        projectSnapshot.data!.isNotEmpty) {
                                      print(projectSnapshot);
                                      return ListView.builder(
                                        itemCount: projectSnapshot.data!.length,
                                        itemBuilder: (context, index) {
                                          print(index);
                                          bool _cardExpanded = false;
                                          double turns = 0.25;
                                          var project =
                                              projectSnapshot.data![index];
                                          return Card(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 10),
                                              child: StatefulBuilder(
                                                builder: (BuildContext context,
                                                    void Function(
                                                            void Function())
                                                        setState) {
                                                  return ExpansionTile(
                                                    onExpansionChanged:
                                                        (value) {
                                                      setState(() => (value)
                                                          ? turns = 0.0
                                                          : turns = 0.25);
                                                    },
                                                    trailing: Column(
                                                      children: [
                                                        Text(
                                                          "by ${project['author']}",
                                                          style: Oswald(
                                                              TextStyle(
                                                                  color: Colors
                                                                      .grey)),
                                                        ),
                                                        AnimatedRotation(
                                                          turns: turns,
                                                          duration: Duration(
                                                              milliseconds:
                                                                  250),
                                                          child: Icon(
                                                            Icons
                                                                .arrow_drop_down,
                                                            size: 32,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    title: ListTile(
                                                      title: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            project['title'],
                                                            style: Oswald(TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                fontSize: 20)),
                                                          ),
                                                        ],
                                                      ),
                                                      subtitle: Text(
                                                        project['description'],
                                                        style: Oswald(),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ));
                                        },
                                      );
                                    } else {
                                      return Center(
                                          child: Text(
                                              "Brak projektów na ten dzień"));
                                    }
                                  },
                                ),
                              )
                            else //nie-week view
                              Container(),
                          ],
                        )),
                    StatefulBuilder(builder: (BuildContext context,
                        void Function(void Function()) localSetState) {
                      return Container(
                          height: screenHeight * 0.425,
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text("Dodaj nowy projekt",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              TextFormField(
                                controller: _titleController,
                                decoration: InputDecoration(labelText: "Tytuł"),
                                validator: (val) => val == null || val.isEmpty
                                    ? "Podaj tytuł"
                                    : null,
                              ),
                              TextFormField(
                                controller: _descController,
                                decoration: InputDecoration(labelText: "Opis"),
                                maxLines: 2,
                                validator: (val) => val == null || val.isEmpty
                                    ? "Podaj opis"
                                    : null,
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                      onPressed: () async {
                                        List<String>? loginyTemp =
                                            await showDialogSelectUsers(context,
                                                localUser.nazwaFirmy, loginy);
                                        if (loginyTemp != null) {
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) {
                                            localSetState(() {
                                              loginy = loginyTemp;
                                            });
                                          });
                                        }
                                      },
                                      child: Text(loginy == null
                                          ? "Dodaj Osoby"
                                          : (loginy!.length == 1)
                                              ? "1 osoba"
                                              : (loginy!.length <= 4)
                                                  ? "${loginy!.length} osoby"
                                                  : "${loginy!.length} osób")),
                                  TextButton.icon(
                                    icon: Icon(Icons.calendar_today),
                                    label: Text(
                                      _selectedDate != null
                                          ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
                                          : "Wybierz datę",
                                      style: Oswald(),
                                    ),
                                    onPressed: _pickDate,
                                  )
                                ],
                              ),
                              SizedBox(height: 8),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection('organizacje')
                                      .doc(localUser.nazwaFirmy)
                                      .collection('projects')
                                      .add({
                                    'title': _titleController.text.trim(),
                                    'description': _descController.text.trim(),
                                    'date': Timestamp.fromDate(_selectedDate!),
                                    'author': localUser.username,
                                    'assigned': loginy, // jeśli trzeba
                                  });

                                  _titleController.clear();
                                  _descController.clear();
                                  localSetState(() => _selectedDate = null);

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text("Dodano projekt!"),
                                  ));
                                },
                                icon: Icon(Icons.add),
                                label: Text("Dodaj projekt"),
                              ),
                            ],
                          ));
                    })
                  ],
                );
              }
              return Center(child: Text("Błąd"));
            }));
  }
}
