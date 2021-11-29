import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:silat_flutter/admin/guests.dart';
import 'package:silat_flutter/login/login_page.dart';
import 'package:silat_flutter/screens/add_events.dart';
import 'package:silat_flutter/screens/advancement.dart';
import 'package:silat_flutter/screens/events.dart';
import 'package:silat_flutter/screens/header.dart';
import 'package:silat_flutter/screens/scoring_portrait.dart';
import 'package:silat_flutter/screens/rules_creed.dart';
import 'package:silat_flutter/screens/techniques_home.dart';
import 'package:silat_flutter/screens/home.dart';
import 'package:silat_flutter/admin/profile.dart';
import 'package:silat_flutter/admin/approved_users.dart';
import 'package:silat_flutter/admin/unapproved_users.dart';
import 'package:silat_flutter/models/isAdmin.dart';
import 'package:silat_flutter/utils/fire_auth.dart';

class LandingPage extends StatefulWidget {
  final User user;

  //const LandingPage({required this.user});

  const LandingPage({Key? key, required this.user}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState(this.user);
}

class _LandingPageState extends State<LandingPage> {
  int _selectedIndex = 0;
  bool _isSendingVerification = false;
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

  Widget pleaseVerifyWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Your email:',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text("${_currentUser.email}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black45)),
        Text(
          'is not verified',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        SizedBox(height: 20),
        Text(
          "Please click on the link below to verify email.\nThen check your email account for a verification link.",
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 10),
          textAlign: TextAlign.center,

        ),
        SizedBox(height: 10),
        _isSendingVerification
            ? CircularProgressIndicator()
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
  style:  ElevatedButton.styleFrom(
    onPrimary: Colors.black87,
    primary: Colors.grey[300],
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
    ),
              onPressed: () async {
                setState(() {
                  _isSendingVerification = true;
                });
                await _currentUser.sendEmailVerification();
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(
                  content: Text(
                      'Verification email sent. Please check your email and click the verification link.'),
                  backgroundColor: Colors.green,
                ));
                setState(() {
                  _isSendingVerification = false;
                });
              },
              child: Text('VERIFY EMAIL',
                  style: TextStyle(fontSize: 15)),
            ),
            IconButton(
              icon:
              Icon(Icons.refresh, color: Colors.blue),
              onPressed: () async {
                User? user = await FireAuth.refreshUser(
                    _currentUser);
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(
                  content: Text(
                      'If you have verified your email, the refresh button should load all the app data.'),
                  backgroundColor: Colors.deepOrange,
                ));

                if (user != null) {
                  setState(() {
                    _currentUser = user;
                  });
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = <Widget>[
      HomePage(userPassed: _currentUser),
      TechniquesHome(),
      RulesCreed(),
      ScoringPortrait(),
      Events(),
      Text("logging out..."),
    ];
    return Scaffold(
      drawer: Drawer(
        child: _currentUser.emailVerified ? ListView(
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
            ListTile(
              leading: Icon(Icons.playlist_add_check),
              title: const Text('Belt Advancement'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Advancement()),
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
                    leading: Icon(Icons.event),
                    title: const Text('Add Event'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddEventsPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.event),
                    title: const Text('Guests'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Guests()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.help_outline),
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
        ) : null,
      ),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Header(headerText: "Silat Institute App"),
      ),
      body: Center(
        child: _currentUser.emailVerified ?
        IndexedStack(
          index: _selectedIndex,
          children: _pages,
        )
            : pleaseVerifyWidget(),
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
