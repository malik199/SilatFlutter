import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:silat_flutter/admin/benchmarks.dart';
import 'package:silat_flutter/admin/guests.dart';
import 'package:silat_flutter/screens/add_events.dart';
import 'package:silat_flutter/screens/add_quote.dart';
import 'package:silat_flutter/screens/advancement.dart';
import 'package:silat_flutter/screens/events.dart';
import 'package:silat_flutter/screens/header.dart';
import 'package:silat_flutter/screens/indonesian_creed.dart';
import 'package:silat_flutter/screens/scoring_portrait.dart';
import 'package:silat_flutter/screens/english_creed.dart';
import 'package:silat_flutter/screens/rules.dart';
import 'package:silat_flutter/screens/techniques_home.dart';
import 'package:silat_flutter/screens/home.dart';
import 'package:silat_flutter/admin/profile.dart';
import 'package:silat_flutter/admin/approved_users.dart';
import 'package:silat_flutter/admin/unapproved_users.dart';
import 'package:silat_flutter/models/isAdmin.dart';
import 'package:silat_flutter/screens/weight_classes.dart';
import 'package:silat_flutter/utils/fire_auth.dart';
import 'package:silat_flutter/login/log_out.dart';

class LandingPage extends StatefulWidget {
  final User user;

  //const LandingPage({required this.user});

  const LandingPage({Key? key, required this.user}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState(this.user);
}

class _LandingPageState extends State<LandingPage> {
  int currentPageIndex = 0;
  int _selectedIndex = 0;
  bool _isSendingVerification = false;
  late User _currentUser;
  bool _isAdmin = false;
  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
    IsAdmin().trueOrFalse().then((res) {
      setState(() {
        _isAdmin = res;
      });
    });
  }

  _LandingPageState(this._currentUser);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget pleaseVerifyWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Your email:',
          style: TextStyle(
              color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text("${_currentUser.email}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        Text(
          'is not verified',
          style: TextStyle(
              color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        SizedBox(height: 20),
        Text(
          "Please click on the link below to verify email.\nThen check your email account for a verification link.",
          style: TextStyle(
              color: Colors.red, fontWeight: FontWeight.bold, fontSize: 10),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        _isSendingVerification
            ? CircularProgressIndicator()
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black87,
                      backgroundColor: Colors.grey[300],
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
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'Verification email sent. Please check your email and click the verification link.'),
                        backgroundColor: Colors.green,
                      ));
                      setState(() {
                        _isSendingVerification = false;
                      });
                    },
                    child: Text('VERIFY EMAIL', style: TextStyle(fontSize: 15)),
                  ),
                  IconButton(
                    icon: Icon(Icons.refresh, color: Colors.blue),
                    onPressed: () async {
                      User? user = await FireAuth.refreshUser(_currentUser);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
SizedBox(height: 50),
        ElevatedButton.icon(
          // Use ElevatedButton.icon constructor
          icon: Icon(Icons.exit_to_app, size: 18), // Add a logout icon
          label: Text('Log Out', style: TextStyle(fontSize: 12)), // Text label for the button
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LogOut()),
            );
          },

          style: ElevatedButton.styleFrom(

            minimumSize: Size(64, 32),
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            foregroundColor: Colors.white,
            backgroundColor: Colors.red, // Text color
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = <Widget>[
      HomePage(userPassed: _currentUser),
      TechniquesHome(),
      ScoringPortrait(),
      Events(),
    ];
    return _currentUser.emailVerified
        ? Scaffold(
            drawer: Drawer(
              child: _currentUser.emailVerified
                  ? ListView(
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
                        ListTile(
                          leading: Icon(Icons.person_outline),
                          title: const Text('My Profile'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Profile()),
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.person_outline),
                          title: const Text('My Benchmarks'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Benchmarks()),
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.playlist_add_check),
                          title: const Text('Belt Advancement'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Advancement()),
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.record_voice_over),
                          title: const Text('The Creed (English)'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreedEnglish()),
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.record_voice_over),
                          title: const Text('The Creed (Indonesian)'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreedIndonesian()),
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.scale),
                          title: const Text('Find My Weight Class'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WeightClasses()),
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.article),
                          title: const Text('Rules of the Class'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Rules()),
                            );
                          },
                        ),
                        if (_isAdmin) // admin only area
                          Column(
                            children: [
                              ListTile(
                                leading:
                                    Icon(Icons.thumb_up, color: Colors.green),
                                title: const Text(
                                  'Current Students',
                                  style: TextStyle(color: Colors.green),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ApprovedUsers()),
                                  );
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.format_quote,
                                    color: Colors.green),
                                title: const Text(
                                  'Add Quote',
                                  style: TextStyle(color: Colors.green),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddQuotePage()),
                                  );
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.event, color: Colors.red),
                                title: const Text(
                                  'Add Event',
                                  style: TextStyle(color: Colors.red),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddEventsPage()),
                                  );
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.event, color: Colors.red),
                                title: const Text(
                                  'Guests',
                                  style: TextStyle(color: Colors.red),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Guests()),
                                  );
                                },
                              ),
                              ListTile(
                                leading:
                                    Icon(Icons.help_outline, color: Colors.red),
                                title: const Text(
                                  'Unapproved Users',
                                  style: TextStyle(color: Colors.red),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            UnapprovedUsers()),
                                  );
                                },
                              ),
                            ],
                          ),
                        ListTile(
                          leading: Icon(Icons.logout),
                          title: const Text('Log Out'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LogOut()),
                            );
                          },
                        ),
                      ],
                    )
                  : null,
            ),
            appBar: AppBar(
              title: Header(headerText: _currentUser.displayName.toString()),
            ),
            body: _pages[currentPageIndex],
            bottomNavigationBar: NavigationBar(
              onDestinationSelected: (int index) {
                setState(() {
                  currentPageIndex = index;
                });
              },
              indicatorColor: Colors.amber,
              selectedIndex: currentPageIndex,
              destinations: const <Widget>[
                NavigationDestination(
                  selectedIcon: Icon(Icons.home),
                  icon: Icon(Icons.home_outlined),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.sports_kabaddi),
                  label: 'Techniques',
                ),
                NavigationDestination(
                  icon: Icon(Icons.table_view),
                  label: 'Scoring',
                ),
                NavigationDestination(
                  icon: Icon(Icons.event),
                  label: 'Events',
                ),
              ],
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Header(headerText: "Please verify email"),
            ),
            body: pleaseVerifyWidget());
  }
}
