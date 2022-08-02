import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import '../models/user.dart' as model;

class AuthMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  Future<String >signUpTheUser({
    required String email,
    required String userName,
    required String password,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error occured";
    
    try{
      if(email.isNotEmpty || userName.isNotEmpty || password.isNotEmpty || bio.isNotEmpty 
      || file != null
      ){
        
        //register user
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        print(userCredential.user!.uid);

        String profilePhotoUrl = await StorageMethods().uploadImageToStorage('profilePic', file, false);

        //add user to the database
        model.User user = model.User(
          username: userName,
          uid : userCredential.user!.uid,
          bio: bio,
          email : email,
          followers : [],
          following: [],
          profilePhotoUrl: profilePhotoUrl,
        );
 
        _firestore.collection("users").doc(userCredential.user!.uid).set(user.toJson());
        res = "Success!";
      } 
    } on FirebaseAuthException catch(e){
        if(e.code == 'invalid-email'){
          res = 'The email is badly formatted';
        }else if(e.code == 'weak-password'){
          res = 'Your password is weak because it is less than 6 characters.';
        }
    }
    catch(err){
      res = err.toString();
    }
    return res;
  }
  // loginng in the user

  Future<String> loginTheUser({
    required String email,
    required String password
  }) async {
    String res = 'Some error has occured';
    try{
      if(email.isNotEmpty || password.isNotEmpty){
       await _auth.signInWithEmailAndPassword(email: email, password: password);
       res = 'Success!';
      }
      else{
        res = "Please fill in all the fields";
      }
    } catch(error){
      res = error.toString();
    }
    return res;
  }
}