import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:silat_flutter/models/edit_user.dart';
import 'package:silat_flutter/models/pull_color_model.dart';


class ApprovedUsers extends StatefulWidget {
  const ApprovedUsers({Key? key}) : super(key: key);

  @override
  _ApprovedUsersState createState() => _ApprovedUsersState();
}

class _ApprovedUsersState extends State<ApprovedUsers> {
  final _database = FirebaseDatabase.instance.reference();
  double spacingWidth = 10;
  double spacingHeight = 10;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  late List myData = [];

  void _getUserData() {
    _database
        .child('users')
        .orderByChild('isApproved')
        .equalTo(true)
        .once()
        .then((snapshot) {
      final data = new Map<String, dynamic>.from(snapshot.snapshot.value as Map);
      setState(() {
        data.forEach((key, value) {
          value["id"] = key;
          myData.add(value);
        });
      });
    });
  }



  String formatCurriculum(dynamic curriculum) {
    return convertToTitleCase(curriculum.toString().replaceAll('_', ' '));
  }

  String convertToTitleCase(String input) {
    return input.replaceAllMapped(RegExp(r'\b\w'), (match) {
      return match.group(0)!.toUpperCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Approved Users'),
      ),
      body: SingleChildScrollView(
        child: ExpansionPanelList.radio(
          elevation: 3,
          children: Set.from(myData)
              .map(
                (dbItem) => ExpansionPanelRadio(
              value: UniqueKey(),
              canTapOnHeader: true,
              headerBuilder: (context, isOpen) => ListTile(
                leading: (dbItem?['curriculum'] == 'jawara_muda'
                    ? Icon(Icons.person,
                    size: 50.0, color: PullColor().getColor(dbItem?['belt']))
                    : Icon(Icons.perm_identity,
                    size: 50.0, color: PullColor().getColor(dbItem?['belt']))),
                title: Text(
                  dbItem?['firstname'].capitalizeFirstLetter() + " " + dbItem?['lastname'].capitalizeFirstLetter(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(formatCurriculum(dbItem?['curriculum'])),
              ),
              body: EditUserWidget(dbItem: dbItem, dbkey: dbItem?['id']),
            ),
          )
              .toList(),
        ),
      ),
    );
  }
}

/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import '../models/pull_color_model.dart';
import 'package:quartet/quartet.dart';
import '../models/edit_user.dart';

class ApprovedUsers extends StatefulWidget {
  const ApprovedUsers({Key? key}) : super(key: key);

  @override
  _ApprovedUsersState createState() => _ApprovedUsersState();
}

class _ApprovedUsersState extends State<ApprovedUsers> {
  double spacingWidth = 10;
  double spacingHeight = 10;
  List<bool> _isOpen = [false];

  @override
  void initState() {
    super.initState();
  }

  String formatCurriculum(curriculum) {
    return titleCase(curriculum.toString().replaceAll('_', ' '));
  }

  ExpansionPanelRadio _buildUsers({Map? dbItem, myIndex, dbkey}) {
    return ExpansionPanelRadio(
      value: myIndex,
      //isExpanded: _isOpen[0],
      canTapOnHeader: true,
      headerBuilder: (context, isOpen) => ListTile(
          leading: (dbItem?['curriculum'] == 'jawara_muda'
              ? Icon(Icons.person,
                  size: 50.0, color: PullColor().getColor(dbItem?['belt']))
              : Icon(Icons.perm_identity,
                  size: 50.0, color: PullColor().getColor(dbItem?['belt']))),
          title: Text(
            titleCase(dbItem?['firstname'] + " " + dbItem?['lastname']),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(formatCurriculum(dbItem?['curriculum'])),
        ),
      body: EditUserWidget(dbItem: dbItem, dbkey: dbkey),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Approved Users'),
      ),
      body: SafeArea(
        child: FirebaseAnimatedList(
          query: FirebaseDatabase.instance
              .reference()
              .child('users')
              .orderByChild('isApproved')
              .equalTo(true),
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Map dbItemValue = snapshot.value;

            dbItemValue['key'] = snapshot.key;
            return ExpansionPanelList.radio(
              children: [
                _buildUsers(dbItem: dbItemValue, myIndex: index, dbkey: snapshot.key),
              ],
              elevation: 9,
              animationDuration: Duration(milliseconds: 600),
            );
          },
        ),
      ),
    );
  }
}



class Album {
  final int userId;
  final int id;
  final String title;

  Album({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}*/

/*

import 'package:flutter/material.dart';
class ApprovedUsers extends StatefulWidget {
  ApprovedUserstate createState() =>  ApprovedUserstate();
}
class NewItem {
  bool isExpanded;
  final String header;
  final Widget body;
  final Icon iconpic;
  NewItem(this.isExpanded, this.header, this.body, this.iconpic);
}
class ApprovedUserstate extends State<ApprovedUsers> {
  List<NewItem> items = <NewItem>[
    NewItem(
        false, // isExpanded ?
        'Header', // header
        Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
                children: <Widget>[
                  Text('data'),
                  Text('data'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text('data'),
                      Text('data'),
                      Text('data'),
                    ],
                  ),
                  Radio(value: null, groupValue: null, onChanged: null)
                ]
            )
        ), // body
        Icon(Icons.image) // iconPic
    ),
    NewItem(
        false, // isExpanded ?
        'Header', // header
        Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
                children: <Widget>[
                  Text('data'),
                  Text('data'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text('data'),
                      Text('data'),
                      Text('data'),
                    ],
                  ),
                  Radio(value: null, groupValue: null, onChanged: null)
                ]
            )
        ), // body
        Icon(Icons.image) // iconPic
    ),
    NewItem(
        false, // isExpanded ?
        'Header', // header
        Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
                children: <Widget>[
                  Text('data'),
                  Text('data'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text('data'),
                      Text('data'),
                      Text('data'),
                    ],
                  ),
                  Radio(value: null, groupValue: null, onChanged: null)
                ]
            )
        ), // body
        Icon(Icons.image) // iconPic
    ),
  ];
  late ListView List_Criteria;
  Widget build(BuildContext context) {
    List_Criteria = ListView(
      children: [
        Padding(
          padding: EdgeInsets.all(10.0),
          child: ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                items[index].isExpanded = !items[index].isExpanded;
              });
            },
            children: items.map((NewItem item) {
              return ExpansionPanelRadio(
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return  ListTile(
                      leading: item.iconpic,
                      title:  Text(
                        item.header,
                        textAlign: TextAlign.left,
                        style:  TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                  );
                },
                //isExpanded: item.isExpanded,
                body: item.body, value: "asjlfkjaslkdfjalskdjf",
              );
            }).toList(),
          ),
        ),
      ],
    );
    Scaffold scaffold =  Scaffold(
      appBar:  AppBar(
        title:  Text("ExpansionPanelList"),
      ),
      body: List_Criteria,
    );
    return scaffold;
  }
}
 */
