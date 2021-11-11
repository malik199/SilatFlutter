import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:silat_flutter/utils/fire_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:quartet/quartet.dart';

class LandingPageData extends StatefulWidget {
  final User userPassed;
  const LandingPageData({required this.userPassed});

  @override
  _LandingPageDataState createState() => _LandingPageDataState();
}

class _LandingPageDataState extends State<LandingPageData> {
  late User _currentUser;
  final _database = FirebaseDatabase.instance.reference();
  late StreamSubscription _userDBStream;
  var myUser;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.userPassed;
    _getUserData();
  }

  void _getUserData() {
    _userDBStream = _database
        .child('users')
        .orderByChild('email')
        .equalTo((_currentUser.email)?.toLowerCase())
        .limitToFirst(1)
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        final data = new Map<String?, dynamic>.from(event.snapshot.value);
        setState(() {
          data.forEach((key, value) {
            myUser = value;
          });
        });
      }
    });
  }

  String formatCurriculum(curriculum) {
    return titleCase(curriculum.toString().replaceAll('_', ' '));
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
  void deactivate() {
    _userDBStream.cancel();
    super.deactivate();
  }

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
          Container(
              decoration: BoxDecoration(
                  color: Colors.blue[900],
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            myUser?['firstname'] != null
                                ? titleCase(
                                    '${myUser?['firstname']} ${myUser?['lastname']}')
                                : "",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 27,
                                color: Colors.white)),
                        SizedBox(height: 10),
                        Text(titleCase('${myUser?['belt']} Belt') ?? "",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.white)),
                        Text(titleCase(formatCurriculum(myUser?['curriculum'])) ?? "",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.white)),
                        Text('Age: ${titleCase(myUser?['age'].toString())}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Colors.white)),
                      ],
                    ),
                    FluttermojiCircleAvatar(
                      radius: 70,
                    ),
                  ],
                ),
              )),
          SizedBox(height: spacingBetween),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
            child: _currentUser.emailVerified
                ? Text('Your email <${_currentUser.email}> \nis verified',
                    style: TextStyle(color: Colors.green))
                : Column(
                    children: [
                      Text(
                        'Your email\n${_currentUser.email}\nis not verified',
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      _isSendingVerification
                          ? CircularProgressIndicator()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                  child: Text('VERIFY EMAIL',
                                      style: TextStyle(fontSize: 15)),
                                ),
                                SizedBox(width: 8.0),
                                IconButton(
                                  icon:
                                      Icon(Icons.refresh, color: Colors.white),
                                  onPressed: () async {
                                    User? user = await FireAuth.refreshUser(
                                        _currentUser);

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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.list, size: 40, color: Colors.yellow),
              Text("LEADER BOARD",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 27,
                      color: Colors.white)),
            ],
          ),
          Expanded(
            child: Row(children: [
              Expanded(
                child: Container(
                  color: Colors.red,
                  child: ListView(children: [
                    Column(
                      children: <Widget>[
                        Text("Jawara Muda",
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
                  color: Colors.blue,
                  child: ListView(children: [
                    Column(
                      children: <Widget>[
                        Text("Satria Muda",
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
