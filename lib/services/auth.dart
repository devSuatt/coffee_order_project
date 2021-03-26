import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:order_project/models/brew.dart';
import 'package:order_project/models/user.dart';
import 'package:order_project/services/database.dart';

class AuthServices{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Users _userFromFirebaseUser(User user) {
    return user != null ? Users(uid: user.uid, email: user.email) : null;
  }

  // auth change user stream
  Stream<Users> get user {
    return _auth.authStateChanges()
    //.map((User user) => _userFromFirebaseUser(user));
    .map(_userFromFirebaseUser);  // same of up code
  }

  // sign in anonymously
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print("HATAAAAAAA => " + e.toString());
      return null;
    }
  }

  // sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print("HATA => "+e.toString());
      return null;
    }
  }

  // register with email & password
  Future registerWithEmailAndPassword(String name, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      // create a new document for the user with the uid
      Users newUser = new Users(name: name, uid: user.uid, email: email, role: 'user', password: password);
      await DatabaseService(uid: user.uid).setUserData(newUser);

      return _userFromFirebaseUser(user);
    } catch(e) {
      print("HATA => "+e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async{
    try {
      return await _auth.signOut();
    } catch(e) {
      print("HATA => "+e.toString());
      return null;
    }
  }

}
