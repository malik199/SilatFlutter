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
  double _iconSize = 25;

  String _quoteOfTheWeek = "";

  int? _tournaments = 0;
  int? _1stPlace = 0;
  int? _2ndPlace = 0;

/*  int _goodDeeds = 0;
  int _classMerits = 0;
  int _pushUps = 0;
  int _sitUps = 0;
  String? _deadHang = '0:00';
  int _pullUps = 0;
  int _flexibility = 0;*/

  int? _score = 0;
  int? bm_pushups = 0;
  int? bm_situps = 0;
  int? bm_pullups = 0;
  String? bm_deadhang;
  String? bm_mile;
  String? bm_dash;
  String? bm_wallsits;
  int? bm_boxjumps = 0;
  int? bm_squats = 0;

  double _numberSize = 20;
  double _lineHeight = 1;
  double _statsFontSize = 11;
  double _littleFontSize = 10;
  double _betweenWidgetPadding = 10;
  double _smallSpacing = 5;
  double _statsPopUpHeaderFontSize = 12;
  double _statsSubtitleFontSize = 9;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.userPassed;
    _getUserData();
    _getEventsData();
    _getQuote();
    _tabController = TabController(length: 4, vsync: this);
    _topStudentsDBStream = Stream<DatabaseEvent>.empty().listen((event) {});

  }

  @override
  void dispose() {
    _tabController.dispose();
    _topStudentsDBStream.cancel();
    _userDBStream.cancel();
    _eventsDBStream.cancel();
    super.dispose();
  }

  late List<dynamic> _satriaMudaData = [];
  late List<dynamic> _reversedSatriaMudaData = [];
  late List<dynamic> _jawaraMudaData = [];
  late List<dynamic> _reversedJawaraMudaData = [];
  late List<dynamic> _allStudentsData = [];
  late List<dynamic> _reversedAllStudentsData = [];
  late List<dynamic> _myBeltData = [];
  late List<dynamic> _reversedMyBeltData = [];

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
            _tournaments = value['tournaments'] ?? 0;
            _1stPlace = value['1stplace'] ?? 0;
            _2ndPlace = value['2ndplace'] ?? 0;
            _score = value['score'] ?? 0;
            bm_pushups = value['bm_pushups'] ?? 0;
            bm_situps = value['bm_situps'] ?? 0;
            bm_pullups = value['bm_pullups'] ?? 0;
            bm_deadhang = value['bm_deadhang'].toString();
            bm_mile = value['bm_mile'].toString();
            bm_dash = value['bm_dash'].toString();
            bm_wallsits = value['bm_wallsits'].toString();
            bm_boxjumps = value['bm_boxjumps'] ?? 0;
            bm_squats = value['bm_squats'] ?? 0;
          });
        });

        _getStudentData(_belt, _curriculum);
      } else {
        _showMyDialog();
      }
    });
  }

  void _getStudentData(belt, curriculum) {
    _topStudentsDBStream.cancel();
    _topStudentsDBStream =
        _database.child('users').orderByChild('score').onValue.listen((event) {
          try {
            if (event.snapshot.value != null) {
              final data = Map<String, dynamic>.from(event.snapshot.value as Map);
              List<dynamic> allStudents = data.values.toList();

              // Clear previous data
              _satriaMudaData.clear();
              _jawaraMudaData.clear();
              _allStudentsData.clear();
              _myBeltData.clear();

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

                  if (student['belt'] == belt &&
                      student['curriculum'] == curriculum) {
                    _myBeltData.add(student);
                  }
                }
              }

              // Sort lists by score in descending order
              var sorter = (a, b) => (b['score'] as num).compareTo(a['score'] as num);
              _satriaMudaData.sort(sorter);
              _jawaraMudaData.sort(sorter);
              _allStudentsData.sort(sorter);
              _myBeltData.sort(sorter);

              // Update state with the sorted data
              setState(() {
                _reversedSatriaMudaData = List.from(_satriaMudaData);
                _reversedJawaraMudaData = List.from(_jawaraMudaData);
                _reversedAllStudentsData = List.from(_allStudentsData);
                _reversedMyBeltData = List.from(_myBeltData);
              });
            }
          } catch (e) {
            // Handle the error appropriately
            print('Error fetching student data: $e');
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
  String _eventDate1 = "2000-01-01T00:00:00+00:00";
  int _difference1 = 0;

  String _eventName2 = "No Upcoming Events";
  String _eventLocation2 = "N/A";
  String _eventDate2 = "2000-01-01T00:00:00+00:00";
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

  void _getQuote() {
    _eventsDBStream = _database
        .child('quotes')
        .orderByChild('date')
        .limitToLast(1)
        .onValue
        .listen((event) {
      if (event.snapshot.exists && event.snapshot.value != null) {
        final data =
            new Map<String?, dynamic>.from(event.snapshot.value as Map);
        Map<dynamic, dynamic> quoteData = data.values.first;
        setState(() {
          _quoteOfTheWeek = quoteData['quote'];
        });
      } else {
        print('No quotes found.');
      }
    }, onError: (error) {
      print('Error fetching latest quote: $error');
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

  Map<String, Color> colorMap = {
    'white': Colors.white,
    'yellow': Colors.yellow,
    'green': Colors.green,
    'blue': Colors.blue,
    'purple': Colors.purple,
    'brown': Colors.brown,
    'black': Colors.black,
    'red': Colors.red,
  };

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
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
                        fontSize: 15,
                        height: 1,
                      )),
                  if (obj['location'] != "")
                    Text("Location: ${obj['location'].toUpperCase()}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: Colors.teal)),
                ],
              ),
              Divider(),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.symmetric(
                    vertical: 0.0, horizontal: 0.0), // Reduced padding
                leading: Icon(Icons.follow_the_signs, size: _iconSize),
                title: Text(
                  "Tournaments",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: _statsPopUpHeaderFontSize),
                ),
                subtitle: Text("Total count of tournaments participated in.",
                    style: TextStyle(
                        height: _lineHeight, fontSize: _statsSubtitleFontSize)),
                trailing: Text(
                    obj['tournaments'] != null
                        ? obj['tournaments'].toString()
                        : "",
                    style: TextStyle(
                        fontSize: _numberSize, fontWeight: FontWeight.bold)),
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.symmetric(
                    vertical: 0.0, horizontal: 0.0), // Reduced padding
                leading: Icon(Icons.filter_1, size: _iconSize),
                title: Text(
                  "1st Place",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: _statsPopUpHeaderFontSize),
                ),
                subtitle: Text("Number of first place wins.",
                    style: TextStyle(
                        height: _lineHeight, fontSize: _statsSubtitleFontSize)),
                trailing: Text(
                    obj['1stplace'] != null ? obj['1stplace'].toString() : "",
                    style: TextStyle(
                        fontSize: _numberSize, fontWeight: FontWeight.bold)),
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.symmetric(
                    vertical: 0.0, horizontal: 0.0), // Reduced padding
                leading: Icon(Icons.filter_2, size: _iconSize),
                title: Text(
                  "2nd Place",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: _statsPopUpHeaderFontSize),
                ),
                subtitle: Text("Number of 2nd place wins.",
                    style: TextStyle(
                        height: _lineHeight, fontSize: _statsSubtitleFontSize)),
                trailing: Text(
                    obj['2ndplace'] != null ? obj['2ndplace'].toString() : "",
                    style: TextStyle(
                        fontSize: _numberSize, fontWeight: FontWeight.bold)),
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.symmetric(
                    vertical: 0.0, horizontal: 0.0), // Reduced padding
                leading: Icon(Icons.store, size: _iconSize),
                title: Text(
                  "Class Merits",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: _statsPopUpHeaderFontSize),
                ),
                subtitle: Text(
                    "Winning a class event, being an outstanding student.",
                    style: TextStyle(
                        height: _lineHeight, fontSize: _statsSubtitleFontSize)),
                trailing: Text(
                    obj['classMerits'] != null
                        ? obj['classMerits'].toString()
                        : "",
                    style: TextStyle(
                        fontSize: _numberSize, fontWeight: FontWeight.bold)),
              ),
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.symmetric(
                    vertical: 0.0, horizontal: 0.0), // Reduced padding
                leading: Icon(Icons.verified, size: _iconSize),
                title: Text(
                  "Good Deeds",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: _statsPopUpHeaderFontSize),
                ),
                subtitle: Text(
                    "Significant good deeds, helping the poor, volunteering, etc.",
                    style: TextStyle(
                        height: _lineHeight, fontSize: _statsSubtitleFontSize)),
                trailing: Text(
                    obj['deeds'] != null ? obj['deeds'].toString() : "",
                    style: TextStyle(
                        fontSize: _numberSize, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 10),
              Divider(),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text("Pushups",
                            style: TextStyle(fontSize: _littleFontSize)),
                        SizedBox(
                          width: _smallSpacing,
                        ),
                        Text(
                          obj['bm_pushups'] != null && obj['bm_pushups'] != 0 ? obj['bm_pushups'].toString() : "",
                          style: TextStyle(
                            fontSize: _littleFontSize, color: Colors.amber,
                            // Set your desired font size here, smaller than the default
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Situps",
                            style: TextStyle(
                              fontSize: _littleFontSize,
                            )),
                        SizedBox(
                          width: _smallSpacing,
                        ),
                        Text(
                          obj['bm_situps'] != null ? obj['bm_situps'].toString() : "",
                          style: TextStyle(
                            fontSize: _littleFontSize, color: Colors.amber,
                            // Set your desired font size here, smaller than the default
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Pullups",
                            style: TextStyle(
                              fontSize: _littleFontSize,
                            )),
                        SizedBox(
                          width: _smallSpacing,
                        ),
                        Text(
                          obj['bm_pullups'] != null ? obj['bm_pullups'].toString() : "",
                          style: TextStyle(
                            fontSize: _littleFontSize, color: Colors.amber,
                            // Set your desired font size here, smaller than the default
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text("Deadhang",
                            style: TextStyle(fontSize: _littleFontSize)),
                        SizedBox(
                          width: _smallSpacing,
                        ),
                        Text(
                          obj['bm_deadhang'] != null ? obj['bm_deadhang'].toString() : "",
                          style: TextStyle(
                            fontSize: _littleFontSize, color: Colors.amber,
                            // Set your desired font size here, smaller than the default
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Mile Time",
                          style: TextStyle(fontSize: _littleFontSize),
                        ),
                        SizedBox(
                          width: _smallSpacing,
                        ),
                        Text(
                          obj['bm_mile'] != null ? obj['bm_mile'].toString() : "",
                          style: TextStyle(
                            fontSize: _littleFontSize, color: Colors.amber,
                            // Set your desired font size here, smaller than the default
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "50m Dash",
                          style: TextStyle(fontSize: _littleFontSize),
                        ),
                        SizedBox(
                          width: _smallSpacing,
                        ),
                        Text(
                          obj['bm_dash'] != null ? obj['bm_dash'].toString() : "",
                          style: TextStyle(
                            fontSize: _littleFontSize, color: Colors.amber,
                            // Set your desired font size here, smaller than the default
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Wallsits",
                          style: TextStyle(fontSize: _littleFontSize),
                        ),
                        SizedBox(
                          width: _smallSpacing,
                        ),
                        Text(
                          obj['bm_wallsits'] != null ? obj['bm_wallsits'].toString() : "",
                          style: TextStyle(
                            fontSize: _littleFontSize, color: Colors.amber,
                            // Set your desired font size here, smaller than the default
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Box-jumps",
                          style: TextStyle(fontSize: _littleFontSize),
                        ),
                        SizedBox(
                          width: _smallSpacing,
                        ),
                        Text(
                          obj['bm_boxjumps'] != null ? obj['bm_boxjumps'].toString() : "",
                          style: TextStyle(
                            fontSize: _littleFontSize, color: Colors.amber,
                            // Set your desired font size here, smaller than the default
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Squats",
                          style: TextStyle(fontSize: _littleFontSize),
                        ),
                        SizedBox(
                          width: _smallSpacing,
                        ),
                        Text(
                          obj['bm_squats'] != null ? obj['bm_squats'].toString() : "",
                          style: TextStyle(
                            fontSize: _littleFontSize, color: Colors.amber,
                            // Set your desired font size here, smaller than the default
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ]),
              SizedBox(height: 20),
              Text("Total Score: ${(obj['score'] ?? "").toString()}",
                  style: TextStyle(
                      fontFamily: 'PTSansNarrow',
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.lightBlue)),
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

  // @override
  // void deactivate() {
  //   _userDBStream.cancel();
  //   _topStudentsDBStream.cancel();
  //   _eventsDBStream.cancel();
  //   super.deactivate();
  // }

  @override
  Widget build(BuildContext context) {
    //double spacingBetween = 16;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    // ======================================================================
    // ======================================================================
    // ======================================================================
    // ======================================================================
    // ======================================================================

    return Container(
      color: Colors.grey[800],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InternetConnection(),
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 10, 10, 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment
                                .spaceBetween, // Adjusted to space between
                            children: [
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("$_firstName $_lastName",
                                        overflow: TextOverflow
                                            .ellipsis, // Adds an ellipsis after the cutoff point
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontFamily: 'PTSansNarrow',
                                            height: .9,
                                            color: Colors.white,
                                            fontSize: 26,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height:_smallSpacing),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.deepPurple,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 8.0),
                                        child: Row(children: [
                                          Icon(
                                            Icons.bar_chart,
                                            color: Colors.green,
                                            size:
                                                24.0, // You can adjust the size as needed
                                          ),
                                          Text("SCORE: ${_score}",
                                              style: TextStyle(
                                                  fontFamily: 'PTSansNarrow',
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold))
                                        ]),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Row(children: [
                                      Icon(
                                        Icons.follow_the_signs,
                                        color: Colors.white60,
                                        size:
                                            15.0, // You can adjust the size as needed
                                      ),
                                      SizedBox(width: 5),
                                      Text("Tournaments:",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: _statsPopUpHeaderFontSize,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(width: 5),
                                      Text(_tournaments.toString(),
                                          style: TextStyle(
                                              color: Colors.amber,
                                              fontSize: _statsPopUpHeaderFontSize,
                                              fontWeight: FontWeight.bold))
                                    ]),
                                    Row(children: [
                                      Icon(
                                        Icons.filter_1,
                                        color: Colors.white60,
                                        size:
                                            15.0, // You can adjust the size as needed
                                      ),
                                      SizedBox(width: 5),
                                      Text("1st Place:",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: _statsPopUpHeaderFontSize,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(width: 5),
                                      Text(_1stPlace.toString(),
                                          style: TextStyle(
                                              color: Colors.amber,
                                              fontSize: _statsPopUpHeaderFontSize,
                                              fontWeight: FontWeight.bold))
                                    ]),
                                    Row(children: [
                                      Icon(
                                        Icons.filter_2,
                                        color: Colors.white60,
                                        size:
                                            15.0, // You can adjust the size as needed
                                      ),
                                      SizedBox(width: 5),
                                      Text("2nd Place:",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: _statsPopUpHeaderFontSize,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(width: 5),
                                      Text(_2ndPlace.toString(),
                                          style: TextStyle(
                                              color: Colors.amber,
                                              fontSize: _statsPopUpHeaderFontSize,
                                              fontWeight: FontWeight.bold))
                                    ]),
                                  ],
                                ),
                              ),
                              Flexible(
                                child: Container(
                                  padding: EdgeInsets.all(
                                      3), // Padding inside the inner border
                                  decoration: BoxDecoration(
                                    shape: BoxShape
                                        .circle, // Outer shape is a circle
                                    border: Border.all(
                                        color: Colors.grey,
                                        width: 2), // Inner border
                                  ),
                                  child: InkWell(
                                    onTap: () => Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) => Avatar())),
                                    child: FluttermojiCircleAvatar(
                                      radius: 65,
                                      backgroundColor: Colors.white54,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: _betweenWidgetPadding),
                BeltsComplex(
                    curriculum: _curriculum,
                    color: _belt,
                    stripes: getStripes(_stripe),
                    hasYellowStripe: _belt == "black" ? true : false),
                SizedBox(height: _betweenWidgetPadding),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.format_quote,
                        color: Colors.green,
                        size: 54.0, // You can adjust the size as needed
                      ),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(_quoteOfTheWeek),
                      )),
                    ],
                  ),
                ),
                SizedBox(height: _betweenWidgetPadding),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: ClipRRect(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 7.0),
                                child: Text(_eventName1,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow
                                        .ellipsis, // Adds an ellipsis after the cutoff point
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'PTSansNarrow',
                                        fontSize: 13)),
                              ),
                              Divider(height: 1),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 5, 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(7.0),
                                      child: Icon(
                                        Icons.calendar_month,
                                        color: Colors.deepOrangeAccent,
                                        size:
                                            35.0, // You can adjust the size as needed
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            (DateFormat('MMM dd, yyyy').format(
                                                    DateTime.parse(
                                                        _eventDate1)))
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: _statsFontSize)),
                                        Text(
                                          _eventLocation1,
                                          style: TextStyle(
                                              fontSize: _statsFontSize),
                                        ),
                                        Text(
                                          '${(_difference1 + 1).toString()} Days Left',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.pink,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: _betweenWidgetPadding),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 7.0),
                              child: Text(_eventName2,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow
                                      .ellipsis, // Adds an ellipsis after the cutoff point
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'PTSansNarrow',
                                      fontSize: 13)),
                            ),
                            Divider(height: 1),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 5, 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(7.0),
                                    child: Icon(
                                      Icons.calendar_month,
                                      color: Colors.orange,
                                      size:
                                          35.0, // You can adjust the size as needed
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          (DateFormat('MMM dd, yyyy').format(
                                                  DateTime.parse(_eventDate2)))
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: _statsFontSize)),
                                      Text(
                                        _eventLocation2,
                                        style:
                                            TextStyle(fontSize: _statsFontSize),
                                      ),
                                      Text(
                                        '${(_difference2 + 1).toString()} Days Left',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.pink,
                                        ),
                                      ),
                                    ],
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
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.vertical(
                  top: Radius.zero, bottom: Radius.circular(10)),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
              child: Text(
                "STUDENT RANKING",
                style: TextStyle(
                  color: Colors.yellow, // Set the text color to yellow
                  fontWeight: FontWeight.bold, // Make the text bold
                  fontSize: 13, // Optional: Set font size
                ),
              ),
            ),
          ),
          Expanded(
            child: DefaultTabController(
              length: 4,
              child: Column(
                children: <Widget>[
                  TabBar(
                    labelPadding:
                        EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    indicatorPadding:
                        EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(
                          child: Text("All",
                              softWrap: true, textAlign: TextAlign.center)),
                      Tab(
                          child: Text("Jawara",
                              softWrap: true, textAlign: TextAlign.center)),
                      Tab(
                          child: Text("Satria",
                              softWrap: true, textAlign: TextAlign.center)),
                      Tab(
                          child: Text("My Belt",
                              softWrap: true, textAlign: TextAlign.center)),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        Container(
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
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                            )),
                                        onPressed: () {
                                          popupStats(
                                              _reversedAllStudentsData[index]);
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
                                                    .tealAccent, // Background color of the circle
                                                shape: BoxShape
                                                    .circle, // Makes the container circular
                                              ),
                                              alignment: Alignment
                                                  .center, // Centers the index text in the circle
                                              child: Text(
                                                (index + 1)
                                                    .toString(), // Displaying the index, starting from 1
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
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
                                                    color: Colors.tealAccent,
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
                                                  color: Colors.tealAccent,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )),
                        Container(
                            color: Colors.black54,
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
                                            backgroundColor: Colors.white10,
                                            padding: EdgeInsets.fromLTRB(
                                                10, 1, 6, 0),
                                            shape: const RoundedRectangleBorder(
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
                                                    fontWeight: FontWeight.bold,
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
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )),
                        Container(
                            color: Colors.black54,
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
                                            backgroundColor: Colors.white10,
                                            padding: EdgeInsets.fromLTRB(
                                                10, 1, 6, 0),
                                            shape: const RoundedRectangleBorder(
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
                                                    fontWeight: FontWeight.bold,
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
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )),
                        Container(
                            color: colorMap[_belt],
                            child: ListView.builder(
                              itemCount: _reversedMyBeltData.length,
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
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                            )),
                                        onPressed: () {
                                          popupStats(
                                              _reversedMyBeltData[index]);
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
                                                    .black, // Background color of the circle
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
                                                    fontWeight: FontWeight.bold,
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
                                                '${_reversedMyBeltData[index]['firstname']} ${_reversedMyBeltData[index]['lastname']}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                softWrap: false,
                                              ),
                                            ),

                                            // Score text aligned to the right
                                            Text(
                                              (_reversedMyBeltData[index]
                                                          ['score'] ??
                                                      "0")
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )),
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
