import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';

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
  int _currentValue = 3;

  late String? _firstName = "";
  late String? _lastName = "";
  late int? _stripe = 0;
  late String? _email = "";
  int _age = 5;

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
  late String? bm_deadhang;
  late String? bm_mile;
  late String? bm_dash;
  late String? bm_wallsits;
  late int? bm_boxjumps = 0;
  late int? bm_squats = 0;

  List<String> _listOfLocations = [];
  List<int> _listOfNumbers = [for (var i = 0; i <= 50; i++) i];
  List _listOfAges = [for (var i = 5; i <= 50; i++) i];
  List _listOfStripes = [0, 1, 2, 3, 4];

  double _sizeBoxWidth = 10;
  double _sizeBoxHeight = 16;
  double spacingWidth = 10;
  double spacingHeight = 10;

  late String? _dbkey = "";

  TextEditingController? _firstNameController = TextEditingController();
  TextEditingController? _lastNameController = TextEditingController();
  TextEditingController? _tournamentController = TextEditingController();
  TextEditingController? _1stplaceController = TextEditingController();
  TextEditingController? _2ndplaceController = TextEditingController();
  TextEditingController? _classMeritsController = TextEditingController();
  TextEditingController? _deedsController = TextEditingController();

  TextEditingController? _bm_pushupsController = TextEditingController();
  TextEditingController? _bm_situpsController = TextEditingController();
  TextEditingController? _bm_pullupsController = TextEditingController();
  TextEditingController? _bm_deadhangController = TextEditingController();
  TextEditingController? _bm_mileTimeController = TextEditingController();
  TextEditingController? _bm_dashController = TextEditingController();
  TextEditingController? _bm_wallSitController = TextEditingController();
  TextEditingController? _bm_boxJumpsController = TextEditingController();
  TextEditingController? _bm_squatsController = TextEditingController();

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

  void calculateScore() {
    setState(() {
      _finalScore = (_1stplace * 10) +
          (_2ndplace * 8) +
          (_tournaments! * 6) +
          (_classMerits) +
          (_deeds);
    });
  }

  Widget _pendingWidget = Container();
  void checkForPendingUpdates(String dbKey) {
    _database.child('pending').child(dbKey).once().then((rtdbData) {
      if (rtdbData.snapshot.exists) {
        setState(() {
          _pendingWidget = Container(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.pink,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Pending updates',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          );
        });
      }
    }).catchError((error) {
      setState(() {
        _pendingWidget = Container(
          alignment: Alignment.center,
          child: Text(
            'Error checking updates',
            style: TextStyle(fontSize: 16, color: Colors.red),
          ),
        );
      });
      print('Failed to check for pending updates: $error');
    });
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
          _age = myData['age'] ?? 0;
          _email = myData['email'];
          _beltColor = myData['belt'];
          _curriculum = myData['curriculum'];
          _1stplace = myData['1stplace'] ?? 0;
          _2ndplace = myData['2ndplace'] ?? 0;
          _classMerits = myData['classMerits'] ?? 0;
          _deeds = myData['deeds'] ?? 0;
          _finalScore = myData['score'] ?? 0;
          _tournaments = myData['tournaments'] ?? 0;
          _stripe = myData['stripe'] ?? 0;
          _location = myData['location'];
          _isApprov = myData['isApproved'];
          _firstNameController =
              TextEditingController(text: myData['firstname']);
          _lastNameController = TextEditingController(text: myData['lastname']);
          _tournamentController =
              TextEditingController(text: _tournaments.toString());
          _1stplaceController =
              TextEditingController(text: _1stplace.toString());
          _2ndplaceController =
              TextEditingController(text: _2ndplace.toString());
          _classMeritsController =
              TextEditingController(text: _classMerits.toString());
          _deedsController = TextEditingController(text: _deeds.toString());

          _bm_pushupsController = TextEditingController(
              text: myData['bm_pushups'] == null
                  ? '0'
                  : myData['bm_pushups'].toString());
          _bm_pullupsController = TextEditingController(
              text: myData['bm_pullups'] == null
                  ? '0'
                  : myData['bm_pullups'].toString());
          _bm_situpsController = TextEditingController(
              text: myData['bm_situps'] == null
                  ? '0'
                  : myData['bm_situps'].toString());
          _bm_deadhangController = TextEditingController(
              text: myData['bm_deadhang'] == null
                  ? '0:00'
                  : myData['bm_deadhang'].toString());
          _bm_mileTimeController = TextEditingController(
              text: myData['bm_mile'] == null
                  ? '0:00'
                  : myData['bm_mile'].toString());
          _bm_dashController = TextEditingController(
              text: myData['bm_dash'] == null
                  ? '0:00'
                  : myData['bm_dash'].toString());
          _bm_wallSitController = TextEditingController(
              text: myData['bm_wallsits'] == null
                  ? '0:00'
                  : myData['bm_wallsits'].toString());
          _bm_boxJumpsController = TextEditingController(
              text: myData['bm_boxjumps'] == null
                  ? '0'
                  : myData['bm_boxjumps'].toString());
          _bm_squatsController = TextEditingController(
              text: myData['bm_squats'] == null
                  ? '0'
                  : myData['bm_squats'].toString());

          bm_pushups = myData['bm_pushups'] ?? 0;
          bm_situps = myData['bm_situps'] ?? 0;
          bm_pullups = myData['bm_pullups'] ?? 0;
          bm_deadhang = myData['bm_deadhang'].toString() ?? '0';
          bm_mile = myData['bm_mile'].toString() ?? '0';
          bm_dash = myData['bm_dash'].toString() ?? '0';
          bm_wallsits = myData['bm_wallsits'].toString() ?? '0';
          bm_boxjumps = myData['bm_boxjumps'] ?? 0;
          bm_squats = myData['bm_squats'] ?? 0;
        });

        checkForPendingUpdates(_dbkey!);
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
        });
      });
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
            .child('/pending')
            .push()
            .set({
              'uid': _currentUser?.uid,
              'belt': 'white',
              'comments': 'Welcome to Silat martial arts.',
              'curriculum': _curriculum,
              'email': _currentUser?.email,
              'firstname': _firstName,
              'lastname': _lastName,
              'isApproved': _isApprov,
              'stripe': _stripe,
              'age': _age,
              'location': 'VA',
              '1stplace': _1stplace,
              '2ndplace': _2ndplace,
              'bm_boxjumps': bm_boxjumps,
              'bm_dash': bm_dash,
              'bm_deadhang': bm_deadhang,
              'bm_mile': bm_mile,
              'bm_pullups': bm_pullups,
              'bm_pushups': bm_pushups,
              'bm_situps': bm_situps,
              'bm_squats': bm_squats,
              'bm_wallsits': bm_wallsits,
              'classMerits': _classMerits,
              'deeds': _deeds,
              'score': _finalScore,
              'tournaments': _tournaments,
            })
            .then((value) =>
                {ScaffoldMessenger.of(context).showSnackBar(snackBarGreen)})
            .catchError((error) =>
                {ScaffoldMessenger.of(context).showSnackBar(snackBarRed)});
      } else {
        _database
            .child('/pending')
            .child(_dbkey.toString())
            .update({
              'uid': _currentUser?.uid,
              'belt': _beltColor,
              'comments': 'Welcome to Silat martial arts.',
              'curriculum': _curriculum,
              'email': _currentUser?.email,
              'firstname': _firstName,
              'lastname': _lastName,
              'isApproved': _isApprov,
              'stripe': _stripe,
              'age': _age,
              'location': _location,
              '1stplace': _1stplace,
              '2ndplace': _2ndplace,
              'bm_boxjumps': bm_boxjumps,
              'bm_dash': bm_dash,
              'bm_deadhang': bm_deadhang,
              'bm_mile': bm_mile,
              'bm_pullups': bm_pullups,
              'bm_pushups': bm_pushups,
              'bm_situps': bm_situps,
              'bm_squats': bm_squats,
              'bm_wallsits': bm_wallsits,
              'classMerits': _classMerits,
              'deeds': _deeds,
              'score': _finalScore,
              'tournaments': _tournaments,
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
    content: Text('Success! Your update is now awaiting approval.'),
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
                  Center(child: _pendingWidget),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 0, horizontal: 12.0),
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
                          decoration: InputDecoration(labelText: 'Last Name'),
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
                      )),
                  ListTile(
                      leading: Icon(Icons.list, size: _iconSize),
                      title: Text("Stripe:"),
                      trailing: DropdownButton<int>(
                        value: _stripe,
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
                      )),
                  ListTile(
                    leading: Icon(Icons.horizontal_split, size: _iconSize),
                    title: Text("Belt:"),
                    trailing: DropdownButton<String>(
                        value: _beltColor,
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.amber),
                        underline: Container(
                          height: 2,
                          color: Colors.amberAccent,
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
                          color: Colors.amberAccent,
                        ),
                        style: TextStyle(color: Colors.amber),
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
                      )),
                  ListTile(
                    leading: Icon(Icons.place),
                    title: Text(
                      "Location",
                    ),
                    trailing: DropdownButton<String>(
                      value: _location,
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      underline: Container(
                        height: 2,
                        color: Colors.amberAccent,
                      ),
                      style: TextStyle(color: Colors.amber),
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
                      trailing: TextField(
                        textAlign: TextAlign.right,
                        controller: _tournamentController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border:
                              OutlineInputBorder(), // Adds a border around the input
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 10.0), // Padding inside the border
                          isDense: true, // Reduces the field's height
                          counterText:
                              '', // Hides the counter text that appears below the TextField
                          constraints: BoxConstraints(
                            maxWidth: 60, // Adjust width to fit about 5 digits
                          ),
                        ),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(
                              5), // Limiting the input to 5 characters
                        ],
                        onChanged: (String newValue) {
                          if (newValue == "") {
                            newValue = '0';
                          }
                          setState(() => _tournaments = int.parse(newValue));
                          calculateScore();
                        },
                      )),
                  ListTile(
                    leading: Icon(Icons.filter_1, size: _iconSize),
                    title: Text(
                      "1st Place",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Number of first place wins.",
                        style: TextStyle(fontSize: _subtitleSize)),
                    trailing: TextField(
                      textAlign: TextAlign.right,
                      controller: _1stplaceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border:
                            OutlineInputBorder(), // Adds a border around the input
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 10.0), // Padding inside the border
                        isDense: true, // Reduces the field's height
                        counterText:
                            '', // Hides the counter text that appears below the TextField
                        constraints: BoxConstraints(
                          maxWidth: 60, // Adjust width to fit about 5 digits
                        ),
                      ),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(
                            5), // Limiting the input to 5 characters
                      ],
                      onChanged: (String newValue) {
                        if (newValue == "") {
                          newValue = '0';
                        }
                        setState(() => _1stplace = int.parse(newValue));
                        calculateScore();
                      },
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.filter_2, size: _iconSize),
                    title: Text(
                      "2nd Place",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Number of 2nd place wins.",
                        style: TextStyle(fontSize: _subtitleSize)),
                    trailing: TextField(
                      textAlign: TextAlign.right,
                      controller: _2ndplaceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border:
                            OutlineInputBorder(), // Adds a border around the input
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 10.0), // Padding inside the border
                        isDense: true, // Reduces the field's height
                        counterText:
                            '', // Hides the counter text that appears below the TextField
                        constraints: BoxConstraints(
                          maxWidth: 60, // Adjust width to fit about 5 digits
                        ),
                      ),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(
                            5), // Limiting the input to 5 characters
                      ],
                      onChanged: (String newValue) {
                        if (newValue == "") {
                          newValue = '0';
                        }
                        setState(() => _2ndplace = int.parse(newValue));
                        calculateScore();
                      },
                    ),
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
                    trailing: TextField(
                      textAlign: TextAlign.right,
                      controller: _classMeritsController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border:
                            OutlineInputBorder(), // Adds a border around the input
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 10.0), // Padding inside the border
                        isDense: true, // Reduces the field's height
                        counterText:
                            '', // Hides the counter text that appears below the TextField
                        constraints: BoxConstraints(
                          maxWidth: 60, // Adjust width to fit about 5 digits
                        ),
                      ),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(
                            5), // Limiting the input to 5 characters
                      ],
                      onChanged: (String newValue) {
                        if (newValue == "") {
                          newValue = '0';
                        }
                        setState(() => _classMerits = int.parse(newValue));
                        calculateScore();
                      },
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.verified, size: _iconSize),
                    title: Text(
                      "Good Deeds",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        "Doing good deeds such as helping the poor, volunteering, etc.",
                        style: TextStyle(fontSize: _subtitleSize)),
                    trailing: TextField(
                      textAlign: TextAlign.right,
                      controller: _deedsController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border:
                            OutlineInputBorder(), // Adds a border around the input
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 10.0), // Padding inside the border
                        isDense: true, // Reduces the field's height
                        counterText:
                            '', // Hides the counter text that appears below the TextField
                        constraints: BoxConstraints(
                          maxWidth: 60, // Adjust width to fit about 5 digits
                        ),
                      ),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(
                            5), // Limiting the input to 5 characters
                      ],
                      onChanged: (String newValue) {
                        if (newValue == "") {
                          newValue = '0';
                        }
                        setState(() => _deeds = int.parse(newValue));
                        calculateScore();
                      },
                    ),
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
                    trailing: TextField(
                      textAlign: TextAlign.right,
                      controller: _bm_pushupsController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border:
                            OutlineInputBorder(), // Adds a border around the input
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 10.0), // Padding inside the border
                        isDense: true, // Reduces the field's height
                        counterText:
                            '', // Hides the counter text that appears below the TextField
                        constraints: BoxConstraints(
                          maxWidth: 60, // Adjust width to fit about 5 digits
                        ),
                      ),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(
                            5), // Limiting the input to 5 characters
                      ],
                      onChanged: (String newValue) {
                        if (newValue == "") {
                          newValue = '0';
                        }
                        setState(() => bm_pushups = int.parse(newValue));
                      },
                    ),
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
                    trailing: TextField(
                      textAlign: TextAlign.right,
                      controller: _bm_situpsController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border:
                            OutlineInputBorder(), // Adds a border around the input
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 10.0), // Padding inside the border
                        isDense: true, // Reduces the field's height
                        counterText:
                            '', // Hides the counter text that appears below the TextField
                        constraints: BoxConstraints(
                          maxWidth: 60, // Adjust width to fit about 5 digits
                        ),
                      ),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(
                            5), // Limiting the input to 5 characters
                      ],
                      onChanged: (String newValue) {
                        if (newValue == "") {
                          newValue = '0';
                        }
                        setState(() => bm_situps = int.parse(newValue));
                      },
                    ),
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
                    trailing: TextField(
                      textAlign: TextAlign.right,
                      controller: _bm_pullupsController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border:
                            OutlineInputBorder(), // Adds a border around the input
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 10.0), // Padding inside the border
                        isDense: true, // Reduces the field's height
                        counterText:
                            '', // Hides the counter text that appears below the TextField
                        constraints: BoxConstraints(
                          maxWidth: 60, // Adjust width to fit about 5 digits
                        ),
                      ),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(
                            5), // Limiting the input to 5 characters
                      ],
                      onChanged: (String newValue) {
                        if (newValue == "") {
                          newValue = '0';
                        }
                        setState(() => bm_pullups = int.parse(newValue));
                      },
                    ),
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
                    trailing: TextField(
                      textAlign: TextAlign.center,
                      controller: _bm_deadhangController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border:
                            OutlineInputBorder(), // Adds a border around the input
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 10.0), // Padding inside the border
                        isDense: true, // Reduces the field's height
                        counterText:
                            '', // Hides the counter text that appears below the TextField
                        constraints: BoxConstraints(
                          maxWidth: 60, // Adjust width to fit about 5 digits
                        ),
                      ),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'^[0-9:.]*$'))
                        // Limiting the input to 5 characters
                      ],
                      onChanged: (String newValue) {
                        if (newValue == "") {
                          newValue = '0';
                        }
                        setState(() => bm_deadhang = newValue);
                      },
                    ),
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
                    trailing: TextField(
                      textAlign: TextAlign.center,
                      controller: _bm_mileTimeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border:
                            OutlineInputBorder(), // Adds a border around the input
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 2.0), // Padding inside the border
                        isDense: true, // Reduces the field's height
                        counterText:
                            '', // Hides the counter text that appears below the TextField
                        constraints: BoxConstraints(
                          maxWidth: 60, // Adjust width to fit about 5 digits
                        ),
                      ),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'^[0-9:.]*$'))
                        // Limiting the input to 5 characters
                      ],
                      onChanged: (String newValue) {
                        if (newValue == "") {
                          newValue = '0';
                        }
                        setState(() => bm_mile = newValue);
                      },
                    ),
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
                    trailing: TextField(
                      textAlign: TextAlign.center,
                      controller: _bm_dashController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border:
                            OutlineInputBorder(), // Adds a border around the input
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 2.0), // Padding inside the border
                        isDense: true, // Reduces the field's height
                        counterText:
                            '', // Hides the counter text that appears below the TextField
                        constraints: BoxConstraints(
                          maxWidth: 60, // Adjust width to fit about 5 digits
                        ),
                      ),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'^[0-9:.]*$'))
                        // Limiting the input to 5 characters
                      ],
                      onChanged: (String newValue) {
                        if (newValue == "") {
                          newValue = '0';
                        }
                        setState(() => bm_dash = newValue);
                      },
                    ),
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
                    trailing: TextField(
                      textAlign: TextAlign.center,
                      controller: _bm_wallSitController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border:
                            OutlineInputBorder(), // Adds a border around the input
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 2.0), // Padding inside the border
                        isDense: true, // Reduces the field's height
                        counterText:
                            '', // Hides the counter text that appears below the TextField
                        constraints: BoxConstraints(
                          maxWidth: 60, // Adjust width to fit about 5 digits
                        ),
                      ),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'^[0-9:.]*$'))
                        // Limiting the input to 5 characters
                      ],
                      onChanged: (String newValue) {
                        if (newValue == "") {
                          newValue = '0';
                        }
                        setState(() => bm_wallsits = newValue);
                      },
                    ),
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
                    trailing: TextField(
                      textAlign: TextAlign.right,
                      controller: _bm_boxJumpsController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border:
                            OutlineInputBorder(), // Adds a border around the input
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 10.0), // Padding inside the border
                        isDense: true, // Reduces the field's height
                        counterText:
                            '', // Hides the counter text that appears below the TextField
                        constraints: BoxConstraints(
                          maxWidth: 60, // Adjust width to fit about 5 digits
                        ),
                      ),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(
                            5), // Limiting the input to 5 characters
                      ],
                      onChanged: (String newValue) {
                        if (newValue == "") {
                          newValue = '0';
                        }
                        setState(() => bm_boxjumps = int.parse(newValue));
                      },
                    ),
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
                    trailing: TextField(
                      textAlign: TextAlign.right,
                      controller: _bm_squatsController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border:
                            OutlineInputBorder(), // Adds a border around the input
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 10.0), // Padding inside the border
                        isDense: true, // Reduces the field's height
                        counterText:
                            '', // Hides the counter text that appears below the TextField
                        constraints: BoxConstraints(
                          maxWidth: 60, // Adjust width to fit about 5 digits
                        ),
                      ),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(
                            5), // Limiting the input to 5 characters
                      ],
                      onChanged: (String newValue) {
                        if (newValue == "") {
                          newValue = '0';
                        }
                        setState(() => bm_squats = int.parse(newValue));
                      },
                    ),
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
