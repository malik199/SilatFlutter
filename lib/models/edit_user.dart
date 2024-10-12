import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/services.dart';

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
  final HttpsCallable callable =
      FirebaseFunctions.instance.httpsCallable('transferUserData');
  final formKey = GlobalKey<FormState>();

  double spacingWidth = 10;
  double spacingHeight = 10;

  late String? _firstName = "";
  late String? _lastName = "";
  late int? _stripe = 0;
  late String? _email = "";
  int _age = 6;

  String _beltColor = "";
  String _curriculum = "";
  String _location = "";
  int _tournaments = 0;
  int _1stplace = 0;
  int _2ndplace = 0;
  int _classMerits = 0;
  int _deeds = 0;
  bool _isApprov = false;
  int _finalScore = 0;
  List<String> _listOfLocations = [];
  List<int> _listOfNumbers = [for (var i = 0; i <= 50; i++) i];
  List _listOfAges = [for (var i = 5; i <= 50; i++) i];

  late int? bm_pushups = 0;
  late int? bm_situps = 0;
  late int? bm_pullups = 0;
  late String? bm_deadhang;
  late String? bm_mile;
  late String? bm_dash;
  late String? bm_wallsits;
  late int? bm_boxjumps = 0;
  late int? bm_squats = 0;

  TextEditingController? _firstNameController = TextEditingController();
  TextEditingController? _lastNameController = TextEditingController();

  TextEditingController? _bm_pushupsController = TextEditingController();
  TextEditingController? _bm_situpsController = TextEditingController();
  TextEditingController? _bm_pullupsController = TextEditingController();
  TextEditingController? _bm_deadhangController = TextEditingController();
  TextEditingController? _bm_mileTimeController = TextEditingController();
  TextEditingController? _bm_dashController = TextEditingController();
  TextEditingController? _bm_wallSitController = TextEditingController();
  TextEditingController? _bm_boxJumpsController = TextEditingController();
  TextEditingController? _bm_squatsController = TextEditingController();

  @override
  void initState() {
    _firstName = widget.dbItem?['firstname'];
    _lastName = widget.dbItem?['lastname'];
    _age = widget.dbItem?['age'] ?? 0;
    _email = widget.dbItem?['email'];
    _beltColor = widget.dbItem?['belt'];
    _curriculum = widget.dbItem?['curriculum'];
    _isApprov = widget.dbItem?['isApproved'];
    _tournaments = widget.dbItem?['tournaments'] ?? 0;
    _1stplace = widget.dbItem?['1stplace'] ?? 0;
    _2ndplace = widget.dbItem?['2ndplace'] ?? 0;
    _classMerits = widget.dbItem?['classMerits'] ?? 0;
    _deeds = widget.dbItem?['deeds'] ?? 0;
    _finalScore = widget.dbItem?['score'] ?? 0;
    _location = widget.dbItem?['location'] ?? "";
    // bench marks
    bm_pushups = widget.dbItem?['bm_pushups'] ?? 0;
    bm_situps = widget.dbItem?['bm_situps'] ?? 0;
    bm_pullups = widget.dbItem?['bm_pullups'] ?? 0;
    bm_deadhang = widget.dbItem?['bm_deadhang'] ?? '0:00';
    bm_mile = widget.dbItem?['bm_mile'] ?? '0:00';
    bm_dash = widget.dbItem?['bm_dash'] ?? '0:00';
    bm_wallsits = widget.dbItem?['bm_wallsits'] ?? '0:00';
    bm_boxjumps = widget.dbItem?['bm_boxjumps'] ?? 0;
    bm_squats = widget.dbItem?['bm_squats'] ?? 0;

    _firstNameController =
        TextEditingController(text: widget.dbItem?['firstname']);
    _lastNameController =
        TextEditingController(text: widget.dbItem?['lastname']);

    _bm_pushupsController = TextEditingController(
        text: widget.dbItem?['bm_pushups'] == null
            ? '0'
            : widget.dbItem?['bm_pushups'].toString());
    _bm_pullupsController = TextEditingController(
        text: widget.dbItem?['bm_pullups'] == null
            ? '0'
            : widget.dbItem?['bm_pullups'].toString());
    _bm_situpsController = TextEditingController(
        text: widget.dbItem?['bm_situps'] == null
            ? '0'
            : widget.dbItem?['bm_situps'].toString());
    _bm_deadhangController = TextEditingController(
        text: widget.dbItem?['bm_deadhang'] == null
            ? '0:00'
            : widget.dbItem?['bm_deadhang'].toString());
    _bm_mileTimeController = TextEditingController(
        text: widget.dbItem?['bm_mile'] == null
            ? '0:00'
            : widget.dbItem?['bm_mile'].toString());
    _bm_dashController = TextEditingController(
        text: widget.dbItem?['bm_dash'] == null
            ? '0:00'
            : widget.dbItem?['bm_dash'].toString());
    _bm_wallSitController = TextEditingController(
        text: widget.dbItem?['bm_wallsits'] == null
            ? '0:00'
            : widget.dbItem?['bm_wallsits'].toString());
    _bm_boxJumpsController = TextEditingController(
        text: widget.dbItem?['bm_boxjumps'] == null
            ? '0'
            : widget.dbItem?['bm_boxjumps'].toString());
    _bm_squatsController = TextEditingController(
        text: widget.dbItem?['bm_squats'] == null
            ? '0'
            : widget.dbItem?['bm_squats'].toString());

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
      _finalScore = (_1stplace * 10) +
          (_2ndplace * 8) +
          (_tournaments * 6) +
          (_classMerits) +
          (_deeds);
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

  Widget submitButton(BuildContext context) {
    if (widget.editMode == 'pending') {
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
                    textStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                icon: Icon(Icons.save),
                label: Text("Approve Changes",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'PTSansNarrow',
                    )),
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
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    textStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                icon: Icon(Icons.save),
                label: Text("Update Profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'PTSansNarrow',
                    )),
                onPressed: () {
                  _database
                      .child('/users')
                      .child(widget.dbkey)
                      .update({
                        'firstname': _firstName,
                        'lastname': _lastName,
                        'belt': _beltColor,
                        'stripe': _stripe,
                        'age': _age,
                        'curriculum': _curriculum,
                        'isApproved': _isApprov,
                        'tournaments': _tournaments,
                        '1stplace': _1stplace,
                        '2ndplace': _2ndplace,
                        'classMerits': _classMerits,
                        'deeds': _deeds,
                        'score': _finalScore,
                        'location': _location,
                        'bm_boxjumps': bm_boxjumps,
                        'bm_dash': bm_dash,
                        'bm_deadhang': bm_deadhang,
                        'bm_mile': bm_mile,
                        'bm_pullups': bm_pullups,
                        'bm_pushups': bm_pushups,
                        'bm_situps': bm_situps,
                        'bm_squats': bm_squats,
                        'bm_wallsits': bm_wallsits,
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
                _approveChanges(widget.dbkey);
                print("Changes Approved!");
                /* ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green,
                      content: Text("Changes have been approved!!", style: TextStyle(color: Colors.white)),
                      duration: Duration(seconds: 2), // How long to show the Snackbar
                    )
                ); */
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: Text("Approve"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _approveChanges(String dbKey) async {
    final HttpsCallableResult result = await callable.call(<String, dynamic>{
      'dbKey': dbKey,
    });
  }

  @override
  void dispose() {
    super.dispose();
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
    double _smallerText = 12;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical:  0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.email, color: Colors.teal),
                  SizedBox(width: _smallSpacing),
                  Text('$_email',
                      style: TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: _mediumSpacing,),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'First Name',
                  isDense: true,
                ),
                controller: _firstNameController,
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
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  isDense: true,
                ),
                controller: _lastNameController,
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
                          'instructor',
                          'guest',
                          'abah_jawara'
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
                      Text("Location: "),
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
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.assignment_ind),
                      SizedBox(width: _smallSpacing),
                      Text("Age:"),
                      SizedBox(width: _smallSpacing),
                      DropdownButton<int>(
                        value: _age,
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Colors.amber),
                        underline: Container(
                          height: 2,
                          color: Colors.amberAccent,
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
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.thumb_up_alt, color: Colors.green),
                      SizedBox(width: _smallSpacing),
                      Text("Approved:"),
                      SizedBox(width: _smallSpacing),
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
                        Text("Tournaments:",
                            style: TextStyle(fontSize: _smallerText)),
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
                        Text("1st Places:",
                            style: TextStyle(fontSize: _smallerText)),
                        SizedBox(width: _smallSpacing),
                        DropdownButton<int>(
                          value: _1stplace,
                          icon: const Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          underline: Container(
                            height: 2,
                          ),
                          onChanged: (int? newValue) {
                            setState(() {
                              _1stplace = newValue!;
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
                        Text("2nd Places:",
                            style: TextStyle(fontSize: _smallerText)),
                        SizedBox(width: _smallSpacing),
                        DropdownButton<int>(
                          value: _2ndplace,
                          icon: const Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          underline: Container(
                            height: 2,
                          ),
                          onChanged: (int? newValue) {
                            setState(() {
                              _2ndplace = newValue!;
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
                        Text("Class Merits:",
                            style: TextStyle(fontSize: _smallerText)),
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
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(
                  children: [
                    Icon(Icons.verified),
                    SizedBox(width: _smallSpacing),
                    Text("Good Deeds: ",
                        style: TextStyle(fontSize: _smallerText)),
                    DropdownButton<int>(
                      value: _deeds,
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
                          _deeds = newValue!;
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
                Text(_finalScore.toString(),
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrangeAccent))
              ]),
              Divider(
                thickness: 2,
              ),
              SizedBox(
                height: _smallSpacing,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text("Pushups",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: _smallerText)),
                        SizedBox(
                          width: _smallSpacing,
                        ),
                        TextField(
                          textAlign: TextAlign.center,
                          controller: _bm_pushupsController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border:
                                OutlineInputBorder(), // Adds a border around the input
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 1.0,
                                horizontal: 1.0), // Padding inside the border
                            isDense: true, // Reduces the field's height
                            counterText:
                                '', // Hides the counter text that appears below the TextField
                            constraints: BoxConstraints(
                              maxWidth:
                                  40, // Adjust width to fit about 5 digits
                            ),
                          ),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^[0-9:.]*$'))
                            // Limiting the input to 5 characters
                          ],
                          onSubmitted: (String newValue) {
                            if (newValue == "") {
                              newValue = '0';
                            }
                            setState(() => bm_pushups = newValue as int?);
                          },
                          style: TextStyle(
                            fontSize: 14.0, color: Colors.amber,
                            // Set your desired font size here, smaller than the default
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Situps",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: _smallerText)),
                        SizedBox(
                          width: _smallSpacing,
                        ),
                        TextField(
                          textAlign: TextAlign.center,
                          controller: _bm_situpsController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border:
                                OutlineInputBorder(), // Adds a border around the input
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 1.0,
                                horizontal: 1.0), // Padding inside the border
                            isDense: true, // Reduces the field's height
                            counterText:
                                '', // Hides the counter text that appears below the TextField
                            constraints: BoxConstraints(
                              maxWidth:
                                  40, // Adjust width to fit about 5 digits
                            ),
                          ),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^[0-9:.]*$'))
                            // Limiting the input to 5 characters
                          ],
                          onSubmitted: (String newValue) {
                            if (newValue == "") {
                              newValue = '0';
                            }
                            setState(() => bm_situps = newValue as int?);
                          },
                          style: TextStyle(
                            fontSize: 14.0, color: Colors.amber,
                            // Set your desired font size here, smaller than the default
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Pullups", style: TextStyle(fontSize: _smallerText)),
                        SizedBox(
                          width: _smallSpacing,
                        ),
                        TextField(
                          textAlign: TextAlign.center,
                          controller: _bm_pullupsController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border:
                                OutlineInputBorder(), // Adds a border around the input
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 1.0,
                                horizontal: 1.0), // Padding inside the border
                            isDense: true, // Reduces the field's height
                            counterText:
                                '', // Hides the counter text that appears below the TextField
                            constraints: BoxConstraints(
                              maxWidth:
                                  40, // Adjust width to fit about 5 digits
                            ),
                          ),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^[0-9:.]*$'))
                            // Limiting the input to 5 characters
                          ],
                          onSubmitted: (String newValue) {
                            if (newValue == "") {
                              newValue = '0';
                            }
                            setState(() => bm_pullups = newValue as int?);
                          },
                          style: TextStyle(
                            fontSize: 14.0, color: Colors.amber,
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
                        Text("Deadhang", style: TextStyle(fontSize: _smallerText)),
                        SizedBox(
                          width: _smallSpacing,
                        ),
                        TextField(
                          textAlign: TextAlign.center,
                          controller: _bm_deadhangController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border:
                                OutlineInputBorder(), // Adds a border around the input
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 1.0,
                                horizontal: 1.0), // Padding inside the border
                            isDense: true, // Reduces the field's height
                            counterText:
                                '', // Hides the counter text that appears below the TextField
                            constraints: BoxConstraints(
                              maxWidth:
                                  40, // Adjust width to fit about 5 digits
                            ),
                          ),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^[0-9:.]*$'))
                            // Limiting the input to 5 characters
                          ],
                          onSubmitted: (String newValue) {
                            if (newValue == "") {
                              newValue = '0';
                            }
                            setState(() => bm_deadhang = newValue);
                          },
                          style: TextStyle(
                            fontSize: 14.0, color: Colors.amber,
                            // Set your desired font size here, smaller than the default
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Mile Time", style: TextStyle(fontSize: _smallerText)),
                        SizedBox(
                          width: _smallSpacing,
                        ),
                        TextField(
                          textAlign: TextAlign.center,
                          controller: _bm_mileTimeController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border:
                                OutlineInputBorder(), // Adds a border around the input
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 1.0,
                                horizontal: 1.0), // Padding inside the border
                            isDense: true, // Reduces the field's height
                            counterText:
                                '', // Hides the counter text that appears below the TextField
                            constraints: BoxConstraints(
                              maxWidth:
                                  40, // Adjust width to fit about 5 digits
                            ),
                          ),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^[0-9:.]*$'))
                            // Limiting the input to 5 characters
                          ],
                          onSubmitted: (String newValue) {
                            if (newValue == "") {
                              newValue = '0';
                            }
                            setState(() => bm_mile = newValue);
                          },
                          style: TextStyle(
                            fontSize: 14.0, color: Colors.amber,
                            // Set your desired font size here, smaller than the default
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("50m Dash", style: TextStyle(fontSize: _smallerText)),
                        SizedBox(
                          width: _smallSpacing,
                        ),
                        TextField(
                          textAlign: TextAlign.center,
                          controller: _bm_dashController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border:
                                OutlineInputBorder(), // Adds a border around the input
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 1.0,
                                horizontal: 1.0), // Padding inside the border
                            isDense: true, // Reduces the field's height
                            counterText:
                                '', // Hides the counter text that appears below the TextField
                            constraints: BoxConstraints(
                              maxWidth:
                                  40, // Adjust width to fit about 5 digits
                            ),
                          ),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^[0-9:.]*$'))
                            // Limiting the input to 5 characters
                          ],
                          onSubmitted: (String newValue) {
                            if (newValue == "") {
                              newValue = '0';
                            }
                            setState(() => bm_dash = newValue);
                          },
                          style: TextStyle(
                            fontSize: 14.0, color: Colors.amber,
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
                        Text("Wallsits", style: TextStyle(fontSize: _smallerText)),
                        SizedBox(
                          width: _smallSpacing,
                        ),
                        TextField(
                          textAlign: TextAlign.center,
                          controller: _bm_wallSitController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border:
                                OutlineInputBorder(), // Adds a border around the input
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 1.0,
                                horizontal: 1.0), // Padding inside the border
                            isDense: true, // Reduces the field's height
                            counterText:
                                '', // Hides the counter text that appears below the TextField
                            constraints: BoxConstraints(
                              maxWidth:
                                  40, // Adjust width to fit about 5 digits
                            ),
                          ),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^[0-9:.]*$'))
                            // Limiting the input to 5 characters
                          ],
                          onSubmitted: (String newValue) {
                            if (newValue == "") {
                              newValue = '0';
                            }
                            setState(() => bm_wallsits = newValue);
                          },
                          style: TextStyle(
                            fontSize: 14.0, color: Colors.amber,
                            // Set your desired font size here, smaller than the default
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Box-jumps", style: TextStyle(fontSize: _smallerText)),
                        SizedBox(
                          width: _smallSpacing,
                        ),
                        TextField(
                          textAlign: TextAlign.center,
                          controller: _bm_boxJumpsController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border:
                                OutlineInputBorder(), // Adds a border around the input
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 1.0,
                                horizontal: 1.0), // Padding inside the border
                            isDense: true, // Reduces the field's height
                            counterText:
                                '', // Hides the counter text that appears below the TextField
                            constraints: BoxConstraints(
                              maxWidth:
                                  40, // Adjust width to fit about 5 digits
                            ),
                          ),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^[0-9:.]*$'))
                            // Limiting the input to 5 characters
                          ],
                          onSubmitted: (String newValue) {
                            if (newValue == "") {
                              newValue = '0';
                            }
                            setState(() => bm_boxjumps = newValue as int?);
                          },
                          style: TextStyle(
                            fontSize: 14.0, color: Colors.amber,
                            // Set your desired font size here, smaller than the default
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Squats", style: TextStyle(fontSize: _smallerText)),
                        SizedBox(
                          width: _smallSpacing,
                        ),
                        TextField(
                          textAlign: TextAlign.center,
                          controller: _bm_squatsController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border:
                                OutlineInputBorder(), // Adds a border around the input
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 1.0,
                                horizontal: 1.0), // Padding inside the border
                            isDense: true, // Reduces the field's height
                            counterText:
                                '', // Hides the counter text that appears below the TextField
                            constraints: BoxConstraints(
                              maxWidth:
                                  40, // Adjust width to fit about 5 digits
                            ),
                          ),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^[0-9:.]*$'))
                            // Limiting the input to 5 characters
                          ],
                          onSubmitted: (String newValue) {
                            if (newValue == "") {
                              newValue = '0';
                            }
                            setState(() => bm_squats = newValue as int?);
                          },
                          style: TextStyle(
                            color: Colors.amber,
                            fontSize: 14.0,
                            // Set your desired font size here, smaller than the default
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ]),
              SizedBox(height: _mediumSpacing),
              submitButton(context),
              SizedBox(height: _mediumSpacing),
            ],
          ),
        ),
      ),
    );
  }
}
