import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:silat_flutter/screens/belts.dart';
import 'package:silat_flutter/utils/connectivity.dart';

class TechniquesHome extends StatefulWidget {
  const TechniquesHome({Key? key}) : super(key: key);

  @override
  _TechniquesHomeState createState() => _TechniquesHomeState();
}

class _TechniquesHomeState extends State<TechniquesHome> {
  final textcontroller = TextEditingController();
  final _database = FirebaseDatabase.instance;
  //final Future<FirebaseApp> _future = Firebase.initializeApp();
  User? _user = FirebaseAuth.instance.currentUser;
  late StreamSubscription _beltsDBStream;

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
    _beltsDBStream = _database
        .ref('users')
        .orderByChild('email')
        .equalTo((_user?.email)?.toLowerCase())
        .limitToFirst(1)
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        final data = new Map<String?, dynamic>.from(event.snapshot.value as Map);
        setState(() {
          data.forEach((key, value) {
            _currentCurriculum = value['curriculum'];
            _verified = value['isApproved'];
            _currentBelt = value['belt'];
            _unchangingCurriculum =
                getUnchangingCurriculum(value['curriculum']);
            _firstName = value['firstname'];
            _belt = value['belt'];
          });
        });
      }
    });
  }

  String getUnchangingCurriculum(_unchangingCurr) {
    String computedCurr = _unchangingCurr;
    if (_unchangingCurr == 'guest') {
      computedCurr = 'jawara_muda';
    }
    return computedCurr;
  }

  @override
  void deactivate() {
    _beltsDBStream.cancel();
    super.deactivate();
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
              label: Text('SWITCH CURRICULUMS', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'PTSansNarrow')),
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

    Widget allTechniqueWidget = SingleChildScrollView(
        child: Column(children: [
          //InternetConnection(),
          Padding(
            padding: const EdgeInsets.all(_spacing),
            child: Text(
              _firstName != ""
                  ? ("techniques").toUpperCase()
                  : "",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.white),
            ),
          ),
          Text("Click on the belt for your techniques"),
          produceBelts(allYourBelts()),
          SizedBox(height: _spacing),
          showSwitchCurriculumButton(),
        ]));

    return _verified
        ? allTechniqueWidget
        : Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
                children: [
                  SizedBox(width: 20),
                  Icon(
                    Icons.warning,
                    color: Colors.orangeAccent,
                    size: 50,
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    child: Text(
                        "You need to be approved before you can view techniques. Please contact your instructor\n or email: info@silatva.com",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red)),
                  ),
                ],
              ),
          ],
        );
  }
}
