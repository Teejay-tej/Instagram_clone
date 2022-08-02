import 'package:cloud_firestore/cloud_firestore.dart';

class User {
 final String username;
 final String uid;
 final String bio;
 final String email;
 final List followers;
 final List following;
 final String profilePhotoUrl;
  User({
    required this.username,
    required this.uid,
    required this.bio,
    required this.email,
    required this.followers,
    required this.following,
    required this.profilePhotoUrl,
  });


  Map<String, dynamic> toJson() => {
          'username': username,
          'uid': uid,
          'bio': bio,
          'email': email,
          'followers': [],
          'following': [],
          'profilePhotoUrl': profilePhotoUrl,
  };

  static User fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      username: snapshot['username'],
      uid: snapshot['uid'],
      bio: snapshot['bio'],
      profilePhotoUrl: snapshot['profilePhotoUrl'],
      followers: snapshot['followers'],
      following: snapshot['following'],
      email: snapshot['email'],
    );
  }
}

