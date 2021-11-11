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
  bool _verified = true;
  String _currentCurriculum = "jawara_muda";
  String _currentBelt = "white";

  void getYourTechniques() {
    _database
        .child('users')
        .orderByChild('email')
        .equalTo((_user?.email)?.toLowerCase())
        .limitToFirst(1)
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        final data = new Map<String?, dynamic>.from(snapshot.value);
        setState(() {
          data.forEach((key, value) {
            myList = value;
            print('My List ${myList}');
            _currentCurriculum = myList?['curriculum'];
            _verified = myList?['isApproved'];
            _currentBelt = myList?['belt'];
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const double _spacing = 18;

    //String _currentCurriculum = "satria_muda";
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
    void switchCurriculums(_currCurric) {
      setState(() {
        if (_currCurric == 'jawara_muda' || _currCurric == 'instructor') {
          _currentCurriculum = "satria_muda";
        } else {
          _currentCurriculum = 'jawara_muda';
        }
      });
      print(_currentCurriculum);
    }

    Widget showSwitchCurriculumButton() {
      return (_currentCurriculum == "instructor" || _currentBelt == "black")
          ? ElevatedButton.icon(
              label: Text('Switch Curriculums'),
              icon: Icon(Icons.swap_horiz),
              onPressed: () {
                switchCurriculums(_currentCurriculum);
              },
            )
          : SizedBox.shrink();
    }

    Widget produceBelts(List<dynamic> _allbelts) {
      return Column(
          children: _allbelts
              .map(
                (item) => Belt(curriculum: _currentCurriculum, color: item),
              )
              .toList());
    }

    Widget allTechniqueWidget = Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                const Color(0xff000000),
                const Color(0xff0c3e40),
              ],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(0.0, 1.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
        width: double.infinity,
        //color: Color(0xff02252c),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(_spacing),
            child: Text(
              ("${myList?['firstname']}'s techniques").toUpperCase(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.white),
            ),
          ),
          produceBelts(allYourBelts()),
          SizedBox(height: _spacing),
          showSwitchCurriculumButton(),
        ]));

    return _verified
        ? allTechniqueWidget
        : Row(
      mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.warning,
                color: Colors.orangeAccent,
                size: 50,
              ),
              SizedBox(width: 10),
              Text(
                  "You need to be _verified before you view. \nPlease contact your instructor\n or email: info@silatva.com",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          );
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
    if (curriculum == 'jawara_muda' ||
        curriculum == "instructor" ||
        curriculum == 'guest') {
      return TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    TechniquesList(curriculum: "jawara_muda", color: color)),
          );
        },
        child: Container(
          height: _beltHeight,
          decoration: BoxDecoration(
            color: PullColor().getColor(color),
            border: Border.all(
              color: Colors.black26,
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
            MaterialPageRoute(
                builder: (context) =>
                    TechniquesList(curriculum: "satria_muda", color: color)),
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
