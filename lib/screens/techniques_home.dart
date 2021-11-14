import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:silat_flutter/models/belts.dart';
import 'package:silat_flutter/utils/connectivity.dart';

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
  String _firstName = "";
  String _currentCurriculum = "jawara_muda";
  String _currentBelt = "white";
  String _unchangingCurriculum = "satria_muda";
  String _belt = "";

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
            _currentCurriculum = value['curriculum'];
            _verified = value['isApproved'];
            _currentBelt = value['belt'];
            _unchangingCurriculum = value['curriculum'];
            _firstName = value['firstname'];
            _belt = value['belt'];
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
      for (var i = 0; i <= _fullBeltArray.indexOf(_belt); i++) {
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
      //print(_currentCurriculum);
    }

    Widget showSwitchCurriculumButton() {
      return (_unchangingCurriculum == "instructor" || _currentBelt == "black")
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
          InternetConnection(),
          Padding(
            padding: const EdgeInsets.all(_spacing),
            child: Text(
              _firstName != ""
                  ? ("$_firstName's techniques").toUpperCase()
                  : "",
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
