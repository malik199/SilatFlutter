import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import '../screens/edit_user.dart';

class UnapprovedUsers extends StatefulWidget {
  const UnapprovedUsers({Key? key}) : super(key: key);

  @override
  _UnapprovedUsersState createState() => _UnapprovedUsersState();
}

class _UnapprovedUsersState extends State<UnapprovedUsers> {
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
          color: Colors.orangeAccent,
          child: ExpansionTile(
            backgroundColor: Colors.black,
            title: ListTile(
              leading: Icon(Icons.no_accounts, size: 50.0, color: Colors.red),
              title: Text(
                dbItem?['firstname'] +
                    " " +
                    dbItem?['lastname'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(formatCurriculum(dbItem?['curriculum'])),
            ),
            children: [EditUserWidget(dbItem: dbItem, dbkey: dbkey, editMode: 'update',)],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Unapproved Users'),
      ),
      body: SafeArea(
        child: FirebaseAnimatedList(
          query: FirebaseDatabase.instance
              .ref('users')
              .orderByChild('isApproved')
              .equalTo(false),
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            Map dbItemValue = snapshot.value as Map;
            dbItemValue['key'] = snapshot.key;
            return _buildUsers(
                dbItem: dbItemValue, myIndex: index, dbkey: snapshot.key);
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
