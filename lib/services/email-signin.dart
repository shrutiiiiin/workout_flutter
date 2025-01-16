import 'package:firebase_auth/firebase_auth.dart';

class EmailSignInServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInwithEmail(
      {required String email, required String password}) async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print("Error signing in with email: $e");

      print(e);
    }
  }

  Future<User?> signUpwithEmail(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print("Error signing up with email: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
