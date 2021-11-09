import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class EditProfileWidget extends StatefulWidget {
  const EditProfileWidget({
    Key? key,
    required this.dbItem,
    required this.dbkey,
  }) : super(key: key);

  final dbItem;
  final dbkey;
  @override
  _EditProfileWidgetState createState() => _EditProfileWidgetState();
}

class _EditProfileWidgetState extends State<EditProfileWidget> {
  final _database = FirebaseDatabase.instance.reference();

  double spacingWidth = 10;
  double spacingHeight = 10;
  String _beltColor = "";
  String _curriculum = "";
  bool _isApprov = false;

  void initState() {
    _beltColor = widget.dbItem?['belt'];
    _curriculum = widget.dbItem?['curriculum'];
    _isApprov = widget.dbItem?['isApproved'];
    print(widget.dbItem);
    super.initState();
  }

  final snackBarRed = SnackBar(
    content: Text('A problem occured.'),
    backgroundColor: Colors.red,
  );
  final snackBarGreen = SnackBar(
    content: Text('Success! You have updated the user.'),
    backgroundColor: Colors.green,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 16),
              Icon(Icons.email),
              SizedBox(width: spacingWidth),
              Text(widget.dbItem?['email']),
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
              items: <String>[
                'white',
                'yellow',
                'green',
                'blue',
                'purple',
                'brown',
                'black',
                'red'
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            )
          ]),
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
              items: <String>[
                'jawara_muda',
                'satria_muda',
                'abah_jawara',
                'guest',
                'instructor'
              ].map<DropdownMenuItem<String>>((String value) {
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
              value: _isApprov,
              onChanged: (bool value) {
                setState(() => _isApprov = value);
              }),
          SizedBox(height: 20),
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(12.0),
                  ),
                  primary: Colors.purple,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              icon: Icon(Icons.save),
              label: Text("Update Profile"),
              onPressed: () {
                _database
                    .child('/users')
                    .child(widget.dbkey)
                    .update({
                      'belt': _beltColor,
                      'curriculum': _curriculum,
                      'isApproved': _isApprov,
                    })
                    .then((value) =>
                        ScaffoldMessenger.of(context).showSnackBar(snackBarGreen))
                    .catchError((error) => ScaffoldMessenger.of(context)
                        .showSnackBar(snackBarRed));
              }),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
