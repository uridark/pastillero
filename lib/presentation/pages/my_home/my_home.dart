import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pastillero/presentation/pages/alarms/alarm_page.dart';
import 'package:pastillero/presentation/pages/personal_notes/notes.dart';
import 'package:pastillero/presentation/pages/profile/perfil.dart';

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  int _currentIndex = 0;

  final _pages = [const AlarmPage(), const Notas(), Perfil()];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.bookMedical), label: "Pastillero"),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.stickyNote), label: "Notas"),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.userCircle), label: "Perfil"),
        ],
      ),
    );
  }
}
