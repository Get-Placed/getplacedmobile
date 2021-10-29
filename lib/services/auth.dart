import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future signInEmailPass(String email, String password) async {
    try {
      print(email);
      print(password);
      UserCredential _authResult = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _authResult.user!.email;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw Exception(e.message);
    }
  }

  Future signUpEmailPass(
    String email,
    String password,
    String username,
    int role,
    String userFrom,
  ) async {
    try {
      UserCredential _authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      FirebaseFirestore.instance.collection("Users").doc(email).set({
        "uid": _auth.currentUser!.uid,
        "role": role,
        "userName": username,
        "email": email,
        "userFrom": userFrom,
      });
      return _authResult.user!.email;
    } on FirebaseAuthException catch (e) {
      print(e.message);

      throw Exception(e.message);
    }
  }

  Future resetEmailPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      return e.message;
    }
  }
}
