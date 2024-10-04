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
  int _firstPlaceWins = 0;
  int _secondPlaceWins = 0;
  int _classMerits = 0;
  int _goodDeeds = 0;
  bool _isApprov = false;
  int _finalScore = 0;
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
          _firstPlaceWins = myData['1stplace'];
          _secondPlaceWins = myData['2ndplace'];
          _classMerits = myData['classMerits'];
          _goodDeeds = myData['deeds'];
          _finalScore = myData['score'];
          _tournaments = myData['tournaments'];
          _stripe = myData['stripe'];
          _location = myData['location'];
          firstNameController = TextEditingController(text: _firstName);
          lastNameController = TextEditingController(text: _lastName);
          _age = myData['age'];
        });
      } else {
        print("No data");
      }
    });
  }

  void _getSchoolData() {
    _database.child('locations').once().then((snapshot) {
      final data = new Map<String, dynamic>.from(snapshot.snapshot.value as Map);
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
      _finalScore = (_firstPlaceWins * 10) +
          (_secondPlaceWins * 8) +
          (_tournaments! * 6) +
          (_classMerits) +
          (_goodDeeds);
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
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 32),
        physics: BouncingScrollPhysics(),
        children: [
          Form(
            key: formKey, //key for form
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //SizedBox(height: 8),
                //InternetConnection(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.email, color: Colors.teal),
                        SizedBox(width: _sizeBoxWidth),
                        Text('$_email',
                            style: TextStyle(
                                color: Colors.teal, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Text(_finalScore.toString(),
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrangeAccent))
                  ],
                ),
                SizedBox(height: _sizeBoxHeight),
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
                Row(
                  children: [
                    Row(children: [
                      Icon(Icons.assignment_ind),
                      SizedBox(width: _sizeBoxWidth),
                      Text("Age:"),
                      SizedBox(width: _sizeBoxWidth),
                      DropdownButton<int>(
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
                        items: _listOfAges.map<DropdownMenuItem<int>>((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                      )
                    ]),
                    SizedBox(width: 30),
                    Row(children: [
                      Icon(Icons.list),
                      SizedBox(width: _sizeBoxWidth),
                      Text("Stripe:"),
                      SizedBox(width: _sizeBoxWidth),
                      DropdownButton<int>(
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
                        items:
                            _listOfStripes.map<DropdownMenuItem<int>>((value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value.toString()),
                          );
                        }).toList(),
                      )
                    ]),
                  ],
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.horizontal_split),
                      Text("Belt:"),
                      DropdownButton<String>(
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
                      Icon(Icons.assignment),
                      DropdownButton<String>(
                        value: _curriculum,
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        underline: Container(
                          height: 2,
                        ),
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
                    ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,                  children: [
                    Icon(Icons.place),
                    SizedBox(width: _sizeBoxWidth),
                    Text(
                      "Location",
                    ),
                    SizedBox(width: _sizeBoxWidth),
                    DropdownButton<String>(
                      value: _location,
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      underline: Container(
                        height: 2,
                      ),
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
                  ],
                ),
                Divider(thickness: 2),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.follow_the_signs),
                          SizedBox(width: _sizeBoxWidth),
                          Text("Tourn."),
                          SizedBox(width: _sizeBoxWidth),
                          DropdownButton<int>(
                            value: _tournaments,
                            icon: const Icon(Icons.arrow_downward),
                            iconSize: 24,
                            elevation: 16,
                            underline: Container(
                              height: 2,
                            ),
                            onChanged: (int? newValue) {
                              setState(() {
                                _tournaments = newValue!;
                              });
                              calculateScore();
                            },
                            items: _listOfNumbers
                                .map<DropdownMenuItem<int>>((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text(value.toString()),
                              );
                            }).toList(),
                          ),
                        ],
                      ),

                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.filter_1),
                          SizedBox(width: _sizeBoxWidth),
                          Text("1st Place"),
                          SizedBox(width: _sizeBoxWidth),
                          DropdownButton<int>(
                            value: _firstPlaceWins,
                            icon: const Icon(Icons.arrow_downward),
                            iconSize: 24,
                            elevation: 16,
                            underline: Container(
                              height: 2,
                            ),
                            onChanged: (int? newValue) {
                              setState(() {
                                _firstPlaceWins = newValue!;
                              });
                              calculateScore();
                            },
                            items: _listOfNumbers
                                .map<DropdownMenuItem<int>>((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text(value.toString()),
                              );
                            }).toList(),
                          ),
                        ],
                      ),

                    ],
                  )
                ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.filter_2),
                          SizedBox(width: _sizeBoxWidth),
                          Text("2nd Place"),
                          SizedBox(width: _sizeBoxWidth),
                          DropdownButton<int>(
                            value: _secondPlaceWins,
                            icon: const Icon(Icons.arrow_downward),
                            iconSize: 24,
                            elevation: 16,
                            underline: Container(
                              height: 2,
                            ),
                            onChanged: (int? newValue) {
                              setState(() {
                                _secondPlaceWins = newValue!;
                              });
                              calculateScore();
                            },
                            items: _listOfNumbers
                                .map<DropdownMenuItem<int>>((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text(value.toString()),
                              );
                            }).toList(),
                          ),
                        ],
                      ),

                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.store),
                          SizedBox(width: _sizeBoxWidth),
                          Text("Merits"),
                          SizedBox(width: spacingWidth),
                          DropdownButton<int>(
                            value: _classMerits,
                            icon: const Icon(Icons.arrow_downward),
                            iconSize: 24,
                            elevation: 16,
                            underline: Container(
                              height: 2,
                            ),
                            onChanged: (int? newValue) {
                              setState(() {
                                _classMerits = newValue!;
                              });
                              calculateScore();
                            },
                            items: _listOfNumbers
                                .map<DropdownMenuItem<int>>((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text(value.toString()),
                              );
                            }).toList(),
                          ),
                        ],
                      ),

                    ],
                  )
                ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Icon(Icons.verified),
                  SizedBox(width: spacingWidth),
                  Text("Good Deeds:"),
                  SizedBox(width: spacingWidth),
                  DropdownButton<int>(
                    value: _goodDeeds,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    underline: Container(
                      height: 2,
                    ),
                    onChanged: (int? newValue) {
                      setState(() {
                        _goodDeeds = newValue!;
                      });
                      calculateScore();
                    },
                    items:
                        _listOfNumbers.map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList(),
                  ),
                  SizedBox(width: _sizeBoxWidth),
                ]),
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
    );
  }
}
