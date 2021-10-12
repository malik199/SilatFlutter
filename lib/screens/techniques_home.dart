import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'techniques_list.dart';

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

  @override
  void initState() {
    getYourTechniques();
  }

  var myData;
  var myList;
  void getYourTechniques() {
    _database
        .child('users')
        .orderByChild('email')
        .equalTo((_user?.email)?.toLowerCase())
        .limitToFirst(1)
        .once()
        .then((DataSnapshot snapshot) {
      final data = new Map<String?, dynamic>.from(snapshot.value);
      setState(() {
        data.forEach((key, value) {
          myList = value;
          print('My List ${myList}');
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    const double _spacing = 18;

    List _fullBeltArray = [
      "white",
      "yellow",
      "green",
      "blue",
      "purple",
      "brown",
      "black",
      "red"
    ];

    List allYourBelts() {
      List myBeltLevels = [];
      for (var i = 0; i <= _fullBeltArray.indexOf(myList?['belt']); i++) {
        myBeltLevels.add(_fullBeltArray[i]);
      }
      return myBeltLevels;
    }

    print(allYourBelts());

    Widget produceBelts(List<dynamic> _allbelts) {
      return Column(
          children: _allbelts
              .map(
                (item) => Belt(curriculum: myList['curriculum'], color: item),
              )
              .toList());
    }

    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(_spacing),
        child: Text(
          ("${myList?['firstname']}'s techniques").toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      produceBelts(allYourBelts()),
      SizedBox(height: _spacing),
      ElevatedButton.icon(
        label: Text('Admin Console'),
        icon: Icon(Icons.settings),
        onPressed: () {
          print('Pressed');
        },
      )
    ]);
  }
}

class Belt extends StatelessWidget {
  final String curriculum;
  final String color;
  const Belt({
    Key? key,
    required this.curriculum,
    required this.color,
  }) : super(key: key);

  final double _beltHeight = 50;
  final double _innerPadding = 15;
  final double _borderRadius = 4;

  @override
  Widget build(BuildContext context) {
    Color getColor(color) {
      switch (color) {
        case 'white':
          {
            return Colors.white;
          }
          break;

        case 'yellow':
          {
            return Colors.yellow;
          }
          break;

        case 'green':
          {
            return Colors.green;
          }
          break;

        case 'blue':
          {
            return Colors.blue;
          }
          break;

        case 'purple':
          {
            return Colors.purple;
          }
          break;

        case 'brown':
          {
            return Colors.brown;
          }
          break;

        case 'black':
          {
            return Colors.black;
          }
          break;

        case 'red':
          {
            return Colors.red;
          }
          break;

        default:
          {
            return Colors.white;
          }
          break;
      }
    }

    if (curriculum == 'jawara_muda') {
      return TextButton(
        onPressed: () {
          print("Container clicked");
        },
        child: Container(
          height: _beltHeight,
          decoration: BoxDecoration(
            color: getColor(color),
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(_borderRadius),
          ),
        ),
      );
    } else {
      return TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TechniquesList()),
          );
        },
        child: Container(
          height: _beltHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(_borderRadius),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: _innerPadding),
            child: Container(
              color: getColor(color),
            ),
          ),
        ),
      );
    }
  }
}
