import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class AddEventsPage extends StatefulWidget {
  @override
  _AddEventsPageState createState() => _AddEventsPageState();
}

class _AddEventsPageState extends State<AddEventsPage> {
  final _registerFormKey = GlobalKey<FormState>();
  final _database = FirebaseDatabase.instance.ref();

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

  late DateTime _selectedDate;
  String eventDate = "";

  void _selectEventDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2040),
    );
    if (selected != null && selected != _selectedDate)
      setState(() {
        _selectedDate = selected;
      });
  }

  final String _initDate = "2019-08-09T06:55:01.8968264+00:00";
  late DateTime _selectedDeadline;

  @override
  void initState() {
    super.initState();
    _selectedDeadline = DateTime.parse(_initDate);
    _selectedDate = DateTime.parse(_initDate);
  }


  String eventDeadline = "";

  bool _validateDate() {
    return _selectedDate == DateTime.parse(_initDate)
        ? true
        : false;
  }

  void _selectDeadline(BuildContext context) async {
    print(_selectedDeadline);
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2040),
    );
    if (selected != null && selected != _selectedDeadline)
      setState(() {
        _selectedDeadline = selected;
      });
  }

  bool _validateDeadline() {
    return _selectedDeadline ==
            DateTime.parse(_initDate)
        ? true
        : false;
  }

  final snackBarRed = SnackBar(
    content: Text('A problem occurred.'),
    backgroundColor: Colors.red,
  );
  final snackBarGreen = SnackBar(
    content: Text('Success! You added an event!'),
    backgroundColor: Colors.green,
  );

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
        body: SingleChildScrollView(
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
                     /* validator: (value) => Validator.validateUrl(
                        url: value,
                      ),*/
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
                            ), backgroundColor: Colors.deepPurple, foregroundColor: Colors.white
                          ),
                          onPressed: () {
                            _selectEventDate(context);
                          },
                          label: Text(
                            "DATE OF EVENT",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white),
                          ),
                        ),
                        SizedBox(width: 15),
                        _validateDate()
                            ? Text(
                                "Please choose a date",
                                style: TextStyle(color: Colors.red),
                              )
                            : Text(
                                DateFormat('MMM dd, yyyy')
                                    .format(_selectedDate),
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
                            ), backgroundColor: Colors.purple, foregroundColor: Colors.white
                          ),
                          onPressed: () {
                            _selectDeadline(context);
                          },
                          label: Text(
                            "REG. DEADLINE",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white),
                          ),
                        ),
                        SizedBox(width: 15),
                        _validateDeadline()
                            ? Text(
                                "Please choose a date",
                                style: TextStyle(color: Colors.red),
                              )
                            : Text(
                                DateFormat('MMM dd, yyyy')
                                    .format(_selectedDeadline),
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
                                        setState(() {
                                          _isProcessing = true;
                                        });
                                        final nextEvent = <String, dynamic>{
                                          'name': _eventNameTextController.text,
                                          'location':
                                              _locationTextController.text,
                                          'url': _urlTextController.text,
                                          'desc': _descriptionTextController.text,
                                          'date': _selectedDate.toString(),
                                          'deadline': _selectedDeadline.toString()
                                        };
                                        if (_registerFormKey.currentState!
                                                .validate() &&
                                            !_validateDate() &&
                                            !_validateDeadline()) {
                                          _database
                                              .child('events')
                                              .push()
                                              .set(nextEvent)
                                              .then((value) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBarGreen);
                                            
                                            //Clear out data
                                             setState(() {
                                              _eventNameTextController.text = "";
                                              _locationTextController.text = "";
                                              _urlTextController.text = "";
                                              _descriptionTextController.text  = "";
                                               _selectedDate = DateTime.parse(_initDate);
                                               _selectedDeadline = DateTime.parse(_initDate);
                                            });

                                          }).catchError((error) {
                                            print(error);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBarRed);
                                          });
                                        } else {
                                          setState(() {
                                            _isProcessing = false;
                                          });
                                        }
                                        setState(() {
                                          _isProcessing = false;
                                        });
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
      return 'Locataion can\'t be empty';
    }

    return null;
  }
/*
  static String? validateUrl({ required String? url}) {
    if (url == null) {
      return null;
    }

    RegExp urlRegExp = RegExp(
        "((http|https)://)(www.)?[a-zA-Z0-9@:%._\\+~#?&//=]{2,256}\\.[a-z]{2,6}\\b([-a-zA-Z0-9@:%._\\+~#?&//=]*)");

    if (url.isEmpty) {
      return "";
    } else if (!urlRegExp.hasMatch(url)) {
      return 'Enter a correct url';
    }

    return null;
  }*/

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
