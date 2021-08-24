import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_authentication/login/login_page.dart';
import 'package:flutter_authentication/utils/fire_auth.dart';
import 'package:flutter_authentication/screens/home.dart';
import 'package:flutter_authentication/screens/scoring_portrait.dart';
import 'package:flutter_authentication/screens/rules_creed.dart';

class LandingPage extends StatefulWidget {
  final User user;

  //const LandingPage({required this.user});

  const LandingPage({Key? key, required this.user})
      : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState(this.user);
}

/*
class _LandingPageState extends State<LandingPage> {
  bool _isSendingVerification = false;
  bool _isSigningOut = false;

  late User _currentUser;

  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Home(_currentUser);
  }
}*/


class _LandingPageState extends State<LandingPage> {
  int _selectedIndex = 0;

  late User _currentUser;

  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
  }

  _LandingPageState(this._currentUser);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> _pages = <Widget>[
      HomeData(userPassed: _currentUser),
      Icon(
        Icons.sports_kabaddi,
        size: 150,
      ),
      RulesCreed(),
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

    return Scaffold(
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

class HomeData extends StatefulWidget {
  final User userPassed;
  const HomeData({required this.userPassed});

  @override
  _HomeDataState createState() => _HomeDataState();
}

class _HomeDataState extends State<HomeData> {
  late User _currentUser;

  @override
  void initState() {
    _currentUser = widget.userPassed;
    print(_currentUser);
    super.initState();
  }

  Color _containerColor = Colors.yellow;
  bool _isSendingVerification = false;
  bool _isSigningOut = false;

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'NAME: ${_currentUser.displayName}',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        SizedBox(height: 16.0),
        Text(
          'EMAIL: ${_currentUser.email}',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        SizedBox(height: 16.0),
        _currentUser.emailVerified
            ? Text(
          'Email verified',
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Colors.green),
        )
            : Text(
          'Email not verified',
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Colors.red),
        ),
        SizedBox(height: 16.0),
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
                User? user = await FireAuth.refreshUser(_currentUser);

                if (user != null) {
                  setState(() {
                    _currentUser = user;
                  });
                }
              },
            ),
          ],
        ),
        SizedBox(height: 16.0),
        _isSigningOut
            ? CircularProgressIndicator()
            : ElevatedButton(
          onPressed: () async {
            setState(() {
              _isSigningOut = true;
            });
            await FirebaseAuth.instance.signOut();
            setState(() {
              _isSigningOut = false;
            });
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ),
            );
          },
          child: Text('Sign out'),
          style: ElevatedButton.styleFrom(
            primary: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ],
    );
  }
}
