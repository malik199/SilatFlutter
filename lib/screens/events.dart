import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:silat_flutter/models/isAdmin.dart';
import 'package:intl/intl.dart';

class Events extends StatefulWidget {
  const Events({Key? key}) : super(key: key);

  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  double spacingWidth = 10;
  double spacingHeight = 10;
  bool _isAdmin = false;

  @override
  void initState() {
    IsAdmin().trueOrFalse().then((res) {
      //print(res);
      setState(() {
        _isAdmin = res;
      });
    });
    super.initState();
  }

  void deleteItem(dbKey) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("You are about to delete an event"),
          content: new Text("Are you sure you want delete this event?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                FirebaseDatabase.instance
                    .ref()
                    .child('events')
                    .child(dbKey)
                    .remove()
                    .whenComplete(() {
                  print("Event Deleted!");
                  Navigator.pop(context, true);
                }).catchError((error) {
                  print("Problem Deleting Item: ${error}");
                });
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FirebaseAnimatedList(
          query: FirebaseDatabase.instance.ref().child('events').orderByChild('date')
              .startAt(DateTime.now().toString()),
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            // ------------------- BEGINNING OF DATABASE STUFF -------------------
            Map dbItemValue = snapshot.value as Map;
            String? dbKey = snapshot.key;

            final eventDate = DateTime.parse(dbItemValue['date']);
            final date2 = DateTime.now();
            final difference = -(date2.difference(eventDate).inDays);

            return (difference >= 0
                ? Card(
                    color: Colors.yellow,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(3, 8, 8, 9),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        horizontalTitleGap: 6,
                        leading: _isAdmin == true
                            ? TextButton.icon(
                                onPressed: () {
                                  deleteItem(dbKey);
                                },
                                label: SizedBox.shrink(),
                                icon: Icon(
                                  Icons.delete,
                                  size: 40,
                                  color: Colors.red,
                                ))
                            : Icon(Icons.event, size: 50),
                        title: Text(dbItemValue['name'],
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text('Event Date: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text((DateFormat('MMM dd, yyyy').format(
                                        DateTime.parse(dbItemValue['date'])))
                                    .toString()),
                              ],
                            ),
                            Row(
                              children: [
                                Text('Location: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text(dbItemValue['location']),
                              ],
                            ),
                            Row(
                              children: [
                                Text('Deadline: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text((DateFormat('MMM dd, yyyy').format(
                                        DateTime.parse(
                                            dbItemValue['deadline'])))
                                    .toString()),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(dbItemValue['desc'])
                          ],
                        ),
                        trailing: FittedBox(
                          child: Column( children: [
                            Text('DAYS LEFT',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 8)),
                            Text((difference + 1).toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 40)),
                          ]),
                        ),
                      ),
                    ),
                  )
                : SizedBox.shrink());
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
