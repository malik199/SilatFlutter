import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:silat_flutter/admin/avatar.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final formKey = GlobalKey<FormState>(); //key for form
  final _database = FirebaseDatabase.instance.reference();
  User? _user = FirebaseAuth.instance.currentUser;

  String username = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    //_controller = TextEditingController();
    //print(_user?.displayName);
  }

  var myData;
  var myList;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    double paddingBetween = 24;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.person_outline),
            SizedBox(width: 20),
            const Text('My Profile'),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 32),
        physics: BouncingScrollPhysics(),
        children: [
          Form(
            key: formKey, //key for form
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: paddingBetween),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  initialValue: _user?.displayName ?? "",
                  validator: (value) {
                    if (value!.length < 4) {
                      return 'Enter at least 4 characters';
                    } else {
                      return null;
                    }
                  },
                  maxLength: 30,
                  onSaved: (value) =>
                      setState(() => username = value.toString()),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  initialValue: _user?.email ?? "",
                  validator: (value) {
                    final pattern =
                        r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
                    final regExp = RegExp(pattern);

                    if (value!.isEmpty) {
                      return 'Enter an email';
                    } else if (!regExp.hasMatch(value.toString())) {
                      return 'Enter a valid email';
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (value) => setState(() => email = value.toString()),
                ),
                SizedBox(height: paddingBetween),
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(12.0),
                        ),
                        primary: Colors.purple,
                        padding:
                        EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        textStyle: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    icon: Icon(Icons.save),
                    label: Text("Update Profile"),
                    onPressed: () {
                      final isValid = formKey.currentState?.validate();
                      // FocusScope.of(context).unfocus();

                      if (isValid!) {
                        formKey.currentState?.save();

                        final message = 'Username: $username\nPassword: $email';
                        final snackBar = SnackBar(
                          content: Text(
                            message,
                            style: TextStyle(fontSize: 20),
                          ),
                          backgroundColor: Colors.green,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    })
              ],
            ),
          ),
          SizedBox(height: paddingBetween),
          FluttermojiCircleAvatar(
            backgroundColor: Colors.grey[200],
            radius: 100,
          ),
          SizedBox(height: paddingBetween),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(12.0),
                ),
                primary: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                textStyle:
                    TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            icon: Icon(Icons.edit),
            label: Text("Change Avatar"),
            onPressed: () => Navigator.push(
                context, new MaterialPageRoute(builder: (context) => Avatar())),
          ),
        ],
      ),
    );
  }
}

class SnackBarPage extends StatelessWidget {
  const SnackBarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          final snackBar = SnackBar(
            content: const Text('Yay! A SnackBar!'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                // Some code to undo the change.
              },
            ),
          );

          // Find the ScaffoldMessenger in the widget tree
          // and use it to show a SnackBar.
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        child: const Text('Show SnackBar'),
      ),
    );
  }
}

/*          SizedBox(height: paddingBetween),
          TextFieldWidget(
            label: 'Full Name',
            text: _user?.displayName ?? "",
            onChanged: (name) {},
          ),
          SizedBox(height: paddingBetween),
          TextFieldWidget(
            label: 'Last Name',
            text: _user?.email ?? "",
            onChanged: (email) {
              print(email);
            },
          ),
          SizedBox(height: paddingBetween),
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(12.0),
                  ),
                  primary: Colors.purple,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle:
                  TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              icon: Icon(Icons.save),
              label: Text("Update Profile"),
              onPressed: () => {
                print(_controller)
              }),
          SizedBox(height: paddingBetween),
          TextFieldWidget(
            label: 'About',
            text: "Now you know about me",
            maxLines: 3,
            onChanged: (about) {},
          ),






 */
