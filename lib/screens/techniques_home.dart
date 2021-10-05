import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

class TechniquesHome extends StatefulWidget {
  const TechniquesHome({Key? key}) : super(key: key);

  @override
  _TechniquesHomeState createState() => _TechniquesHomeState();
}

class _TechniquesHomeState extends State<TechniquesHome> {
  final textcontroller = TextEditingController();
  final _database = FirebaseDatabase.instance.reference();
  final Future<FirebaseApp> _future = Firebase.initializeApp();

  /*void addData(String data) {
    databaseRef.push().set({'name': data, 'comment': 'A good season'});
  }*/
  var myData;
  void printFirebase(){
    /*_database.once().then((DataSnapshot snapshot) {
      print('Data : ${snapshot.value}');
    });*/

    _database.child('techniques/0').get().then((DataSnapshot snapshot) {
        final data = new Map<String, dynamic>.from(snapshot.value);
        print('New Data: ${data}');
    });

    /*
    _database.child('techniques/').onValue.listen((event) {
      final data = new Map<String, dynamic>.from(event.snapshot.value);
      print('Data : ${description}');
    });

    _database.child('users/0/firstname').onValue.listen((event) {
      final String description = event.snapshot.value;
      print('Data : ${description}');
    });
     */
  }

  @override
  Widget build(BuildContext context) {
    printFirebase();
    return FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 250.0),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextField(
                        controller: textcontroller,
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Center(
                        child: RaisedButton(
                            color: Colors.pinkAccent,
                            child: Text("Save to Database"),
                            onPressed: () {
                              //addData(textcontroller.text);
                              //call method flutter upload
                            }
                        )
                    ),
                  ],
                ),
              );
            }
          }
    );
  }
}



/*
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class TechniquesHome extends StatefulWidget {
  const TechniquesHome({Key? key}) : super(key: key);

  @override
  _TechniquesHomeState createState() => _TechniquesHomeState();
}

class _TechniquesHomeState extends State<TechniquesHome> {
  bool _active = false;

  void _handleTapboxChanged(bool newValue) {
    setState(() {
      _active = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        child: Column(
          children: [
            Icon(
              Icons.sports_kabaddi,
              size: 150,
            ),
            Text(
              "This is the new technique section of the website!"
            )
          ],
        ),
      ) ,
    );
  }
}



@override
  Widget build(BuildContext context) {
    printFirebase();
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Demo"),
      ),
      body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 250.0),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextField(
                        controller: textcontroller,
                      ),
                    ),
                    SizedBox(height: 30.0),
                    Center(
                        child: RaisedButton(
                            color: Colors.pinkAccent,
                            child: Text("Save to Database"),
                            onPressed: () {
                              //addData(textcontroller.text);
                              //call method flutter upload
                            }
                        )
                    ),
                  ],
                ),
              );
            }
          }
      ),
    );
  }



*/