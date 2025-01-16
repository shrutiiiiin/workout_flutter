import 'package:firebase_auth/firebase_auth.dart';

class LinkAccountServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> linkEmailwithGoogle(String email, String password) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        final AuthCredential emailCredential =
            EmailAuthProvider.credential(email: email, password: password);
        await user.linkWithCredential(emailCredential);
        print("Successfully linked email and Google accounts.");
      } catch (e) {
        print("Error linking accounts: $e");
      }
    } else {
      print("No user is signed in.");
    }
  }

  Future<void> linkGooglewithEmail(AuthCredential googleCredential) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await user.linkWithCredential(googleCredential);
        print("Successfully linked Google and email accounts.");
      } catch (e) {
        print("Error linking accounts: $e");
      }
    } else {
      print("No user is signed in.");
    }
  }
}
