import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workflow_ro/fav.dart';
import 'package:workflow_ro/mainScreen.dart';
import 'package:workflow_ro/projects.dart';
import 'package:workflow_ro/registerEmployee.dart';
import 'package:workflow_ro/userProfile.dart';

class mainScreensHandler extends StatefulWidget {
  final User user;
  final String organization;
  final localUserData locUser;
  const mainScreensHandler({super.key, required this.user, required this.organization, required this.locUser});

  @override
  State<mainScreensHandler> createState() => _mainScreensHandlerState(user, organization, locUser);
}

class _mainScreensHandlerState extends State<mainScreensHandler> {
  int _selectedIdx = 1;
    late final List<Widget> _widgetOptions;
  User user;
  String organization;
  localUserData locUser;
  _mainScreensHandlerState(this.user, this.organization, this.locUser);

  @override
  void initState() {
    super.initState();
    _widgetOptions = [
      ProjectsScreen(organization: organization, locUser: locUser),
      mainScreen(organization: organization, locUser: locUser,),
      profileScreen(user: user),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIdx = index; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.design_services), label: 'Projekty'),
            BottomNavigationBarItem(
                icon: Icon(Icons.home), label: 'Strona Główna'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          ],
          currentIndex: _selectedIdx,
          onTap: _onItemTapped,
        ),
        body: _widgetOptions[_selectedIdx],
      ),
    );
  }
}
