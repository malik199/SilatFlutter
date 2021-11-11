import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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

  final _focusFirstname = FocusNode();
  final _focusLastname = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  double _spacing = 16.0;
  bool _isProcessing = false;

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
          title: Text('Register'),
        ),
        body: Padding(
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
                          hintText: "First Name",
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
                          hintText: "Last Name",
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
                      SizedBox(height: 32.0),
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
                                                'curriculum': "jawara_muda",
                                                'email':
                                                    _emailTextController.text,
                                                'firstname':
                                                    _firstnameTextController
                                                        .text,
                                                'lastname':
                                                    _lastnameTextController
                                                        .text,
                                                'isApproved': false,
                                                'stripe': 0
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
                                          'Sign up',
                                          style: TextStyle(color: Colors.white),
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
    );
  }
}