import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:silat_flutter/admin/avatar.dart';
import 'dart:async';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final formKey = GlobalKey<FormState>(); //key for form
  User? _currentUser = FirebaseAuth.instance.currentUser;
  final _database = FirebaseDatabase.instance.reference();
  late StreamSubscription _userDBStream;
  var myUser;

  late String? _firstName;
  late String? _lastName;
  late String? _dbkey;

  int _age = 6;
  List _listOfAges = [for (var i = 6; i <= 50; i++) i];

  @override
  void initState() {
    _listOfAges.add(0);
    _getUserData();
    super.initState();
  }

  void _getUserData() {
    try {
      _userDBStream = _database
          .child('users')
          .orderByChild('email')
          .equalTo((_currentUser?.email)?.toLowerCase())
          .limitToFirst(1)
          .onValue
          .listen((event) {
        if (event.snapshot.value != null) {
          final data = new Map<String?, dynamic>.from(event.snapshot.value);

          print(event.snapshot.key);
          data.forEach((key, value) {
            setState(() {
              print(value['firstname']);
              _dbkey = key;
              _firstName = value['firstname'];
              _lastName = value['lastname'];
              _age = value['age'] ?? 0;
            });
          });
        }
      });
    } catch (e) {
      print("something went wrong");
    }
  }

  final snackBarRed = SnackBar(
    content: Text('A problem occured.'),
    backgroundColor: Colors.red,
  );
  final snackBarGreen = SnackBar(
    content: Text('Success! You have updated the user.'),
    backgroundColor: Colors.green,
  );

  @override
  void deactivate() {
    _userDBStream.cancel();
    super.deactivate();
  }

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
                SizedBox(height: paddingBetween),
                TextFormField(
                  decoration: InputDecoration(labelText: 'First Name'),
                  initialValue: _firstName,
                  validator: (value) {
                    if (value!.length < 4) {
                      return 'Enter at least 4 characters';
                    } else {
                      return null;
                    }
                  },
                  maxLength: 30,
                  onChanged: (value) =>
                      setState(() => _firstName = value.toString()),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Last Name'),
                  initialValue: _lastName,
                  validator: (value) {
                    if (value!.length < 4) {
                      return 'Enter at least 4 characters';
                    } else {
                      return null;
                    }
                  },
                  maxLength: 30,
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
                SizedBox(height: paddingBetween),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(12.0),
                          ),
                          primary: Colors.purple,
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                          textStyle: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      icon: Icon(Icons.save),
                      label: Text("Update Profile"),
                      onPressed: () {
                        print(_currentUser?.email);
                        final isValid = formKey.currentState?.validate();
                        // FocusScope.of(context).unfocus();

                        print(_dbkey);
                        if (isValid!) {
                          _database
                              .child('/users')
                              .child(_dbkey.toString())
                              .update({
                                'firstname': _firstName,
                                'lastname': _lastName,
                                'age': _age,
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
                      }),
                ])
              ],
            ),
          ),
          SizedBox(height: paddingBetween),
          Divider(
            height: 20,
            thickness: 2,
            indent: 0,
            endIndent: 0,
          ),
          Center(child: Text("Change Avatar", style: TextStyle(fontWeight: FontWeight.bold))),
          OutlinedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))),
            ),
            onPressed: () => Navigator.push(
                context, new MaterialPageRoute(builder: (context) => Avatar())),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FluttermojiCircleAvatar(
                backgroundColor: Colors.grey[200],
                radius: 100,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
