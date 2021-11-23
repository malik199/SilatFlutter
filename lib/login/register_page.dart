import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:silat_flutter/screens/header.dart';
import 'package:silat_flutter/screens/landing_page.dart';
import 'package:silat_flutter/utils/fire_auth.dart';
import 'package:silat_flutter/utils/validator.dart';


class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _registerFormKey = GlobalKey<FormState>();
  final _database = FirebaseDatabase.instance.reference();

  final _firstnameTextController = TextEditingController();
  final _lastnameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _passwordConfirmTextController = TextEditingController();

  final _focusFirstname = FocusNode();
  final _focusLastname = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  final _focusConfirmPassword = FocusNode();

  double _spacing = 10.0;
  bool _isProcessing = false;
  int _age = 6;
  List _listOfAges = [for (var i = 6; i <= 50; i++) i];
  late String? _location = "VA";
  List _listOfLocations = ["MD", "DC", "VA", "Other"];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusFirstname.unfocus();
        _focusLastname.unfocus();
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Header(headerText: "Register"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    key: _registerFormKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _firstnameTextController,
                          focusNode: _focusFirstname,
                          validator: (value) => Validator.validateFirstname(
                            firstname: value,
                          ),
                          decoration: InputDecoration(
                            hintText: "Student First Name",
                            errorBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: BorderSide(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: _spacing),
                        TextFormField(
                          controller: _lastnameTextController,
                          focusNode: _focusLastname,
                          validator: (value) =>
                              Validator.validateLastname(lastname: value),
                          decoration: InputDecoration(
                            hintText: "Student Last Name",
                            errorBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: BorderSide(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: _spacing),
                        TextFormField(
                          controller: _emailTextController,
                          focusNode: _focusEmail,
                          validator: (value) => Validator.validateEmail(
                            email: value,
                          ),
                          decoration: InputDecoration(
                            hintText: "Email",
                            errorBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: BorderSide(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: _spacing),
                        TextFormField(
                          controller: _passwordTextController,
                          focusNode: _focusPassword,
                          obscureText: true,
                          validator: (value) => Validator.validatePassword(
                            password: value,
                          ),
                          decoration: InputDecoration(
                            hintText: "Password",
                            errorBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: BorderSide(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: _spacing),
                        TextFormField(
                          controller: _passwordConfirmTextController,
                          focusNode: _focusConfirmPassword,
                          obscureText: true,
                          validator: (value) => Validator.validateConfirmPassword(
                            firstPassword: _passwordTextController.text,
                            secondPassword: value,
                          ),
                          decoration: InputDecoration(
                            hintText: "Confirm Password",
                            errorBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: BorderSide(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(children: [
                          Icon(Icons.assignment_ind),
                          SizedBox(width: 16),
                          Text("Age:", style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
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
                          Icon(Icons.place),
                          SizedBox(width: _spacing),
                          Text("Location:", style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                          SizedBox(width: _spacing),
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
                                _location = newValue ?? "";
                              });
                            },
                            items: _listOfLocations.map<DropdownMenuItem<String>>((value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value.toString()),
                              );
                            }).toList(),
                          )
                        ]),
                        SizedBox(height: _spacing),
                        _isProcessing
                            ? CircularProgressIndicator()
                            : Row(
                                children: [
                                  Expanded(
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            setState(() {
                                              _isProcessing = true;
                                            });

                                            if (_registerFormKey.currentState!
                                                .validate()) {
                                              User? user = await FireAuth
                                                  .registerUsingEmailPassword(
                                                name:
                                                    '${_firstnameTextController.text} ${_lastnameTextController.text}',
                                                email: _emailTextController.text,
                                                password:
                                                    _passwordTextController.text,
                                              );

                                              if (user != null) {
                                                await _database.child('/users').push().set({
                                                  'uid': user.uid,
                                                  'belt': 'white',
                                                  'comments':
                                                      'Welcome to Silat martial arts.',
                                                  'curriculum': _age > 11 ? "jawara_muda" : "satria_muda",
                                                  'email':
                                                      _emailTextController.text,
                                                  'firstname':
                                                      _firstnameTextController
                                                          .text,
                                                  'lastname':
                                                      _lastnameTextController
                                                          .text,
                                                  'isApproved': false,
                                                  'stripe': 0,
                                                  'age': _age,
                                                  'location': _location

                                                }).catchError((error) => print(
                                                    'You got an error! $error'));
                                                Navigator.of(context)
                                                    .pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        LandingPage(user: user),
                                                  ),
                                                  ModalRoute.withName('/'),
                                                );
                                              }

                                              setState(() {
                                                _isProcessing = false;
                                              });
                                            } else {
                                              setState(() {
                                                _isProcessing = false;
                                              });
                                            }
                                          },
                                          child: Text(
                                            'SIGN UP',
                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                          )))
                                ],
                              )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}