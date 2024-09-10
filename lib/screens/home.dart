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

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
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
  double _statsFontSize = 11;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.userPassed;
    _getUserData();
    _getToStudentData();
    _getEventsData();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  late List<dynamic> _satriaMudaData = [];
  late List<dynamic> _reversedSatriaMudaData = [];
  late List<dynamic> _jawaraMudaData = [];
  late List<dynamic> _reversedJawaraMudaData = [];
  late List<dynamic> _allStudentsData = [];
  late List<dynamic> _reversedAllStudentsData = [];
  void _getToStudentData() {
    _topStudentsDBStream =
        _database.child('users').orderByChild('score').onValue.listen((event) {
      if (event.snapshot.value != null) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        List<dynamic> allStudents = data.values.toList();

        // Clear previous data
        _satriaMudaData.clear();
        _jawaraMudaData.clear();
        _allStudentsData.clear();

        // Filter and categorize data
        for (var student in allStudents) {
          if (student["isApproved"] == true &&
              student['score'] != null &&
              student['score'] != 0) {
            _allStudentsData.add(student);

            if (student['curriculum'] == 'satria_muda') {
              _satriaMudaData.add(student);
            } else if (student['curriculum'] == 'jawara_muda') {
              _jawaraMudaData.add(student);
            }
          }
        }

        // Sort lists by score in descending order
        var sorter = (a, b) => (b['score'] as num).compareTo(a['score'] as num);
        _satriaMudaData.sort(sorter);
        _jawaraMudaData.sort(sorter);
        _allStudentsData.sort(sorter);

        // No need to reverse twice, just set the state once
        setState(() {
          _reversedSatriaMudaData = List.from(_satriaMudaData);
          _reversedJawaraMudaData = List.from(_jawaraMudaData);
          _reversedAllStudentsData = List.from(_allStudentsData);
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
        .limitToFirst(
            2) // Change this number to 2 to fetch the latest two events
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
                      flex: 1,
                      child: TextButton(
                        onPressed: () => Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => Avatar())),
                        child: FluttermojiCircleAvatar(
                          radius: 60,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween, // Adjusted to space between
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Class Stats",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.greenAccent,
                                        fontSize: 12)),
                                SizedBox(height: 5),
                                Text("Tournaments (10)",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: _statsFontSize)),
                                Text("1st Place (3)",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: _statsFontSize)),
                                Text("2nd Place (5)",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: _statsFontSize)),
                                Text("Good Deeds (0)",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: _statsFontSize)),
                                Text("Class Merits (5)",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: _statsFontSize)),
                              ],
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    child: Text("Fitness Stats",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.purpleAccent,
                                            fontSize: 12))),
                                SizedBox(height: 5),
                                Text("Pushups (40)",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: _statsFontSize)),
                                Text("Situps (43)",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: _statsFontSize)),
                                Text("Deadhang (0:34)",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: _statsFontSize)),
                                Text("Pullups (1)",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: _statsFontSize)),
                                Text("Flexibility (1)",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: _statsFontSize)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )

                    /*Expanded(
                      flex: 2,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            */ /*Text(
                                '${_firstName.capitalizeFirstLetter()} ${_lastName.capitalizeFirstLetter()}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 26,
                                    height: 1,
                                    color: Colors.white)),*/ /*
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
                    ),*/
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
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                              Divider(height: 5),
                              Text((DateFormat('MMM dd, yyyy')
                                      .format(DateTime.parse(_eventDate1)))
                                  .toString()),
                              Text(_eventLocation1),
                              Text(
                                'Days Left: ${(_difference1 + 1).toString()}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.pink),
                              ),
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
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                              Divider(height: 5),
                              Text((DateFormat('MMM dd, yyyy')
                                      .format(DateTime.parse(_eventDate2)))
                                  .toString()),
                              Text(_eventLocation2),
                              Text(
                                'Days Left: ${(_difference2 + 1).toString()}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.pink),
                              ),
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
          Text(
            "Student Ranking",
            style: TextStyle(
              color: Colors.yellow, // Set the text color to yellow
              fontWeight: FontWeight.bold, // Make the text bold
              fontSize: 15, // Optional: Set font size
            ),
          ),
          SizedBox(height: 5),
          Expanded(
            child: DefaultTabController(
              length: 4,
              child: Column(
                children: <Widget>[
                  TabBar(
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(
                          child: Text("All Students",
                              softWrap: true, textAlign: TextAlign.center)),
                      Tab(
                          child: Text("Jawara Muda Long Title",
                              softWrap: true, textAlign: TextAlign.center)),
                      Tab(
                          child: Text("Satria Muda Extra Long Title Example",
                              softWrap: true, textAlign: TextAlign.center)),
                      Tab(
                          child: Text("New Students",
                              softWrap: true, textAlign: TextAlign.center)),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        Center(
                          child: Container(
                              color: Colors.black54,
                              child: ListView.builder(
                                itemCount: _reversedAllStudentsData.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: Column(
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.grey,
                                              backgroundColor: Colors.white10,
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 1, 6, 0),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                              )),
                                          onPressed: () {
                                            popupStats(_reversedAllStudentsData[
                                                index]);
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              // Index number circle
                                              Container(
                                                width:
                                                    25, // Diameter of the circle
                                                height:
                                                    25, // Diameter of the circle
                                                decoration: BoxDecoration(
                                                  color: Colors
                                                      .purple, // Background color of the circle
                                                  shape: BoxShape
                                                      .circle, // Makes the container circular
                                                ),
                                                alignment: Alignment
                                                    .center, // Centers the index text in the circle
                                                child: Text(
                                                  (index + 1)
                                                      .toString(), // Displaying the index, starting from 1
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14),
                                                ),
                                              ),
                                              SizedBox(
                                                  width:
                                                      10), // Space between the index and the name

                                              // Flexible to adjust text size automatically
                                              Flexible(
                                                fit: FlexFit
                                                    .tight, // Forces the child to fill the available space
                                                child: Text(
                                                  '${_reversedAllStudentsData[index]['firstname']} ${_reversedAllStudentsData[index]['lastname']}',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.purple,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  softWrap: false,
                                                ),
                                              ),

                                              // Score text aligned to the right
                                              Text(
                                                (_reversedAllStudentsData[index]
                                                            ['score'] ??
                                                        "0")
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.purple,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )),
                        ),
                        Center(
                          child: Container(
                              color: Colors.blue,
                              child: ListView.builder(
                                itemCount: _reversedJawaraMudaData.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: Column(
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.grey,
                                              backgroundColor: Colors.white,
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 1, 6, 0),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                              )),
                                          onPressed: () {
                                            popupStats(
                                                _reversedJawaraMudaData[index]);
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              // Index number circle
                                              Container(
                                                width:
                                                    25, // Diameter of the circle
                                                height:
                                                    25, // Diameter of the circle
                                                decoration: BoxDecoration(
                                                  color: Colors
                                                      .blue, // Background color of the circle
                                                  shape: BoxShape
                                                      .circle, // Makes the container circular
                                                ),
                                                alignment: Alignment
                                                    .center, // Centers the index text in the circle
                                                child: Text(
                                                  (index + 1)
                                                      .toString(), // Displaying the index, starting from 1
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                  softWrap: false,
                                                ),
                                              ),
                                              SizedBox(
                                                  width:
                                                      10), // Space between the index and the name

                                              // Flexible to adjust text size automatically
                                              Flexible(
                                                fit: FlexFit
                                                    .tight, // Forces the child to fill the available space
                                                child: Text(
                                                  '${_reversedJawaraMudaData[index]['firstname']} ${_reversedJawaraMudaData[index]['lastname']}',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),

                                              // Score text aligned to the right
                                              Text(
                                                (_reversedJawaraMudaData[index]
                                                            ['score'] ??
                                                        "0")
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.blue,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )),
                        ),
                        Center(
                          child: Container(
                              color: Colors.green,
                              child: ListView.builder(
                                itemCount: _reversedSatriaMudaData.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: Column(
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.grey,
                                              backgroundColor: Colors.white,
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 1, 6, 0),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                              )),
                                          onPressed: () {
                                            popupStats(
                                                _reversedSatriaMudaData[index]);
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              // Index number circle
                                              Container(
                                                width:
                                                    25, // Diameter of the circle
                                                height:
                                                    25, // Diameter of the circle
                                                decoration: BoxDecoration(
                                                  color: Colors
                                                      .green, // Background color of the circle
                                                  shape: BoxShape
                                                      .circle, // Makes the container circular
                                                ),
                                                alignment: Alignment
                                                    .center, // Centers the index text in the circle
                                                child: Text(
                                                  (index + 1)
                                                      .toString(), // Displaying the index, starting from 1
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                              ),
                                              SizedBox(
                                                  width:
                                                      10), // Space between the index and the name

                                              // Flexible to adjust text size automatically
                                              Flexible(
                                                fit: FlexFit
                                                    .tight, // Forces the child to fill the available space
                                                child: Text(
                                                  '${_reversedSatriaMudaData[index]['firstname']} ${_reversedSatriaMudaData[index]['lastname']}',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  overflow: TextOverflow.clip,
                                                  softWrap: false,
                                                ),
                                              ),

                                              // Score text aligned to the right
                                              Text(
                                                (_reversedSatriaMudaData[index]
                                                            ['score'] ??
                                                        "0")
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )),
                        ),
                        Center(
                          child: Container(
                              color: Colors.deepOrange,
                              child: ListView.builder(
                                itemCount: _reversedSatriaMudaData.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: Column(
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.grey,
                                              backgroundColor: Colors.white,
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 1, 6, 0),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                              )),
                                          onPressed: () {
                                            popupStats(
                                                _reversedSatriaMudaData[index]);
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              // Index number circle
                                              Container(
                                                width:
                                                    25, // Diameter of the circle
                                                height:
                                                    25, // Diameter of the circle
                                                decoration: BoxDecoration(
                                                  color: Colors
                                                      .deepOrange, // Background color of the circle
                                                  shape: BoxShape
                                                      .circle, // Makes the container circular
                                                ),
                                                alignment: Alignment
                                                    .center, // Centers the index text in the circle
                                                child: Text(
                                                  (index + 1)
                                                      .toString(), // Displaying the index, starting from 1
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                              ),
                                              SizedBox(
                                                  width:
                                                      10), // Space between the index and the name

                                              // Flexible to adjust text size automatically
                                              Flexible(
                                                fit: FlexFit
                                                    .tight, // Forces the child to fill the available space
                                                child: Text(
                                                  '${_reversedSatriaMudaData[index]['firstname']} ${_reversedSatriaMudaData[index]['lastname']}',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.deepOrange,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  softWrap: false,
                                                ),
                                              ),

                                              // Score text aligned to the right
                                              Text(
                                                (_reversedSatriaMudaData[index]
                                                            ['score'] ??
                                                        "0")
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 22,
                                                    color: Colors.deepOrange,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
