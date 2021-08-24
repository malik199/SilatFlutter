import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_authentication/login/login_page.dart';
import 'package:flutter_authentication/utils/fire_auth.dart';
import 'package:flutter_authentication/screens/scoring_portrait.dart';

class Home extends StatefulWidget {
  //const Home({Key? key}) : super(key: key);
   Home(this._currentUser);
   late User _currentUser;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  static List<Widget> _pages = <Widget>[
    Column(
      children: [
        Icon(
          Icons.home,
          size: 150,
        ),
        Text('NAME: MyName'),
      ],
    ),
    Icon(
      Icons.sports_kabaddi,
      size: 150,
    ),
    Icon(
      Icons.description,
      size: 150,
    ),
    ScoringPortrait(),
    Icon(
      Icons.event,
      size: 150,
    ),
    Icon(
      Icons.logout,
      size: 150,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Silat Institute App'),
      ),
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.shifting,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_kabaddi),
            label: 'Techniques',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'Rules & Creed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.table_view),
            label: 'Scoring',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Log Out',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}


class HomeData extends StatefulWidget {
  @override
  _HomeDataState createState() => _HomeDataState();
}

class _HomeDataState extends State<HomeData> {
  Color _containerColor = Colors.yellow;

  void changeColor() {
    setState(() {
      if (_containerColor == Colors.yellow) {
        _containerColor = Colors.red;
        return;
      }
      _containerColor = Colors.yellow;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(title: Text("A Simple App Stateful Widget")),
          body: Container(decoration: BoxDecoration(color: _containerColor)),
          floatingActionButton: FloatingActionButton(
            onPressed: changeColor,
            child: Icon(Icons.add),
            tooltip: "Book Here",
          ),
        ));
  }
}

