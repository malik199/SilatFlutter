import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/technique_list.dart';

class TechniquesHome extends StatefulWidget {
  const TechniquesHome({Key? key}) : super(key: key);

  @override
  _TechniquesHomeState createState() => _TechniquesHomeState();
}

class _TechniquesHomeState extends State<TechniquesHome> {
  final textcontroller = TextEditingController();
  final _database = FirebaseDatabase.instance.reference();
  final Future<FirebaseApp> _future = Firebase.initializeApp();
  User? _user = FirebaseAuth.instance.currentUser;

  /*void addData(String data) {
    databaseRef.push().set({'name': data, 'comment': 'A good season'});
  }*/

  var myData;
  var myList;
  void getYourTechniques() {

    _database.child('users').orderByChild('email').equalTo((_user?.email)?.toLowerCase()).limitToFirst(1).once().then((DataSnapshot snapshot) {
      final data = new Map<String?, dynamic>.from(snapshot.value);
      data.forEach((key, value) {
        myList = value;
      });
      print(myList['firstname']);
    });
  }

  @override
  Widget build(BuildContext context) {
    const double _beltWidth = 36;
    const double _spacing = 18;
    const double _stripeSpacing = 8;

    getYourTechniques();
    var output = _database.child('techniques').orderByChild('jawara_muda').equalTo('yellow').once();
    print(output);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(_spacing),
          child: Text(("${myList['firstname']}'s techniques").toUpperCase()),
        ),
        TextButton(
          onPressed: (){
            print("Container clicked");
          },
          child: Container(
            height: _beltWidth,
            decoration: BoxDecoration(
              color: Colors.white,
                border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ),
        TextButton(
          onPressed: (){
            print("Container clicked");
          },
          child: Container(
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(1),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: _stripeSpacing),
              child: Container(
                color: Colors.yellow,
              ),
            ),
          ),
        ),
        SizedBox(height: _spacing),
        Container(
          height: 30,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(1),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: _stripeSpacing),
            child: Container(
              color: Colors.green,
            ),
          ),
        ),
        SizedBox(height: _spacing),
        Container(
          height: 30,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(1),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: _stripeSpacing),
            child: Container(
              color: Colors.blue,
            ),
          ),
        ),
        SizedBox(height: _spacing),
        Container(
          height: 30,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(1),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: _stripeSpacing),
            child: Container(
              color: Colors.purple,
            ),
          ),
        ),
        SizedBox(height: _spacing),
        Container(
          height: 30,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(1),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: _stripeSpacing),
            child: Container(
              color: Colors.brown,
            ),
          ),
        ),
        SizedBox(height: _spacing),
        Container(
          height: 30,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(1),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: _stripeSpacing),
            child: Container(
              color: Colors.black,
            ),
          ),
        ),
        /* FutureBuilder(
            future: output, //child('techniques').orderByChild('jawara_muda')).equalTo('white').orderByKey().limitToLast(10).onValue
            builder: (context, snapshot) {
              final tileList = <ListTile>[];
              if(!snapshot.hasData || snapshot.hasError){
                return CircularProgressIndicator();
              } else {
                final myOrders = Map<String, dynamic>.from(
                    (snapshot.data! as DataSnapshot).value);
                //print(myOrders);
                myOrders.forEach((key, value){
                  final nextOrder = Map<String, dynamic>.from(value);
                  final orderTile = ListTile(
                    leading: Icon(Icons.local_cafe),
                    title: Text(nextOrder['desc']),
                    subtitle: Text(nextOrder['technique'])
                  );
                  tileList.add(orderTile);
                });
              }

              return Expanded(
                child: ListView(
                  children: tileList,
                ),
              );
            }
        ),
       */
      ],
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
