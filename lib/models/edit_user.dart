import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class EditUserWidget extends StatefulWidget {
  const EditUserWidget({
    Key? key,
    required this.dbItem,
    required this.dbkey,
  }) : super(key: key);

  final dbItem;
  final dbkey;
  @override
  _EditUserWidgetState createState() => _EditUserWidgetState();
}

class _EditUserWidgetState extends State<EditUserWidget> {
  DatabaseReference _database = FirebaseDatabase.instance.reference();

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
    _getSchoolData();
    super.initState();
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
          title: new Text("You are about to delete user '${widget.dbItem['firstname'].toUpperCase()} ${widget.dbItem['lastname'].toUpperCase()}'"),
          content: new Text("Are you sure you want delete this user? Email: ${widget.dbItem['email']}"),
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
                    .reference()
                    .child('users')
                    .child(dbKey)
                    .remove()
                    .whenComplete(() {
                  print("User Deleted!");
                  Navigator.pop(context, true);
                }).catchError((error) {
                  print("Problem Deleting Item: ${error}");
                });
              },
              child: const Text('Delete'),
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(width: _spacingFromEdge),
              Icon(Icons.email),
              SizedBox(width: spacingWidth),
              Text(widget.dbItem?['email']),
            ],
          ),
          SizedBox(height: spacingHeight),
          Row(children: [
            SizedBox(width: _spacingFromEdge),
            Icon(Icons.horizontal_split),
            SizedBox(width: spacingWidth),
            DropdownButton<String>(
              value: _beltColor,
              icon: const Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
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
              }).toList(),
            ),
            SizedBox(width: 36),
            Icon(Icons.assignment),
            SizedBox(width: spacingWidth),
            DropdownButton<String>(
              value: _curriculum,
              icon: const Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
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
            children: [
              SizedBox(width: _spacingFromEdge),
              Icon(Icons.thumb_up_alt),
              SizedBox(width: spacingWidth),
              Text(
                "Approval",
                style: TextStyle(fontSize: 15),
              ),
              Switch(
                  value: _isApprov,
                  onChanged: (bool value) {
                    setState(() => _isApprov = value);
                  }),
              SizedBox(width: 20),
              Icon(Icons.place),
              DropdownButton<String>(
                value: _location,
                icon: const Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
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
          SizedBox(height: 20),
          Row(children: [
            SizedBox(width: _spacingFromEdge),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.follow_the_signs),
                    SizedBox(width: 10),
                    Text("Tournaments"),
                  ],
                ),
                DropdownButton<int>(
                  value: _tournaments,
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
                      _tournaments = newValue!;
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
            SizedBox(width: 54),
            Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.filter_1),
                    SizedBox(width: 10),
                    Text("1st Place Wins"),
                  ],
                ),
                DropdownButton<int>(
                  value: _firstPlaceWins,
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
                      _firstPlaceWins = newValue!;
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
            )
          ]),
          SizedBox(height: 30),
          Row(children: [
            SizedBox(width: _spacingFromEdge),
            Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.filter_2),
                    SizedBox(width: spacingWidth),
                    Text("2nd Place Wins"),
                  ],
                ),
                SizedBox(width: spacingWidth),
                DropdownButton<int>(
                  value: _secondPlaceWins,
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
                      _secondPlaceWins = newValue!;
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
            SizedBox(width: 36),
            Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.store),
                    SizedBox(width: 8),
                    Text("Class Merits"),
                  ],
                ),
                SizedBox(width: spacingWidth),
                DropdownButton<int>(
                  value: _classMerits,
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
                      _classMerits = newValue!;
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
            )
          ]),
          SizedBox(height: 20),
          Row(children: [
            SizedBox(width: _spacingFromEdge),
            Icon(Icons.verified),
            SizedBox(width: spacingWidth),
            Text("Good Deeds:"),
            SizedBox(width: spacingWidth),
            DropdownButton<int>(
              value: _goodDeeds,
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
            SizedBox(width: 50),
            Text(_finalScore.toString(),
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurpleAccent))
          ]),
          Divider(
            thickness: 2,
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(12.0),
                        ),
                        primary: Colors.purple,
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        textStyle: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    icon: Icon(Icons.save),
                    label: Text("Update Profile"),
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
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
