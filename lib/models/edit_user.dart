import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class EditUserWidget extends StatefulWidget {
  const EditUserWidget({
    Key? key,
    required this.dbItem,
    required this.dbkey,
    required this.editMode,
  }) : super(key: key);

  final dbItem;
  final dbkey;
  final editMode;
  @override
  _EditUserWidgetState createState() => _EditUserWidgetState();
}

class _EditUserWidgetState extends State<EditUserWidget> {
  DatabaseReference _database = FirebaseDatabase.instance.ref();

  double spacingWidth = 10;
  double spacingHeight = 10;
  String _beltColor = "";
  String _curriculum = "";
  String _location = "";
  int _tournaments = 0;
  int _firstPlaceWins = 0;
  int _secondPlaceWins = 0;
  int _classMerits = 0;
  int _goodDeeds = 0;
  bool _isApprov = false;
  int _finalScore = 0;
  List<String> _listOfLocations = [];
  List<int> _listOfNumbers = [for (var i = 0; i <= 50; i++) i];
  int _pushups = 0;
  int _situps = 0;
  int _pullups = 0;
  String _deadhang = "";
  String _mile = "";
  String _dash = "";
  String _wallsit = "";
  int _boxJump = 0;
  int _squats = 0;

  @override
  void initState() {
    _beltColor = widget.dbItem?['belt'];
    _curriculum = widget.dbItem?['curriculum'];
    _isApprov = widget.dbItem?['isApproved'];
    _tournaments = widget.dbItem?['tournaments'] ?? 0;
    _firstPlaceWins = widget.dbItem?['1stplace'] ?? 0;
    _secondPlaceWins = widget.dbItem?['2ndplace'] ?? 0;
    _classMerits = widget.dbItem?['classMerits'] ?? 0;
    _goodDeeds = widget.dbItem?['deeds'] ?? 0;
    _finalScore = widget.dbItem?['score'] ?? 0;
    _location = widget.dbItem?['location'] ?? "";
    // bench marks
    _pushups = widget.dbItem?['bm_pushups'] ?? 0;
    _situps = widget.dbItem?['bm_situps'] ?? 0;
    _pullups = widget.dbItem?['bm_pullups'] ?? 0;
    _deadhang = widget.dbItem?['bm_deadhang'] ?? '0:00';
    _mile = widget.dbItem?['bm_mile'] ?? '0:00';
    _dash = widget.dbItem?['bm_dash'] ?? '0:00';
    _wallsit = widget.dbItem?['bm_wallsits'] ?? '0:00';
    _boxJump = widget.dbItem?['bm_boxjumps'] ?? 0;
    _squats = widget.dbItem?['bm_squats'] ?? 0;

    _getSchoolData();
    super.initState();
  }

  void _getSchoolData() {
    _database.child('locations').once().then((snapshot) {
      final data =
          new Map<String, dynamic>.from(snapshot.snapshot.value as Map);
      _listOfLocations.add("");
      setState(() {
        data.forEach((key, value) {
          _listOfLocations.add(value['state']);
        });
      });
    });
  }

  void calculateScore() {
    setState(() {
      _finalScore = (_firstPlaceWins * 10) +
          (_secondPlaceWins * 8) +
          (_tournaments * 6) +
          (_classMerits) +
          (_goodDeeds);
    });
  }

  void deleteItem(dbKey) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
              "You are about to delete user '${widget.dbItem['firstname'].toUpperCase()} ${widget.dbItem['lastname'].toUpperCase()}'"),
          content: new Text(
              "Are you sure you want delete this user? Email: ${widget.dbItem['email']}"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                FirebaseDatabase.instance
                    .ref()
                    .child('users')
                    .child(dbKey)
                    .remove()
                    .whenComplete(() {
                  print("User Deleted!");
                  Navigator.pop(context, true);
                }).catchError((error) {
                  print("Problem Deleting Item: $error");
                });
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void deletePendingItem(dbKey) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
              "You are about to pending updates for '${widget.dbItem['firstname'].toUpperCase()} ${widget.dbItem['lastname'].toUpperCase()}'"),
          content: new Text(
              "Are you sure you want remove these pending changes for ${widget.dbItem['email']}"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                FirebaseDatabase.instance
                    .ref()
                    .child('pending')
                    .child(dbKey)
                    .remove()
                    .whenComplete(() {
                  print("User Deleted!");
                  Navigator.pop(context, true);
                }).catchError((error) {
                  print("Problem Deleting Item: $error");
                });
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Widget submitButton(BuildContext context){
    if(widget.editMode == 'pending') {
      return Row(
        children: [
          Expanded(
            flex: 4,
            child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(12.0),
                    ),
                    backgroundColor: Colors.pinkAccent,
                    foregroundColor: Colors.white,
                    textStyle: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                icon: Icon(Icons.save),
                label: Text("Approve Pending Changes",
                    style: TextStyle(color: Colors.white, fontFamily: 'PTSansNarrow',)),
                onPressed: () {
                  _showConfirmationDialog(context);
                }),

          ),
          Expanded(
            flex: 1,
            child: TextButton.icon(
              onPressed: () {
                deletePendingItem(widget.dbkey);
              },
              icon: Icon(Icons.delete, size: 30),
              label: SizedBox.shrink(),
            ),
          )
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            flex: 3,
            child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(12.0),
                    ),
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    padding:
                    EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    textStyle: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                icon: Icon(Icons.save),
                label: Text("Update Profile",
                    style: TextStyle(color: Colors.white, fontFamily: 'PTSansNarrow',)),
                onPressed: () {
                  _database
                      .child('/users')
                      .child(widget.dbkey)
                      .update({
                    'belt': _beltColor,
                    'curriculum': _curriculum,
                    'isApproved': _isApprov,
                    'tournaments': _tournaments,
                    '1stplace': _firstPlaceWins,
                    '2ndplace': _secondPlaceWins,
                    'classMerits': _classMerits,
                    'deeds': _goodDeeds,
                    'score': _finalScore,
                    'location': _location
                  })
                      .then((value) => ScaffoldMessenger.of(context)
                      .showSnackBar(snackBarGreen))
                      .catchError((error) => ScaffoldMessenger.of(context)
                      .showSnackBar(snackBarRed));
                }),
          ),
          Expanded(
            flex: 1,
            child: TextButton.icon(
              onPressed: () {
                deleteItem(widget.dbkey);
              },
              icon: Icon(Icons.delete, size: 30),
              label: SizedBox.shrink(),
            ),
          )
        ],
      );
    }
  }

  void _showConfirmationDialog(BuildContext context) {
    // Show dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text("Are you sure you want to approve these changes?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Here you can add your action for approval
                print("Changes Approved!");
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green,
                      content: Text("Changes have been approved!!", style: TextStyle(color: Colors.white)),
                      duration: Duration(seconds: 2), // How long to show the Snackbar
                    )
                );
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: Text("Approve"),
            ),
          ],
        );
      },
    );
  }

  final snackBarRed = SnackBar(
    content: Text('A problem occurred.'),
    backgroundColor: Colors.red,
  );
  final snackBarGreen = SnackBar(
    content: Text('Success! You have updated the user.'),
    backgroundColor: Colors.green,
  );

  @override
  Widget build(BuildContext context) {
    double _spacingFromEdge = 40;
    double _smallSpacing = 5;
    double _mediumSpacing = 15;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.email),
                    SizedBox(width: _smallSpacing),
                    Text(widget.dbItem?['email']),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.horizontal_split),
                    SizedBox(width: _smallSpacing),
                    DropdownButton<String>(
                      value: _beltColor,
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      underline: Container(
                        height: 2,
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
                      }).toList(),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.assignment),
                    SizedBox(width: _smallSpacing),
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
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.place),
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
                Row(
                  children: [
                    Icon(Icons.thumb_up_alt, color: Colors.green),
                    Switch(
                        value: _isApprov,
                        onChanged: (bool value) {
                          setState(() => _isApprov = value);
                        }),
                  ],
                ),
              ],
            ),
            Divider(thickness: 2),
            SizedBox(height: _smallSpacing),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.follow_the_signs),
                      SizedBox(width: _smallSpacing),
                      Text("Tournaments:"),
                      SizedBox(width: _smallSpacing),
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
                      SizedBox(width: _smallSpacing),
                      Text("1st Places:"),
                      SizedBox(width: _smallSpacing),
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
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.filter_2),
                      SizedBox(width: _smallSpacing),
                      Text("2nd Places:"),
                      SizedBox(width: _smallSpacing),
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
                      SizedBox(width: _smallSpacing),
                      Text("Class Merits:"),
                      SizedBox(width: _smallSpacing),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              Row(
                children: [
                  Icon(Icons.verified),
                  SizedBox(width: _smallSpacing),
                  Text("Good Deeds: "),
                  DropdownButton<int>(
                    value: _goodDeeds,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    underline: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Container(
                          height: 2,
                        ),
                      ),
                    ),
                    onChanged: (int? newValue) {
                      setState(() {
                        _goodDeeds = newValue!;
                      });
                      calculateScore();
                    },
                    items: _listOfNumbers.map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList(),
                  ),
                ],
              ),
              Text(_finalScore.toString(),
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrangeAccent))
            ]),
            Divider(
              thickness: 2,
            ),
            Row(children: [
              Text('Pushups: '),
              Text(_pushups.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber,)),
              SizedBox(width: _mediumSpacing),
              Text('Situps: '),
              Text(_situps.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber,)),
              SizedBox(width: _mediumSpacing),
              Text('Pullups: '),
              Text(_pullups.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber,)),
            ]),
            Row(children: [
              Text('Deadhang: '),
              Text(_deadhang, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber,)),
              SizedBox(width: _mediumSpacing),
              Text('Mile: '),
              Text(_mile, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber,)),
              SizedBox(width: _mediumSpacing),
              Text('50m-Dash: '),
              Text(_dash, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber,)),
            ]),
            Row(children: [
              Text('Wallsit: '),
              Text(_wallsit, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber,)),
              SizedBox(width: _mediumSpacing),
              Text('Box-jumps: '),
              Text(_boxJump.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber,)),
              SizedBox(width: _mediumSpacing),
              Text('Squats: '),
              Text(_squats.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber,)),
            ]),
            SizedBox(height: _mediumSpacing),
            submitButton(context),
            SizedBox(height: _mediumSpacing),
          ],
        ),
      ),
    );
  }
}
