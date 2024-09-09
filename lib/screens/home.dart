import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:silat_flutter/models/belts_complex.dart';
import 'package:silat_flutter/utils/connectivity.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:silat_flutter/admin/avatar.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

extension StringExtension on String {
  String capitalizeFirstLetter() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}

class HomePage extends StatefulWidget {
  final User userPassed;
  const HomePage({required this.userPassed});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User _currentUser;
  final _database = FirebaseDatabase.instance.ref();
  late StreamSubscription _userDBStream;
  late StreamSubscription _topStudentsDBStream;
  late StreamSubscription _eventsDBStream;
  var myUser;

  String _firstName = "";
  String _lastName = "";
  String _belt = "white";
  String _curriculum = "satria_muda";
  int _stripe = 0;
  int _age = 0;
  String _location = "";
  double _numberSize = 30;
  double _lineHeight = 1.2;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.userPassed;
    _getUserData();
    _getToStudentData();
    _getEventsData();
  }

  late List<dynamic> _satriaMudaData = [];
  late List<dynamic> _reversedSatriaMudaData = [];
  late List<dynamic> _jawaraMudaData = [];
  late List<dynamic> _reversedJawaraMudaData = [];
  void _getToStudentData() {
    _topStudentsDBStream =
        _database.child('users').orderByChild('score').onValue.listen((event) {
      if (event.snapshot.value != null) {
        _satriaMudaData = [];
        _jawaraMudaData = [];
        final data = new Map<String, dynamic>.from(event.snapshot.value as Map);

        List allStudents = data.values.toList(); // Extract all students

        allStudents.sort((a, b) {
          // Null-aware comparison for scores
          var scoreA = a['score'] as num?;
          var scoreB = b['score'] as num?;
          if (scoreA == null || scoreB == null) {
            return 0; // Return 0 if either score is null
          }
          return scoreB.compareTo(scoreA); // Compare scores in descending order
        });

        setState(() {
          allStudents.forEach((value) {
            if (value["isApproved"] == true &&
                value['score'] != null &&
                value['score'] != 0 &&
                value['curriculum'] == 'satria_muda') {
              _satriaMudaData.add(value);
            }
            if (value["isApproved"] == true &&
                value['score'] != null &&
                value['score'] != 0 &&
                value['curriculum'] == 'jawara_muda') {
              _jawaraMudaData.add(value);
            }
          });
          _reversedSatriaMudaData = _satriaMudaData.reversed.toList();
          _reversedJawaraMudaData = _jawaraMudaData.reversed.toList();

          // Reverse the list again to put highest score at index 0
          _reversedSatriaMudaData = _reversedSatriaMudaData.reversed.toList();
          _reversedJawaraMudaData = _reversedJawaraMudaData.reversed.toList();
        });
      }
    });
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
        final data =
            new Map<String?, dynamic>.from(event.snapshot.value as Map);
        setState(() {
          data.forEach((key, value) {
            _firstName = value['firstname'];
            _lastName = value['lastname'];
            _belt = value['belt'];
            _curriculum = value['curriculum'];
            _age = value['age'];
            _stripe = value['stripe'];
            _location = value['location'];
          });
        });
      } else {
        _showMyDialog();
      }
    });
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No Silat User Found'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'There is a problem setting up your account. We are attempting to fix the problem now. Please contact the instructor to fix it.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String _eventName1 = "No Upcoming Events";
  String _eventLocation1 = "N/A";
  String _eventDate1 = "2019-08-09T06:55:01.8968264+00:00";
  int _difference1 = 0;

  String _eventName2 = "No Upcoming Events";
  String _eventLocation2 = "N/A";
  String _eventDate2 = "2019-08-09T06:55:01.8968264+00:00";
  int _difference2 = 0;

  void _getEventsData() {
    _eventsDBStream = _database
        .child('events')
        .orderByChild('date')
        .startAt(DateTime.now().toString())
        .limitToFirst(2)  // Change this number to 2 to fetch the latest two events
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        final data =
        new Map<String?, dynamic>.from(event.snapshot.value as Map);

        List events = data.values.toList();
        if (events.isNotEmpty) {
          setState(() {
            if (events.length > 0) {
              _eventName1 = events[0]['name'];
              _eventLocation1 = events[0]['location'];
              _eventDate1 = events[0]['date'];

              final eventDate1 = DateTime.parse(events[0]['date']);
              final dateNow = DateTime.now();
              _difference1 = -(dateNow.difference(eventDate1).inDays);
            }
            if (events.length > 1) {
              _eventName2 = events[1]['name'];
              _eventLocation2 = events[1]['location'];
              _eventDate2 = events[1]['date'];

              final eventDate2 = DateTime.parse(events[1]['date']);
              final dateNow = DateTime.now();
              _difference2 = -(dateNow.difference(eventDate2).inDays);
            }
          });
        }
      }
    });
  }


  String formatCurriculum(dynamic curriculum) {
    return convertToTitleCase(curriculum.toString().replaceAll('_', ' '));
  }

  String convertToTitleCase(String input) {
    return input.replaceAllMapped(RegExp(r'\b\w'), (match) {
      return match.group(0)!.toUpperCase();
    });
  }

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

  int getStripes(numOfStripes) {
    int _realNumbOfStripes = numOfStripes ?? 0;
    if (_belt == "black" || _belt == "red") {
      _realNumbOfStripes = numOfStripes + 5;
    } else {
      _realNumbOfStripes = _realNumbOfStripes + 1;
    }

    return _realNumbOfStripes;
  }

  void popupStats(obj) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: SingleChildScrollView(
            child: Column(children: [
              SizedBox(height: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${obj['firstname'].toUpperCase()}'s Stats",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        height: 1,
                      )),
                  if (obj['location'] != "")
                    Text("Location: ${obj['location'].toUpperCase()}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.teal)),
                ],
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.follow_the_signs, size: 40.0),
                title: Text(
                  "Tournaments",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("Total count of tournaments participated in.",
                    style: TextStyle(height: _lineHeight)),
                trailing: Text(
                    obj['tournaments'] != null
                        ? obj['tournaments'].toString()
                        : "",
                    style: TextStyle(
                        fontSize: _numberSize, fontWeight: FontWeight.bold)),
              ),
              ListTile(
                leading: Icon(Icons.filter_1, size: 40.0),
                title: Text(
                  "1st Place",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("Number of first place wins.",
                    style: TextStyle(height: _lineHeight)),
                trailing: Text(
                    obj['1stplace'] != null ? obj['1stplace'].toString() : "",
                    style: TextStyle(
                        fontSize: _numberSize, fontWeight: FontWeight.bold)),
              ),
              ListTile(
                leading: Icon(Icons.filter_2, size: 40.0),
                title: Text(
                  "2nd Place",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("Number of 2nd place wins.",
                    style: TextStyle(height: _lineHeight)),
                trailing: Text(
                    obj['2ndplace'] != null ? obj['2ndplace'].toString() : "",
                    style: TextStyle(
                        fontSize: _numberSize, fontWeight: FontWeight.bold)),
              ),
              ListTile(
                leading: Icon(Icons.store, size: 40.0),
                title: Text(
                  "Class Merits",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                    "Winning a class event, being an outstanding student in class.",
                    style: TextStyle(height: _lineHeight)),
                trailing: Text(
                    obj['classMerits'] != null
                        ? obj['classMerits'].toString()
                        : "",
                    style: TextStyle(
                        fontSize: _numberSize, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 10),
              ListTile(
                leading: Icon(Icons.verified, size: 40.0),
                title: Text(
                  "Good Deeds",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                    "Significant good deeds, helping the poor, volunteering, etc.",
                    style: TextStyle(height: _lineHeight)),
                trailing: Text(
                    obj['deeds'] != null ? obj['deeds'].toString() : "",
                    style: TextStyle(
                        fontSize: _numberSize, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 10),
              Divider(),
              Text("Total Score: ${(obj['score'] ?? "").toString()}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.deepPurple)),
            ]),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  void deactivate() {
    _userDBStream.cancel();
    _topStudentsDBStream.cancel();
    _eventsDBStream.cancel();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    //double spacingBetween = 16;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return Container(
      color: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // InternetConnection(), TODO: ADD Connectivity
          Padding(
            padding: const EdgeInsets.all(7.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      flex: 2,
                      child: TextButton(
                        onPressed: () => Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => Avatar())),
                        child: FluttermojiCircleAvatar(
                          radius: 70,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            /*Text(
                                '${_firstName.capitalizeFirstLetter()} ${_lastName.capitalizeFirstLetter()}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 26,
                                    height: 1,
                                    color: Colors.white)),*/
                            Text(
                                _belt != ""
                                    ? '$_belt Belt'.capitalizeFirstLetter()
                                    : "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    height: 1,
                                    color: Colors.white)),
                            Text(
                                formatCurriculum(_curriculum)
                                    .capitalizeFirstLetter(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    height: 1,
                                    color: Colors.white)),
                            Text(
                                _age != 0
                                    ? 'Age: ${_age.toString().capitalizeFirstLetter()}'
                                    : "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    height: 1,
                                    color: Colors.white)),
                            SizedBox(width: 17),
                            Text("Location: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Colors.white)),
                            Text(_location,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                BeltsComplex(
                    curriculum: _curriculum,
                    color: _belt,
                    stripes: getStripes(_stripe),
                    hasYellowStripe: _belt == "black" ? true : false),
                SizedBox(height: 5),
                Text(
                  "Upcoming Events",
                  style: TextStyle(
                    color: Colors.yellow, // Set the text color to yellow
                    fontWeight: FontWeight.bold, // Make the text bold
                    fontSize: 15, // Optional: Set font size
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .center, // Align children to the center horizontally
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(_eventName1,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 14)),
                              SizedBox(height: 1),
                              Text(
                                  (DateFormat('MMM dd, yyyy')
                                          .format(DateTime.parse(_eventDate1)))
                                      .toString()),
                              Text(_eventLocation1),
                              Text('Days Left: ${(_difference1 + 1).toString()}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, color: Colors.pink),),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(_eventName2,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 14)),
                              SizedBox(height: 1),
                              Text(
                                  (DateFormat('MMM dd, yyyy')
                                      .format(DateTime.parse(_eventDate2)))
                                      .toString()),
                              Text(_eventLocation2),
                              Text('Days Left: ${(_difference2 + 1).toString()}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, color: Colors.pink),),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Row(children: [
            Expanded(
                child: Container(
              padding: EdgeInsets.all(6),
              color: Colors.red,
              child: Text("Jawara Muda",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 17)),
            )),
            Expanded(
                child: Container(
              padding: EdgeInsets.all(6),
              color: Colors.blue,
              child: Text("Satria Muda",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 17)),
            )),
          ]),
          Expanded(
            child: Row(children: [
              Expanded(
                child: Container(
                  color: Colors.red,
                  child: ListView.builder(
                    itemCount: _reversedJawaraMudaData.length,
                    reverse: false,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Column(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.grey,
                                  backgroundColor: Colors.white,
                                  padding: EdgeInsets.fromLTRB(10, 1, 6, 0),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                  )),
                              onPressed: () {
                                popupStats(_reversedJawaraMudaData[index]);
                              },
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        '${_reversedJawaraMudaData[index]['firstname']} ${_reversedJawaraMudaData[index]['lastname']}',
                                        overflow: TextOverflow.fade,
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.blue),
                                      ),
                                    ),
                                    Text(
                                      (_reversedJawaraMudaData[index]
                                                  ['score'] ??
                                              "0")
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.blue,
                  child: ListView.builder(
                    itemCount: _reversedSatriaMudaData.length,
                    //reverse: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Column(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.grey,
                                  backgroundColor: Colors.white,
                                  padding: EdgeInsets.fromLTRB(10, 1, 6, 0),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                  )),
                              onPressed: () {
                                popupStats(_reversedSatriaMudaData[index]);
                              },
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        '${_reversedSatriaMudaData[index]['firstname']} ${_reversedSatriaMudaData[index]['lastname']}',
                                        overflow: TextOverflow.fade,
                                        style: TextStyle(
                                            fontSize: 15, color: Colors.blue),
                                      ),
                                    ),
                                    Text(
                                      (_reversedSatriaMudaData[index]
                                                  ['score'] ??
                                              "0")
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
