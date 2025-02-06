import 'package:firebase_auth/firebase_auth.dart';

class EmailSignInServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInwithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found with this email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Incorrect password. Please try again.');
      } else {
        throw Exception('Failed to login. Please check your credentials.');
      }
    } catch (e) {
      throw Exception('An unknown error occurred: $e');
    }
  }

  Future<User?> signUpwithEmail(
      {required String email, required String password}) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception('This email is already registered. Try logging in.');
      } else if (e.code == 'weak-password') {
        throw Exception('Password should be at least 6 characters long.');
      } else {
        throw Exception('Failed to sign up. Please check your details.');
      }
    } catch (e) {
      throw Exception('An unknown error occurred: $e');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
