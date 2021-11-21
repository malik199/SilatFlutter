import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class IsAdmin {
  User? _user = FirebaseAuth.instance.currentUser;
  final _database = FirebaseDatabase.instance.reference();

  Future<bool> trueOrFalse() {
    var _myList;
    var _currentCurriculum = "nothing";
    return _database
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
          //print(_currentCurriculum);
          return _currentCurriculum == "instructor" ? true : false;
        });
  }
}
