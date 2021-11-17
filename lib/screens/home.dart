import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:silat_flutter/models/belts_complex.dart';
import 'package:silat_flutter/utils/connectivity.dart';
import 'package:silat_flutter/utils/fire_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:quartet/quartet.dart';
import 'package:silat_flutter/admin/avatar.dart';
//import 'package:firebase_database/ui/firebase_animated_list.dart';

class LandingPageData extends StatefulWidget {
  final User userPassed;
  const LandingPageData({required this.userPassed});

  @override
  _LandingPageDataState createState() => _LandingPageDataState();
}

class _LandingPageDataState extends State<LandingPageData> {
  late User _currentUser;
  final _database = FirebaseDatabase.instance.reference();
  late StreamSubscription _userDBStream;
  late StreamSubscription _topStudentsDBStream;
  var myUser;
  String _firstName = "";
  String _lastName = "";
  String _belt = "white";
  String _curriculum = "satria_muda";
  int _stripe = 0;
  int _age = 0;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.userPassed;
    _getUserData();
    _getToStudentData();
  }

  late List<dynamic> _satriaMudaData = [];
  late List<dynamic> _reversedSatriaMudaData = [];
  late List<dynamic> _jawaraMudaData = [];
  late List<dynamic> _reversedJawaraMudaData = [];
  void _getToStudentData() {
    _topStudentsDBStream = _database.child('users').orderByChild('score').onValue.listen((event) {
      if (event.snapshot.value != null) {
        _satriaMudaData = [];
        _jawaraMudaData= [];
        final data = new Map<String, dynamic>.from(event.snapshot.value);
        setState(() {
          data.forEach((key, value) {
            if (value["isApproved"] == true &&
                value['score'] != null &&
                value['curriculum'] == 'satria_muda') {
              _satriaMudaData.add(value);
            }
            if (value["isApproved"] == true &&
                value['score'] != null &&
                value['curriculum'] == 'jawara_muda') {
              _jawaraMudaData.add(value);
            }
          });
          _reversedSatriaMudaData = _satriaMudaData.reversed.toList();
          _reversedJawaraMudaData = _jawaraMudaData.reversed.toList();
        });
      }
    });
  }

  void _getUserData() {
    _userDBStream = _database
        .child('users')
        .orderByChild('email')
        .equalTo((_currentUser.email)?.toLowerCase())
        .limitToFirst(1)
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        final data = new Map<String?, dynamic>.from(event.snapshot.value);
        setState(() {
          data.forEach((key, value) {
            _firstName = value['firstname'];
            _lastName = value['lastname'];
            _belt = value['belt'];
            _curriculum = value['curriculum'];
            _age = value['age'];
            _stripe = value['stripe'];
          });
        });
      }
    });
  }

  String formatCurriculum(curriculum) {
    return titleCase(curriculum.toString().replaceAll('_', ' '));
  }

  Color _containerColor = Colors.yellow;
  bool _isSendingVerification = false;
  //bool _isSigningOut = false;

  void changeColor() {
    setState(() {
      if (_containerColor == Colors.yellow) {
        _containerColor = Colors.red;
        return;
      }
      _containerColor = Colors.yellow;
    });
  }

  int getStripes(numOfStripes) {
    int _realNumbOfStripes = numOfStripes ?? 0;
    if (_belt == "black" || _belt == "red") {
      _realNumbOfStripes = numOfStripes + 5;
    } else {
      _realNumbOfStripes = _realNumbOfStripes + 1;
    }

    return _realNumbOfStripes;
  }

  List items = [
    'Lizbeth-remimeara Solisoriantorisa',
    'Hazel Joyce',
    'Frankie Chase',
    'Remington Phelps',
    'Frank Lane',
    'Areli Pacheco',
    'Rachael Meyers',
    'Gavyn Gentry',
    'Holly Dixon',
    'Alexandria Swanson',
    'Daisy Petersen',
    'Katelynn Case',
    'Cade Mcdowell',
    'Raphael Barr',
    'Mareli Evans',
    'Beckett Reilly',
    'Trystan Mcmillan',
    'Tyler Cochran',
    'Deacon Cobb',
    'Lorelei Pierce',
    'Gordon Burgess',
    'Giovanni Blackwell',
    'Cade Mcdowell',
    'Raphael Barr',
    'Mareli Evans',
    'Beckett Reilly',
    'Trystan Mcmillan',
    'Tyler Cochran',
    'Deacon Cobb',
    'Lorelei Pierce',
    'Gordon Burgess',
    'Giovanni Blackwell',
  ];

  @override
  void deactivate() {
    _userDBStream.cancel();
    _topStudentsDBStream.cancel();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    double spacingBetween = 16;

    return Container(
      /* decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              const Color(0xff000000),
              const Color(0xff0c3e40),
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(0.0, 1.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),*/
      //color: Color(0xff0c2c2d),
      color: Colors.grey[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InternetConnection(),
          SizedBox(height: 3),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                    decoration: BoxDecoration(
                        color: Colors.blue[900],
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(titleCase(_firstName),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 26,
                                      color: Colors.white)),
                              Text(titleCase(_lastName),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 26,
                                      color: Colors.white)),
                              SizedBox(height: 10),
                              Text(_belt != "" ? titleCase('$_belt Belt') : "",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: Colors.white)),
                              Text(
                                  titleCase(formatCurriculum(_curriculum)) ??
                                      "",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: Colors.white)),
                              Text(
                                  _age != 0
                                      ? 'Age: ${titleCase(_age.toString())}'
                                      : "",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: Colors.white)),
                            ],
                          ),
                          SizedBox(width: 20),
                          TextButton(
                            onPressed: () => Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => Avatar())),
                            child: FluttermojiCircleAvatar(
                              radius: 70,
                            ),
                          ),
                        ],
                      ),
                    )),
                SizedBox(height: 5),
                BeltsComplex(
                    curriculum: _curriculum,
                    color: _belt,
                    stripes: getStripes(_stripe),
                    hasYellowStripe: _belt == "black" ? true : false),
              ],
            ),
          ),
          SizedBox(height: spacingBetween),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
            child: _currentUser.emailVerified
                ? Text('Your email <${_currentUser.email}> \nis verified',
                    style: TextStyle(color: Colors.green))
                : Column(
                    children: [
                      Text(
                        'Your email\n${_currentUser.email}\nis not verified',
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      _isSendingVerification
                          ? CircularProgressIndicator()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    setState(() {
                                      _isSendingVerification = true;
                                    });
                                    await _currentUser.sendEmailVerification();
                                    setState(() {
                                      _isSendingVerification = false;
                                    });
                                  },
                                  child: Text('VERIFY EMAIL',
                                      style: TextStyle(fontSize: 15)),
                                ),
                                SizedBox(width: 8.0),
                                IconButton(
                                  icon:
                                      Icon(Icons.refresh, color: Colors.white),
                                  onPressed: () async {
                                    User? user = await FireAuth.refreshUser(
                                        _currentUser);

                                    if (user != null) {
                                      setState(() {
                                        _currentUser = user;
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                    ],
                  ),
          ),
          SizedBox(height: spacingBetween),
          Container(
            color: Colors.black87,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.control_camera, size: 20, color: Colors.grey),
                SizedBox(width: 10),
                Text("TOP STUDENTS",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 27,
                        color: Colors.white)),
                SizedBox(width: 10),
                Icon(Icons.control_camera, size: 20, color: Colors.grey),
              ],
            ),
          ),
          Row(children: [
            Expanded(
                child: Container(
              padding: EdgeInsets.all(6),
              color: Colors.red,
              child: Text("Jawara Muda",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 17)),
            )),
            Expanded(
                child: Container(
              padding: EdgeInsets.all(6),
              color: Colors.blue,
              child: Text("Satria Muda",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 17)),
            )),
          ]),
          Expanded(
            child: Row(children: [
              Expanded(
                child: Container(
                  color: Colors.red,
                  child: ListView.builder(
                    itemCount: _reversedJawaraMudaData.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    '${titleCase(_reversedJawaraMudaData[index]['firstname'])} ${titleCase(_reversedJawaraMudaData[index]['lastname'])} (MD)',
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.blue),
                                  ),
                                ),
                                Text(
                                    (_reversedJawaraMudaData[index]['score'] ??
                                            "0")
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold))
                              ]),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: 0),
              Expanded(
                child: Container(
                  color: Colors.blue,
                  child: ListView.builder(
                    itemCount: _reversedSatriaMudaData.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    '${titleCase(_reversedSatriaMudaData[index]['firstname'])} ${titleCase(_reversedSatriaMudaData[index]['lastname'])} (MD)',
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.blue),
                                  ),
                                ),
                                Text(
                                    (_reversedSatriaMudaData[index]['score'] ??
                                            "0")
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold))
                              ]),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
