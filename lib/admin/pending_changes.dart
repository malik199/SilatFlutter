import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import '../models/pull_color_model.dart';
import '../models/edit_user.dart';

class PendingChanges extends StatefulWidget {
  const PendingChanges({Key? key}) : super(key: key);

  @override
  _PendingChangesState createState() => _PendingChangesState();
}

class _PendingChangesState extends State<PendingChanges> {
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref().child('pending');
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

  Widget _buildUsers({Map? dbItem, myIndex, dbkey, editMode}) {
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
              EditUserWidget(dbItem: dbItem, dbkey: dbkey, editMode: editMode)
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
        title: Text('Pending Changes'),
      ),
      body: SafeArea(
        child: FirebaseAnimatedList(
          query: databaseReference,
          itemBuilder: (BuildContext context, DataSnapshot? snapshot,
              Animation<double> animation, int index) {

            // Check for null snapshot and snapshot.value
            if (snapshot?.value == null) {
              return SizedBox.shrink(); // Alternatively, you could return a placeholder
            }

            // Safely cast to Map and handle non-Map values
            final dbItemValue = (snapshot?.value is Map) ? snapshot?.value as Map : {};

            // Include the key in dbItemValue if not null
            if (snapshot!.key != null) {
              dbItemValue['key'] = snapshot.key;
            }

            // Check curriculum condition and return appropriate widget
            return (dbItemValue['curriculum'] != "guest"
                ? _buildUsers(dbItem: dbItemValue, myIndex: index, dbkey: snapshot.key, editMode: 'pending')
                : SizedBox.shrink());
/*            final dbItemValue = snapshot?.value as Map;
            dbItemValue['key'] = snapshot!.key;
            return (dbItemValue['curriculum'] != "guest" ? _buildUsers(dbItem: dbItemValue, myIndex: index, dbkey: snapshot.key) : SizedBox.shrink());*/
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