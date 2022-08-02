import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
        String description,
        String uid,
        Uint8List file,
        String username,
       // String postId,
        //String postUrl,
        String profImage,

  ) async{

    String res = 'Some error occured';
   
    try{
      String photoUrl = await StorageMethods().uploadImageToStorage('posts', file, true);
       String postId = const Uuid().v1();
      Post post = Post(description: description, uid: uid, username: username, likes: [], postId: postId, datePublished: DateTime.now(), postUrl: photoUrl, profImage: profImage);
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = 'success';
    }catch(err){
      res = err.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try{
      if(likes.contains(uid)){
      await  _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      }
      else{
      await  _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    }
    catch(e){
      print(e.toString());
    }
  }
  Future<void> postComment(String postId, String text, String uid, String name, String profilePic) async {
    try{
      String commentId = const Uuid().v1();
      if(text.isNotEmpty){
     await   _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).set({
          'profilePic': profilePic,
          'name': name,
          'uid' : uid,
          'text' : text,
          'commentId' : commentId,
          'datePublished' : DateTime.now()
        });
      }
      else{
        print('Text is empty');
      }
    }
    catch(e){
      print(e.toString());
    }

  }
}