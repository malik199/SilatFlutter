import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:silat_flutter/utils/connectivity.dart';

class Benchmarks extends StatefulWidget {
  @override
  State<Benchmarks> createState() => _BenchmarksState();
}

class _BenchmarksState extends State<Benchmarks> {
  final formKey = GlobalKey<FormState>(); //key for form
  User? _currentUser = FirebaseAuth.instance.currentUser;
  final _database = FirebaseDatabase.instance.ref();
  //late StreamSubscription _userDBStream;
  var myUser;

  late String? _firstName = "";
  late String? _lastName = "";
  late int? _1stplace = 0;
  late int? _2ndplace = 0;
  late int? _classMerits = 0;
  late int? _deeds = 0;
  late int? _score = 0;
  late int? _tournaments = 0;
  late int? _stripe = 0;
  late String? _email = "";
  late int? bm_pushups = 0;
  late int? bm_situps = 0;
  late int? bm_pullups = 0;
  late int? bm_deadhang = 0;
  late int? bm_mileTime = 0;
  late int? bm_dash = 0;
  late int? bm_wallsit = 0;
  late int? bm_boxjumps = 0;
  late int? bm_squats = 0;

  List _listOfStripes = [0, 1, 2, 3, 4];

  late String? _dbkey = "";

  TextEditingController? firstNameController = TextEditingController();
  TextEditingController? lastNameController = TextEditingController();

  int _age = 6;
  List _listOfAges = [for (var i = 6; i <= 50; i++) i];
  double _numberSize = 30;
  double _iconSize = 30;
  double _subtitleSize = 10;

  @override
  void initState() {
    super.initState();
    _listOfAges.add(0);
    _getUserData();
  }

  var myData;

  void _getUserData() {
    _database
        .child('users')
        .orderByChild('email')
        .equalTo((_currentUser?.email)?.toLowerCase())
        .once()
        .then((rtdbData) {
      if (rtdbData.snapshot.exists) {
        final data =
        new Map<String, dynamic>.from(rtdbData.snapshot.value as Map);

        data.forEach((key, value) {
          myData = value;
          _dbkey = key;
        });
        setState(() {
          _firstName = myData['firstname'];
          _lastName = myData['lastname'];
          _email = myData['email'];
          _1stplace = myData['1stplace'];
          _2ndplace = myData['2ndplace'];
          _classMerits = myData['classMerits'];
          _deeds = myData['deeds'];
          _score = myData['score'];
          _tournaments = myData['tournaments'];
          _stripe = myData['stripe'];
          firstNameController = TextEditingController(text: _firstName);
          lastNameController = TextEditingController(text: _lastName);
          _age = myData['age'];
          bm_pushups = myData['bm_pushups'];
          bm_situps = myData['bm_situps'];
          bm_pullups = myData['bm_pullups'];
          bm_deadhang = myData['bm_deadhang'];
          bm_mileTime = myData['bm_mile'];
          bm_dash = myData['bm_dash'];
          bm_wallsit = myData['bm_wallsits'];
          bm_boxjumps = myData['bm_boxjumps'];
          bm_squats = myData['bm_squats'];

        });
      } else {
        print("No data");
      }
    });
  }

  final snackBarRed = SnackBar(
    content: Text('A problem occurred.'),
    backgroundColor: Colors.red,
  );
  final snackBarGreen = SnackBar(
    content: Text('Success! You have updated your profile.'),
    backgroundColor: Colors.green,
  );

  /*
  @override
  void deactivate() {
    _userDBStream.cancel();
    super.deactivate();
  }*/

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    double paddingBetween = 24;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.person_outline),
            SizedBox(width: 20),
            const Text('My Benchmarks'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black26,
          ),
          child: Column(children: [
            SizedBox(height: 15),
            Text("My Total Score: ${(_score ?? "").toString()}",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.deepPurple)),
            Column(
              children: [
                ListTile(
                  leading: Icon(Icons.follow_the_signs, size: _iconSize),
                  title: Text(
                    "Tournaments",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("Number of tournaments that you have competed in.", style: TextStyle(fontSize: _subtitleSize)),
                  trailing: Text(
                      _tournaments != null ? _tournaments.toString() : "",
                      style: TextStyle(
                          fontSize: _numberSize, fontWeight: FontWeight.bold)),
                ),
                ListTile(
                  leading: Icon(Icons.filter_1, size: _iconSize),
                  title: Text(
                    "1st Place",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("Number of first place wins.", style: TextStyle(fontSize: _subtitleSize)),
                  trailing: Text(_1stplace != null ? _1stplace.toString() : "",
                      style: TextStyle(
                          fontSize: _numberSize, fontWeight: FontWeight.bold)),
                ),
                ListTile(
                  leading: Icon(Icons.filter_2, size: _iconSize),
                  title: Text(
                    "2nd Place",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("Number of 2nd place wins.", style: TextStyle(fontSize: _subtitleSize)),
                  trailing: Text(_2ndplace != null ? _2ndplace.toString() : "",
                      style: TextStyle(
                          fontSize: _numberSize, fontWeight: FontWeight.bold)),
                ),
                ListTile(
                  leading: Icon(Icons.store, size: _iconSize),
                  title: Text(
                    "Class Merits",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                      "Winning a class event, being an outstanding student in class.", style: TextStyle(fontSize: _subtitleSize)),
                  trailing: Text(
                      _classMerits != null ? _classMerits.toString() : "",
                      style: TextStyle(
                          fontSize: _numberSize, fontWeight: FontWeight.bold)),
                ),
                ListTile(
                  leading: Icon(Icons.airline_seat_flat_angled, size: _iconSize),
                  title: Text(
                    "Pushups",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                      "Number of push-ups a person can complete in one minute to assess upper body strength and endurance.", style: TextStyle(fontSize: _subtitleSize)),
                  trailing: Text(_deeds != null ? _deeds.toString() : "",
                      style: TextStyle(
                          fontSize: _numberSize, fontWeight: FontWeight.bold)),
                ),
                ListTile(
                  leading: Icon(Icons.sledding, size: _iconSize),
                  title: Text(
                    "Situps",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                      "Core strength by counting the number of sit-ups completed in a minute.", style: TextStyle(fontSize: _subtitleSize)),
                  trailing: Text(bm_pushups != null ? bm_pushups.toString() : "",
                      style: TextStyle(
                          fontSize: _numberSize, fontWeight: FontWeight.bold)),
                ),
                ListTile(
                  leading: Icon(Icons.sports_handball, size: _iconSize),
                  title: Text(
                    "Pullups",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                      "Upper body muscular strength by determining the maximum number of pull-ups you can perform.", style: TextStyle(fontSize: _subtitleSize)),
                  trailing: Text(bm_pullups != null ? bm_pullups.toString() : "",
                      style: TextStyle(
                          fontSize: _numberSize, fontWeight: FontWeight.bold)),
                ),
                ListTile(
                  leading: Icon(Icons.handshake, size: _iconSize),
                  title: Text(
                    "Deadhang",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                      "Grip strength and endurance by timing how long a person can hang from a pull-up bar without letting go.", style: TextStyle(fontSize: _subtitleSize)),
                  trailing: Text(bm_deadhang != null ? bm_deadhang.toString() : "",
                      style: TextStyle(
                          fontSize: _numberSize, fontWeight: FontWeight.bold)),
                ),
                ListTile(
                  leading: Icon(Icons.directions_walk, size: _iconSize),
                  title: Text(
                    "Mile Time",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                      "Cardiovascular endurance and speed by timing how quickly a person can run a mile.", style: TextStyle(fontSize: _subtitleSize)),
                  trailing: Text(bm_mileTime != null ? bm_mileTime.toString() : "",
                      style: TextStyle(
                          fontSize: _numberSize, fontWeight: FontWeight.bold)),
                ),
                ListTile(
                  leading: Icon(Icons.directions_run, size: _iconSize),
                  title: Text(
                    "50m Dash",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                      "Explosive power and sprint speed by timing how fast a person can run 50 meters.", style: TextStyle(fontSize: _subtitleSize)),
                  trailing: Text(bm_dash != null ? bm_dash.toString() : "",
                      style: TextStyle(
                          fontSize: _numberSize, fontWeight: FontWeight.bold)),
                ),
                ListTile(
                  leading: Icon(Icons.airline_seat_legroom_normal, size: _iconSize),
                  title: Text(
                    "Wallsit Time",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                      "Lower body strength and endurance by timing how long a person can maintain a wall sit position.", style: TextStyle(fontSize: _subtitleSize)),
                  trailing: Text(bm_wallsit != null ? bm_wallsit.toString() : "",
                      style: TextStyle(
                          fontSize: _numberSize, fontWeight: FontWeight.bold)),
                ),
                ListTile(
                  leading: Icon(Icons.unarchive, size: _iconSize),
                  title: Text(
                    "Box Jumps",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                      "Explosive leg power by counting how many times a person can jump onto and off a specified height box in a set time.", style: TextStyle(fontSize: _subtitleSize)),
                  trailing: Text(bm_boxjumps != null ? bm_boxjumps.toString() : "",
                      style: TextStyle(
                          fontSize: _numberSize, fontWeight: FontWeight.bold)),
                ),
                ListTile(
                  leading: Icon(Icons.airline_seat_legroom_reduced, size: _iconSize),
                  title: Text(
                    "Squats",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                      "Lower body strength and stamina by counting the number of squats completed in one minute.", style: TextStyle(fontSize: _subtitleSize)),
                  trailing: Text(bm_squats != null ? bm_squats.toString() : "",
                      style: TextStyle(
                          fontSize: _numberSize, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
