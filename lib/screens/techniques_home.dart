import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'techniques_list.dart';
import '../models/pull_color_model.dart';

class TechniquesHome extends StatefulWidget {
  const TechniquesHome({Key? key}) : super(key: key);

  @override
  _TechniquesHomeState createState() => _TechniquesHomeState();
}

class _TechniquesHomeState extends State<TechniquesHome> {
  final textcontroller = TextEditingController();
  final _database = FirebaseDatabase.instance.reference();
  //final Future<FirebaseApp> _future = Firebase.initializeApp();
  User? _user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    getYourTechniques();
  }

  var myData;
  var myList;
  bool verified = true;

  void getYourTechniques() {
    _database
        .child('users')
        .orderByChild('email')
        .equalTo((_user?.email)?.toLowerCase())
        .limitToFirst(1)
        .once()
        .then((DataSnapshot snapshot) {
      if(snapshot.value != null){
        final data = new Map<String?, dynamic>.from(snapshot.value);
        setState(() {
          data.forEach((key, value) {
            myList = value;
            print('My List ${myList}');
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const double _spacing = 18;
    String currentCurriculum = myList?['curriculum'] ?? "jawara_muda";

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

    // Yet to be completed
    void switchCurriculums(){
      setState(() {
        currentCurriculum = "satria_muda";
      });
    }

    Widget produceBelts(List<dynamic> _allbelts) {
      return Column(
          children: _allbelts
              .map(
                (item) => Belt(curriculum: currentCurriculum, color: item),
              )
              .toList());
    }

    Widget allTechniqueWidget  = Column(children: [
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
        label: Text('Switch Curriculums'),
        icon: Icon(Icons.swap_horiz ),
        onPressed: () {
          switchCurriculums();
        },
      )
    ]);

    return verified ? allTechniqueWidget : Text("You need to be verified before you view.");
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

    if (curriculum == 'jawara_muda' || curriculum == "instructor") {
      return TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TechniquesList(curriculum: "jawara_muda", color: color)),
          );
        },
        child: Container(
          height: _beltHeight,
          decoration: BoxDecoration(
            color: PullColor().getColor(color),
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
            MaterialPageRoute(builder: (context) => TechniquesList(curriculum: "satria_muda", color: color)),
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
              color: PullColor().getColor(color),
            ),
          ),
        ),
      );
    }
  }
}
