import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:silat_flutter/login/login_page.dart';

class DeleteUserPage extends StatefulWidget {
  @override
  _DeleteUserPageState createState() => _DeleteUserPageState();
}

class _DeleteUserPageState extends State<DeleteUserPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  Future<void> deleteUserFromAuth(String uid) async {
    try {
      await _auth.currentUser!.delete();
      print('User deleted successfully');
    } on FirebaseAuthException catch (e) {
      print('Error deleting user: ${e.message}');
    }
  }

  void deleteUser() {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      String uid = currentUser.uid;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Confirm Deletion"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text("Are you sure you want to delete your account? This action cannot be undone."),
                  SizedBox(height: 10),
                  Text("This will delete your user profile and all associated information permanently."),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  // Perform the deletion
                  deleteUserFromAuth(uid);
                  _database.ref('users').child(uid).remove().then((_) async {
                    print("User Deleted from Database!");
                    // Sign out the user
                    _auth.signOut();
                    Navigator.of(context).pop();  // Close the dialog
                    //await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    ); // Return to previous screen or logout
                  }).catchError((error) {
                    print("Problem Deleting User from Database: $error");
                  });
                },
                child: Text('Delete'),
              ),
            ],
          );
        },
      );
    } else {
      print("No user signed in.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Delete My Account"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => deleteUser(),
          child: Text("Delete My Account"),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.red,
          ),
        ),
      ),
    );
  }
}
