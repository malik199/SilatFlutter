import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:silat_flutter/utils/connectivity.dart';

class UpdateProfile extends StatefulWidget {
  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
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
    content: Text('Success! You have updated your updateProfile.'),
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
            const Text('My UpdateProfile'),
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
                SizedBox(height: 8),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.email, color: Colors.teal),
                      SizedBox(width: 10),
                      Text('$_email',
                          style: TextStyle(
                              color: Colors.teal, fontWeight: FontWeight.bold)),
                    ],
                  ),
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
                Row(children: [
                  Icon(Icons.assignment_ind),
                  SizedBox(width: 16),
                  Text("Age:", style: new TextStyle(fontSize: 18.0)),
                  SizedBox(width: 16),
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
                Row(children: [
                  Icon(Icons.list),
                  SizedBox(width: 16),
                  Text("Stripe:", style: new TextStyle(fontSize: 18.0)),
                  SizedBox(width: 16),
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
                    items: _listOfStripes.map<DropdownMenuItem<int>>((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList(),
                  )
                ]),
                SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(12.0),
                          ),
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                          textStyle: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      icon: Icon(Icons.save),
                      label: Text("Update Profile",
                          style: TextStyle(color: Colors.white)),
                      onPressed: () async {

                        final isValid = formKey.currentState?.validate();
                        // FocusScope.of(context).unfocus();

                        //print(_currentEmail);
                        //print(_dbkey);

                        if (isValid!) {
                          if(_dbkey == ""){
                            await _database.child('/users').push().set({
                              'uid': _currentUser?.uid,
                              'belt': 'white',
                              'comments':
                              'Welcome to Silat martial arts.',
                              'curriculum': _age > 11 ? "jawara_muda" : "satria_muda",
                              'email': _currentUser?.email,
                              'firstname': _firstName,
                              'lastname': _lastName,
                              'isApproved': false,
                              'stripe':_stripe,
                              'age': _age,
                              'location': 'VA'

                            }).then((value) => {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBarGreen)
                            })
                                .catchError((error) => {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBarRed)
                            });
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
                                .then((value) => {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBarGreen)
                            })
                                .catchError((error) => {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBarRed)
                            });
                          }

                        }
                      }),
                ])
              ],
            ),
          ),
          SizedBox(height: paddingBetween),
        ],
      ),
    );
  }
}
