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
  double _numberSize = 35;

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
    _topStudentsDBStream = _database.child('users').orderByChild('score').onValue.listen((event) {
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
        final data = new Map<String?, dynamic>.from(event.snapshot.value as Map);
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
      }
    });
  }

  String _eventName = "";
  String _eventLocation = "";
  //String _eventUrl = "";
  //String _eventDescription = "";
  String _eventDate = "2019-08-09T06:55:01.8968264+00:00";
  //String _eventDeadline = "";
  int _difference = 0;
  void _getEventsData() {
    _eventsDBStream = _database
        .child('events')
        .orderByChild('date')
        .startAt(DateTime.now().toString())
        .limitToFirst(1)
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        final data = new Map<String?, dynamic>.from(event.snapshot.value as Map);

        setState(() {
          data.forEach((key, value) {
            _eventName = value['name'];
            _eventLocation = value['location'];
            //_eventUrl = value['url'];
            //_eventDescription = value['curriculum'];
            _eventDate = value['date'];
            //_eventDeadline = value['stripe'];

            final eventDate = DateTime.parse(value['date']);
            final date2 = DateTime.now();
            _difference = -(date2.difference(eventDate).inDays);
          });
        });
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
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
                subtitle:
                    Text("Number of tournaments that you have competed in."),
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
                subtitle: Text("Number of first place wins."),
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
                subtitle: Text("Number of 2nd place wins."),
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
                    "Winning a class event, being an outstanding student in class."),
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
                    "Significant good deeds, helping the poor, volunteering, etc."),
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
      color: Colors.grey[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InternetConnection(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                    decoration: BoxDecoration(
                        color: Colors.blue[900],
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 2,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 18.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                      '${_firstName.capitalizeFirstLetter()} ${_lastName.capitalizeFirstLetter()}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 26,
                                          color: Colors.white)),
                                  SizedBox(height: 10),
                                  Text(
                                      _belt != ""
                                          ? '$_belt Belt'
                                              .capitalizeFirstLetter()
                                          : "",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.white)),
                                  Text(
                                      formatCurriculum(_curriculum)
                                              .capitalizeFirstLetter() ??
                                          '',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.white)),
                                  Row(
                                    children: [
                                      Text(
                                          _age != 0
                                              ? 'Age: ${_age.toString().capitalizeFirstLetter()}'
                                              : "",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
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
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: TextButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => Avatar())),
                              child: FluttermojiCircleAvatar(
                                radius: 70,
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
                SizedBox(height: 5),
                BeltsComplex(
                    curriculum: _curriculum,
                    color: _belt,
                    stripes: getStripes(_stripe),
                    hasYellowStripe: _belt == "black" ? true : false),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Card(
              color: Colors.limeAccent,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: ListTile(
                  leading: Icon(Icons.event, size: 40),
                  title: Text(_eventName,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 1),
                      Row(
                        children: [
                          Text('Event Date: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12)),
                          Text(
                              (DateFormat('MMM dd, yyyy')
                                      .format(DateTime.parse(_eventDate)))
                                  .toString(),
                              style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Location: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12)),
                          Text(_eventLocation, style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  trailing: FittedBox(
                    child: Column( children: [
                      Text('DAYS LEFT',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 8)),
                      Text((_difference + 1).toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 40)),
                    ]),
                  ),
                ),
              ),
            ),
          ),
          Container(
            color: Colors.black87,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.control_camera, size: 20, color: Colors.grey),
                SizedBox(width: 10),
                Text("TOP STUDENTS",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 27,
                        color: Colors.white)),
                SizedBox(width: 10),
                Icon(Icons.control_camera, size: 20, color: Colors.grey),
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
                                  foregroundColor: Colors.grey, backgroundColor: Colors.white, padding: EdgeInsets.fromLTRB(10, 1, 6, 0),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
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
                                  foregroundColor: Colors.grey, backgroundColor: Colors.white, padding: EdgeInsets.fromLTRB(10, 1, 6, 0),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5)),
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
