import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import '../models/pull_color_model.dart';
import 'package:quartet/quartet.dart';

class ApprovedUsers extends StatefulWidget {
  const ApprovedUsers({Key? key}) : super(key: key);

  @override
  _ApprovedUsersState createState() => _ApprovedUsersState();
}

class _ApprovedUsersState extends State<ApprovedUsers> {
  double spacingWidth = 10;
  double spacingHeight = 10;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String formatCurriculum(curriculum) {
    return titleCase(curriculum.toString().replaceAll('_', ' '));
  }

  final snackBar = SnackBar(content: Text('Yay! A SnackBar!'));
  String _beltColor = 'white';
  String _curriculum = 'jawara_muda';
  bool _toggled = false;

  Widget _buildUsers({Map? dbItem, myIndex}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: ExpansionTile(
            backgroundColor: Colors.grey[100],
            title: ListTile(
              leading: (dbItem?['curriculum'] == 'jawara_muda'
                  ? Icon(Icons.person,
                      size: 50.0, color: PullColor().getColor(dbItem?['belt']))
                  : Icon(Icons.perm_identity,
                      size: 50.0,
                      color: PullColor().getColor(dbItem?['belt']))),
              title: Text(
                titleCase(dbItem?['firstname'] + " " + dbItem?['lastname']),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(formatCurriculum(dbItem?['curriculum'])),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 16),
                        Icon(Icons.email),
                        SizedBox(width: spacingWidth),
                        Text("${dbItem?['email']}"),
                      ],
                    ),
                    SizedBox(height: spacingHeight),
                    Row(children: [
                      SizedBox(width: 16),
                      Icon(Icons.horizontal_split),
                      SizedBox(width: spacingWidth),
                      DropdownButton<String>(
                        value: _beltColor,
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            _beltColor = newValue!;
                          });
                        },
                        items: <String>['white', 'yellow', 'green', 'blue', 'purple', 'brown', 'black']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )
                    ]),
                    SwitchListTile(
                        title: Row(children: [
                          Icon(Icons.thumb_up_alt),
                          SizedBox(width: spacingWidth),
                          Text(
                            "Approval",
                            style: TextStyle(fontSize: 15),
                          )
                        ]),
                        value: _toggled,
                        onChanged: (bool value) {
                          setState(() => _toggled = value);
                        }),
                    Row(children: [
                      SizedBox(width: 16),
                      Icon(Icons.assignment),
                      SizedBox(width: spacingWidth),
                      DropdownButton<String>(
                        value: _curriculum,
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            _curriculum = newValue!;
                          });
                        },
                        items: <String>['jawara_muda', 'satria_muda', 'abah_jawara', 'instructor']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )
                    ]),
                    SizedBox(height: 20),
                    ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(12.0),
                            ),
                            primary: Colors.purple,
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 20),
                            textStyle: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        icon: Icon(Icons.save),
                        label: Text("Update Profile"),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }),
                    SizedBox(height: 20),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Techniques'),
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
            return _buildUsers(dbItem: dbItemValue, myIndex: index);
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
}
