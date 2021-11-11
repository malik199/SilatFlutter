import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class IsAdmin {
  User? _user = FirebaseAuth.instance.currentUser;
  final _database = FirebaseDatabase.instance.reference();

  bool trueOrFalse() {
    bool adminYes = false;
    var _myList;
    var _currentCurriculum = "lkhkljklj";
    _database
        .child('users')
        .orderByChild('email')
        .equalTo((_user?.email)?.toLowerCase())
        .limitToFirst(1)
        .once()
        .then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        final data = new Map<String?, dynamic>.from(snapshot.value);
        data.forEach((key, value) {
          _myList = value;
          _currentCurriculum = _myList?['curriculum'];
        });
      }
    });

    print("My Current Curriculum is: $_currentCurriculum");
    return adminYes;
  }
}
