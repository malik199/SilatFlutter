import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:silat_flutter/login/login_page.dart';
import 'package:silat_flutter/screens/scoring_portrait.dart';
import 'package:silat_flutter/screens/rules_creed.dart';
import 'package:silat_flutter/screens/techniques_home.dart';
import 'package:silat_flutter/screens/home.dart';
import 'package:silat_flutter/admin/profile.dart';
import 'package:silat_flutter/admin/approved_users.dart';
import 'package:silat_flutter/admin/unapproved_users.dart';
import 'package:silat_flutter/models/isAdmin.dart';

class LandingPage extends StatefulWidget {
  final User user;

  //const LandingPage({required this.user});

  const LandingPage({Key? key, required this.user}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState(this.user);
}

class _LandingPageState extends State<LandingPage> {
  int _selectedIndex = 0;

  late User _currentUser;
  bool _isAdmin = false;
  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
    IsAdmin().trueOrFalse().then((res) {
      //print(res);
      setState(() {
        _isAdmin = res;
      });
    });
  }

  void _signMeOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  _LandingPageState(this._currentUser);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 5) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            // return object of type Dialog
            return AlertDialog(
              title: new Text("You are about to log out"),
              content: new Text("Are you sure you want to log out?"),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                TextButton(
                  onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => {_signMeOut()},
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = <Widget>[
      LandingPageData(userPassed: _currentUser),
      TechniquesHome(),
      RulesCreed(),
      ScoringPortrait(),
      Icon(
        Icons.event,
        size: 150,
      ),
      Text("logging out..."),
    ];

    return Scaffold(
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    "assets/images/silatlogo.png",
                  )),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ListTile(
              leading: Icon(Icons.person_outline),
              title: const Text('My Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profile()),
                );
              },
            ),
            if (_isAdmin) // admin only area
              Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.thumb_up),
                    title: const Text('Approved Users'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ApprovedUsers()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.thumb_down),
                    title: const Text('Unapproved Users'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UnapprovedUsers()),
                      );
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Silat Institute App'),
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
