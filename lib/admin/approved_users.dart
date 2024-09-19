import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import '../models/pull_color_model.dart';
import '../models/edit_user.dart';

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

  String formatCurriculum(dynamic curriculum) {
    return convertToTitleCase(curriculum.toString().replaceAll('_', ' '));
  }

  String convertToTitleCase(String input) {
    return input.replaceAllMapped(RegExp(r'\b\w'), (match) {
      return match.group(0)!.toUpperCase();
    });
  }

  Widget _buildUsers({Map? dbItem, myIndex, dbkey}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: ExpansionTile(
            title: ListTile(
              leading: (dbItem?['curriculum'] == 'jawara_muda'
                  ? Icon(Icons.person,
                  size: 50.0, color: PullColor().getColor(dbItem?['belt']))
                  : Icon(Icons.perm_identity,
                  size: 50.0,
                  color: PullColor().getColor(dbItem?['belt']))),
              title: Text(
                dbItem?['firstname'] + " " + dbItem?['lastname'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(formatCurriculum(dbItem?['curriculum'])),
            ),
            children: [
              EditUserWidget(dbItem: dbItem, dbkey: dbkey)
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
        title: Text('Current Students'),
      ),
      body: SafeArea(
        child: FirebaseAnimatedList(
          query: FirebaseDatabase.instance
              .ref('users')
              .orderByChild('isApproved')
              .equalTo(true),
          itemBuilder: (BuildContext context, DataSnapshot? snapshot,
              Animation<double> animation, int index) {
            final dbItemValue = snapshot?.value as Map;
            dbItemValue['key'] = snapshot!.key;
            return (dbItemValue['curriculum'] != "guest" ? _buildUsers(dbItem: dbItemValue, myIndex: index, dbkey: snapshot.key) : SizedBox.shrink());
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