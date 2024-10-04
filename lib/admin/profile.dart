import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:silat_flutter/utils/connectivity.dart';

import '../models/edit_user.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final formKey = GlobalKey<FormState>(); //key for form
  User? _currentUser = FirebaseAuth.instance.currentUser;
  final _database = FirebaseDatabase.instance.ref();
  //late StreamSubscription _userDBStream;
  var myUser;

  double spacingWidth = 10;
  double spacingHeight = 10;
  String _beltColor = "white";
  String _curriculum = "satria_muda";
  String _location = "VA";
  int? _tournaments = 0;
  int _1stplace = 0;
  int _2ndplace = 0;
  int _classMerits = 0;
  int _deeds = 0;
  bool _isApprov = false;
  int _finalScore = 0;
  late int? bm_pushups = 0;
  late int? bm_situps = 0;
  late int? bm_pullups = 0;
  late int? bm_deadhang = 0;
  late int? bm_mileTime = 0;
  late int? bm_dash = 0;
  late int? bm_wallsit = 0;
  late int? bm_boxjumps = 0;
  late int? bm_squats = 0;

  List<String> _listOfLocations = [];
  List<int> _listOfNumbers = [for (var i = 0; i <= 50; i++) i];
  double _spacingFromEdge = 40;

  late String? _firstName = "";
  late String? _lastName = "";
  late int? _stripe = 0;
  late String? _email = "";

  List _listOfStripes = [0, 1, 2, 3, 4];

  double _sizeBoxWidth = 10;
  double _sizeBoxHeight = 16;

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
    _getSchoolData();
  }

  var myData;

  void showNumberPickerDialog(BuildContext context, void Function(int) onNumberSelected) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Pick a Number"),
          content: Container(
            width: double.maxFinite,
            height: 200,
            child: ListView.builder(
              itemCount: 101, // Adjust range as needed
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text("$index"),
                  onTap: () {
                    onNumberSelected(index);
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

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
          _beltColor = myData['belt'];
          _1stplace = myData['1stplace'];
          _2ndplace = myData['2ndplace'];
          _classMerits = myData['classMerits'];
          _deeds = myData['deeds'];
          _finalScore = myData['score'];
          _tournaments = myData['tournaments'];
          _stripe = myData['stripe'];
          _location = myData['location'];
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

  void _getSchoolData() {
    _database.child('locations').once().then((snapshot) {
      final data =
          new Map<String, dynamic>.from(snapshot.snapshot.value as Map);
      _listOfLocations.add("");
      setState(() {
        data.forEach((key, value) {
          _listOfLocations.add(value['state']);
          print(value['state']);
        });
      });
    });
  }

  void calculateScore() {
    setState(() {
      _finalScore = (_1stplace * 10) +
          (_2ndplace * 8) +
          (_tournaments! * 6) +
          (_classMerits) +
          (_deeds);
    });
  }

  void sendProfileForApproval() async {
    final isValid = formKey.currentState?.validate();
    // FocusScope.of(context).unfocus();

    //print(_currentEmail);
    //print(_dbkey);

    if (isValid!) {
      if (_dbkey == "") {
        await _database
            .child('/users')
            .push()
            .set({
              'uid': _currentUser?.uid,
              'belt': 'white',
              'comments': 'Welcome to Silat martial arts.',
              'curriculum': _age > 11 ? "jawara_muda" : "satria_muda",
              'email': _currentUser?.email,
              'firstname': _firstName,
              'lastname': _lastName,
              'isApproved': false,
              'stripe': _stripe,
              'age': _age,
              'location': 'VA'
            })
            .then((value) =>
                {ScaffoldMessenger.of(context).showSnackBar(snackBarGreen)})
            .catchError((error) =>
                {ScaffoldMessenger.of(context).showSnackBar(snackBarRed)});
      } else {
        _database
            .child('/users')
            .child(_dbkey.toString())
            .update({
              'firstname': _firstName,
              'lastname': _lastName,
              'age': _age,
              'stripe': _stripe,
            })
            .then((value) =>
                {ScaffoldMessenger.of(context).showSnackBar(snackBarGreen)})
            .catchError((error) =>
                {ScaffoldMessenger.of(context).showSnackBar(snackBarRed)});
      }
    }
  }

  final snackBarRed = SnackBar(
    content: Text('A problem occurred.'),
    backgroundColor: Colors.red,
  );
  final snackBarGreen = SnackBar(
    content: Text('Success! You have updated your profile.'),
    backgroundColor: Colors.green,
  );

  get dbItem => null;

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
            const Text('My Profile'),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Form(
              key: formKey, //key for form
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //InternetConnection(),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12.0),
                    child: Column(
                      children: [
                        Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.email, color: Colors.teal),
                              SizedBox(width: _sizeBoxWidth),
                              Text('$_email',
                                  style: TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Text(_finalScore.toString(),
                              style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrangeAccent))
                        ],
                      ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'First Name'),
                          controller: firstNameController,
                          validator: (value) {
                            if (value!.length < 4) {
                              return 'Enter at least 4 characters';
                            } else {
                              return null;
                            }
                          },
                          maxLength: 15,
                          onChanged: (value) =>
                              setState(() => _firstName = value.toString()),
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Last Name'),
                          controller: lastNameController,
                          validator: (value) {
                            if (value!.length < 4) {
                              return 'Enter at least 4 characters';
                            } else {
                              return null;
                            }
                          },
                          maxLength: 15,
                          onChanged: (value) =>
                              setState(() => _lastName = value.toString()),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                      leading: Icon(Icons.assignment_ind, size: _iconSize),
                      title: Text("Age:"),
                      trailing: DropdownButton<int>(
                        value: _age,
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (int? newValue) {
                          setState(() {
                            _age = newValue ?? 0;
                          });
                        },
                        items:
                            _listOfAges.map<DropdownMenuItem<int>>((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                      )),
                  ListTile(
                      leading: Icon(Icons.list, size: _iconSize),
                      title: Text("Stripe:"),
                      trailing: DropdownButton<int>(
                        value: _stripe,
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (int? newValue) {
                          setState(() {
                            _stripe = newValue ?? 0;
                          });
                        },
                        items: _listOfStripes
                            .map<DropdownMenuItem<int>>((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                      )),
                  ListTile(
                      leading:
                        Icon(Icons.horizontal_split, size: _iconSize),
                        title: Text("Belt:"),
                        trailing: DropdownButton<String>(
                            value: _beltColor,
                            icon: Icon(Icons.arrow_downward),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                _beltColor = newValue!;
                              });
                            },
                            items: <String>[
                              'white',
                              'yellow',
                              'green',
                              'blue',
                              'purple',
                              'brown',
                              'black',
                              'red'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList()),
                  ),
                  ListTile(
                          leading: Icon(Icons.assignment, size: _iconSize),
                          title: Text("Curriculum"),
                          trailing: DropdownButton<String>(
                            value: _curriculum,
                            icon: const Icon(Icons.arrow_downward),
                            iconSize: 24,
                            elevation: 16,
                            underline: Container(
                              height: 2,
                            ),
                            style: TextStyle(color: Colors.deepPurple),
                            onChanged: (String? newValue) {
                              setState(() {
                                _curriculum = newValue!;
                              });
                            },
                            items: <String>[
                              'jawara_muda',
                              'satria_muda',
                              'abah_jawara',
                              'guest',
                              'instructor'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          )
                        ),
                  ListTile(
                    leading: Icon(Icons.place),
                      title:    Text(
                        "Location",
                      ),
                      trailing: DropdownButton<String>(
                        value: _location,
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        underline: Container(
                          height: 2,
                        ),
                        style: TextStyle(color: Colors.deepPurple),
                        onChanged: (String? newValue) {
                          setState(() {
                            _location = newValue!;
                          });
                        },
                        items: _listOfLocations
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                  ),
                  Divider(thickness: 2),
                  ListTile(
                    leading: Icon(Icons.follow_the_signs, size: _iconSize),
                    title: Text(
                      "Tournaments",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        "Number of tournaments that you have competed in.",
                        style: TextStyle(fontSize: _subtitleSize)),
                    trailing: Text(
                        _tournaments != null ? _tournaments.toString() : "",
                        style: TextStyle(
                            fontSize: _numberSize,
                            fontWeight: FontWeight.bold)),
                  ),
                  ListTile(
                    leading: Icon(Icons.filter_1, size: _iconSize),
                    title: Text(
                      "1st Place",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Number of first place wins.",
                        style: TextStyle(fontSize: _subtitleSize)),
                    trailing: Text(
                        _1stplace.toString(),
                        style: TextStyle(
                            fontSize: _numberSize,
                            fontWeight: FontWeight.bold)),
                  ),
                  ListTile(
                    leading: Icon(Icons.filter_2, size: _iconSize),
                    title: Text(
                      "2nd Place",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Number of 2nd place wins.",
                        style: TextStyle(fontSize: _subtitleSize)),
                    trailing: Text(
                        _2ndplace.toString(),
                        style: TextStyle(
                            fontSize: _numberSize,
                            fontWeight: FontWeight.bold)),
                  ),
                  ListTile(
                    leading: Icon(Icons.store, size: _iconSize),
                    title: Text(
                      "Class Merits",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        "Winning a class event, being an outstanding student in class.",
                        style: TextStyle(fontSize: _subtitleSize)),
                    trailing: Text(
                        _classMerits.toString(),
                        style: TextStyle(
                            fontSize: _numberSize,
                            fontWeight: FontWeight.bold)),
                  ),
                  ListTile(
                    leading:
                        Icon(Icons.airline_seat_flat_angled, size: _iconSize),
                    title: Text(
                      "Pushups",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        "Number of push-ups a person can complete in one minute to assess upper body strength and endurance.",
                        style: TextStyle(fontSize: _subtitleSize)),
                    trailing: Text(_deeds.toString(),
                        style: TextStyle(
                            fontSize: _numberSize,
                            fontWeight: FontWeight.bold)),
                  ),
                  ListTile(
                    leading: Icon(Icons.sledding, size: _iconSize),
                    title: Text(
                      "Situps",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        "Core strength by counting the number of sit-ups completed in a minute.",
                        style: TextStyle(fontSize: _subtitleSize)),
                    trailing: Text(
                        bm_pushups != null ? bm_pushups.toString() : "",
                        style: TextStyle(
                            fontSize: _numberSize,
                            fontWeight: FontWeight.bold)),
                  ),
                  ListTile(
                    leading: Icon(Icons.sports_handball, size: _iconSize),
                    title: Text(
                      "Pullups",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        "Upper body muscular strength by determining the maximum number of pull-ups you can perform.",
                        style: TextStyle(fontSize: _subtitleSize)),
                    trailing: Text(
                        bm_pullups != null ? bm_pullups.toString() : "",
                        style: TextStyle(
                            fontSize: _numberSize,
                            fontWeight: FontWeight.bold)),
                  ),
                  ListTile(
                    leading: Icon(Icons.handshake, size: _iconSize),
                    title: Text(
                      "Deadhang",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        "Grip strength and endurance by timing how long a person can hang from a pull-up bar without letting go.",
                        style: TextStyle(fontSize: _subtitleSize)),
                    trailing: Text(
                        bm_deadhang != null ? bm_deadhang.toString() : "",
                        style: TextStyle(
                            fontSize: _numberSize,
                            fontWeight: FontWeight.bold)),
                  ),
                  ListTile(
                    leading: Icon(Icons.directions_walk, size: _iconSize),
                    title: Text(
                      "Mile Time",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        "Cardiovascular endurance and speed by timing how quickly a person can run a mile.",
                        style: TextStyle(fontSize: _subtitleSize)),
                    trailing: Text(
                        bm_mileTime != null ? bm_mileTime.toString() : "",
                        style: TextStyle(
                            fontSize: _numberSize,
                            fontWeight: FontWeight.bold)),
                  ),
                  ListTile(
                    leading: Icon(Icons.directions_run, size: _iconSize),
                    title: Text(
                      "50m Dash",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        "Explosive power and sprint speed by timing how fast a person can run 50 meters.",
                        style: TextStyle(fontSize: _subtitleSize)),
                    trailing: Text(bm_dash != null ? bm_dash.toString() : "",
                        style: TextStyle(
                            fontSize: _numberSize,
                            fontWeight: FontWeight.bold)),
                  ),
                  ListTile(
                    leading: Icon(Icons.airline_seat_legroom_normal,
                        size: _iconSize),
                    title: Text(
                      "Wallsit Time",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        "Lower body strength and endurance by timing how long a person can maintain a wall sit position.",
                        style: TextStyle(fontSize: _subtitleSize)),
                    trailing: Text(
                        bm_wallsit != null ? bm_wallsit.toString() : "",
                        style: TextStyle(
                            fontSize: _numberSize,
                            fontWeight: FontWeight.bold)),
                  ),
                  ListTile(
                    leading: Icon(Icons.unarchive, size: _iconSize),
                    title: Text(
                      "Box Jumps",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        "Explosive leg power by counting how many times a person can jump onto and off a specified height box in a set time.",
                        style: TextStyle(fontSize: _subtitleSize)),
                    trailing: Text(
                        bm_boxjumps != null ? bm_boxjumps.toString() : "",
                        style: TextStyle(
                            fontSize: _numberSize,
                            fontWeight: FontWeight.bold)),
                  ),
                  ListTile(
                    leading: Icon(Icons.airline_seat_legroom_reduced,
                        size: _iconSize),
                    title: Text(
                      "Squats",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        "Lower body strength and stamina by counting the number of squats completed in one minute.",
                        style: TextStyle(fontSize: _subtitleSize)),
                    trailing: Text(
                        bm_squats != null ? bm_squats.toString() : "",
                        style: TextStyle(
                            fontSize: _numberSize,
                            fontWeight: FontWeight.bold)),
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  SizedBox(height: _sizeBoxHeight),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(12.0),
                            ),
                            backgroundColor: Colors.purple,
                            foregroundColor: Colors.white,
                            textStyle: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        icon: Icon(Icons.save),
                        label: Text("Submit for Approval",
                            style: TextStyle(color: Colors.white)),
                        onPressed: () => sendProfileForApproval())
                  ])
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
