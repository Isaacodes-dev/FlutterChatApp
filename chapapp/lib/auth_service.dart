import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier{
  //instance of auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //insatnce of firestore
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  //Sign user in
  Future<UserCredential>signInWithEmailandPassword(String email, String password) async{
    try{
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
        _fireStore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      }, SetOptions(merge: true));
      
      return userCredential;
    }on FirebaseAuthException catch(ex){
      throw Exception(ex.code);
    }
  }

  //create a new user
  Future<UserCredential> signUpWithEmailandPassword(String email, password) async{
    try{
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword
      (email: email, password: password);

      _fireStore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
      });
      return userCredential;
    }on FirebaseAuthException catch(ex){
      throw Exception(ex.code);
    }
  }

  //sign user out
  Future<void> signOut() async{
    return await FirebaseAuth.instance.signOut();
  }
}