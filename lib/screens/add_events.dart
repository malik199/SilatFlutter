import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:silat_flutter/screens/landing_page.dart';
import 'package:silat_flutter/utils/fire_auth.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class AddEventsPage extends StatefulWidget {
  @override
  _AddEventsPageState createState() => _AddEventsPageState();
}

class _AddEventsPageState extends State<AddEventsPage> {
  final _registerFormKey = GlobalKey<FormState>();
  final _database = FirebaseDatabase.instance.reference();

  final _eventNameTextController = TextEditingController();
  final _locationTextController = TextEditingController();
  final _urlTextController = TextEditingController();
  final _descriptionTextController = TextEditingController();

  final _focusEventName = FocusNode();
  final _focusLocation = FocusNode();
  final _focusUrl = FocusNode();
  final _focusDescription = FocusNode();

  double _spacing = 16.0;
  bool _isProcessing = false;

  DateTime selectedDate = DateTime.parse("2019-08-09T06:55:01.8968264+00:00");
  String eventDate = "";

  void _selectEventDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2040),
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
      });
  }

  DateTime selectedDeadline =
      DateTime.parse("2019-08-09T06:55:01.8968264+00:00");
  String eventDeadline = "";

  void _selectDeadline(BuildContext context) async {
    print(selectedDeadline);
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2040),
    );
    if (selected != null && selected != selectedDeadline)
      setState(() {
        selectedDeadline = selected;
      });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusEventName.unfocus();
        _focusLocation.unfocus();
        _focusUrl.unfocus();
        _focusDescription.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Events'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Form(
                key: _registerFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      controller: _eventNameTextController,
                      focusNode: _focusEventName,
                      validator: (value) => Validator.validateEventName(
                        eventName: value,
                      ),
                      decoration: InputDecoration(
                        hintText: "Event Name",
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
                      controller: _locationTextController,
                      focusNode: _focusLocation,
                      validator: (value) =>
                          Validator.validateLocation(location: value),
                      decoration: InputDecoration(
                        hintText: "Location",
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
                      controller: _urlTextController,
                      focusNode: _focusUrl,
                      validator: (value) => Validator.validateUrl(
                        url: value,
                      ),
                      decoration: InputDecoration(
                        hintText: "Link",
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
                      controller: _descriptionTextController,
                      focusNode: _focusDescription,
                      obscureText: true,
                      validator: (value) => Validator.validateDescription(
                        description: value,
                      ),
                      decoration: InputDecoration(
                        hintText: "Description",
                        errorBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          icon: Icon(Icons.event),
                          style: ElevatedButton.styleFrom(
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(12.0),
                            ),
                            primary: Colors.deepPurple,
                          ),
                          onPressed: () {
                            _selectEventDate(context);
                          },
                          label: Text(
                            "DATE OF EVENT",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                        SizedBox(width: 15),
                        selectedDate ==
                            DateTime.parse(
                                "2019-08-09T06:55:01.8968264+00:00")
                            ? Text(
                          "Please choose a date",
                          style: TextStyle(color: Colors.red),
                        )
                            : Text(
                          DateFormat('MMMM dd, yyyy')
                              .format(selectedDate),
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.purple),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          icon: Icon(Icons.event_busy),
                          style: ElevatedButton.styleFrom(
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(12.0),
                            ),
                            primary: Colors.purple,
                          ),
                          onPressed: () {
                            _selectDeadline(context);
                          },
                          label: Text(
                            "REG. DEADLINE",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                        SizedBox(width: 15),
                        selectedDeadline ==
                                DateTime.parse(
                                    "2019-08-09T06:55:01.8968264+00:00")
                            ? Text(
                                "Please choose a date",
                                style: TextStyle(color: Colors.red),
                              )
                            : Text(
                                DateFormat('MMMM dd, yyyy')
                                    .format(selectedDeadline),
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple),
                              ),
                      ],
                    ),
                    SizedBox(height: 32.0),
                    _isProcessing
                        ? CircularProgressIndicator()
                        : Row(
                            children: [
                              Expanded(
                                  child: ElevatedButton(
                                      onPressed: () {

                                      },
                                      child: Text("ADD EVENT",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))))
                            ],
                          )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Validator {
  static String? validateEventName({required String? eventName}) {
    if (eventName == null) {
      return null;
    }

    if (eventName.isEmpty) {
      return 'Event name can\'t be empty';
    }

    return null;
  }

  static String? validateLocation({required String? location}) {
    if (location == null) {
      return null;
    }

    if (location.isEmpty) {
      return 'Last name can\'t be empty';
    }

    return null;
  }

  static String? validateUrl({required String? url}) {
    if (url == null) {
      return null;
    }

    RegExp urlRegExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    if (url.isEmpty) {
      return 'Url can\'t be empty';
    } else if (!urlRegExp.hasMatch(url)) {
      return 'Enter a correct url';
    }

    return null;
  }

  static String? validateDescription({required String? description}) {
    if (description == null) {
      return null;
    }

    if (description.isEmpty) {
      return 'Description can\'t be empty';
    } else if (description.length < 6) {
      return 'Enter a description with length at least 6';
    }

    return null;
  }
}
