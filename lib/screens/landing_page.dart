import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:silat_flutter/login/login_page.dart';
import 'package:silat_flutter/utils/fire_auth.dart';
import 'package:silat_flutter/screens/scoring_portrait.dart';
import 'package:silat_flutter/screens/rules_creed.dart';
import 'package:silat_flutter/screens/techniques_home.dart';
import 'package:silat_flutter/admin/profile.dart';
import 'package:silat_flutter/admin/approved_users.dart';
import 'package:fluttermoji/fluttermoji.dart';

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

  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
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
            ListTile(
              leading: Icon(Icons.settings),
              title: const Text('Approved Users'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ApprovedUsers()),
                );
              },
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

// ******************* HOME PAGE ************************

class LandingPageData extends StatefulWidget {
  final User userPassed;
  const LandingPageData({required this.userPassed});

  @override
  _LandingPageDataState createState() => _LandingPageDataState();
}

class _LandingPageDataState extends State<LandingPageData> {
  late User _currentUser;

  @override
  void initState() {
    _currentUser = widget.userPassed;
    //print(_currentUser);
    super.initState();
  }

  Color _containerColor = Colors.yellow;
  bool _isSendingVerification = false;
  //bool _isSigningOut = false;

  void changeColor() {
    setState(() {
      if (_containerColor == Colors.yellow) {
        _containerColor = Colors.red;
        return;
      }
      _containerColor = Colors.yellow;
    });
  }

  List items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 1',
    'Item 2',
    'Item 3'
  ];

  @override
  Widget build(BuildContext context) {
    double spacingBetween = 16;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              const Color(0xff000000),
              const Color(0xff0c3e40),
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(0.0, 1.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: spacingBetween),
          FluttermojiCircleAvatar(
            radius: 100,
          ),
          SizedBox(height: spacingBetween),
          Text(
            '${_currentUser.displayName}',
            style: Theme.of(context).textTheme.headline4,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 28.0),
            child: _currentUser.emailVerified
                ? Text(
                    'Your email <${_currentUser.email}> is verified',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.green),
                  )
                : Column(
                    children: [
                      Text(
                        'Your email <${_currentUser.email}> is not verified',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Colors.red),
                      ),
                      _isSendingVerification
                          ? CircularProgressIndicator()
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    setState(() {
                                      _isSendingVerification = true;
                                    });
                                    await _currentUser.sendEmailVerification();
                                    setState(() {
                                      _isSendingVerification = false;
                                    });
                                  },
                                  child: Text('Verify email'),
                                ),
                                SizedBox(width: 8.0),
                                IconButton(
                                  icon: Icon(Icons.refresh),
                                  onPressed: () async {
                                    User? user =
                                        await FireAuth.refreshUser(_currentUser);

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
                  ),
          ),
          SizedBox(height: spacingBetween),
          Expanded(
            child: Row(children: [
              Expanded(
                child: Container(
                  color: Colors.blue,
                  child: ListView(children: [
                    Column(
                      children: <Widget>[
                        Text("Tanding",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: 30,
                            itemBuilder: (context, index) {
                              return Text('Some text');
                            })
                      ],
                    ),
                  ]),
                ),
              ),
              SizedBox(width: 0),
              Expanded(
                child: Container(
                  color: Colors.red,
                  child: ListView(children: [
                    Column(
                      children: <Widget>[
                        Text("TUNGGAL",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              return Text(items[index]);
                            })
                      ],
                    ),
                  ]),
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
