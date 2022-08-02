import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/comment_card.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {

  final snap;
  const CommentsScreen({Key? key, this.snap}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _controller = TextEditingController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text('Comments'),
        centerTitle: false,
        
      ),

      body: StreamBuilder(         //connecting Firestore for comments
        stream: 
        FirebaseFirestore.instance.
        collection('posts').           //two firebase collections named posts and comments
        doc(widget.snap['postId']).
        collection('comments').
        orderBy('datePublished', descending: true).
        snapshots(),
        builder: (context,  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(        //lists of comments to scroll through comments picked from firestore
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index){
              return  CommentCard(
                snap: snapshot.data!.docs[index], //build a commet card
              );
            }
            );
        },
      ) ,
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:  EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage('${user.profilePhotoUrl}'),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right:8.0),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Comment as ${user.username}',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await FirestoreMethods().
                  postComment(
                    widget.snap['postId'], 
                  _controller.text, 
                  user.uid,
                  user.username, 
                  user.profilePhotoUrl.toString()
                  );
                  setState(() {
                    _controller.text = "";
                  });               },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                  child: const Text(
                    'Post',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
                
              )
            ],
          ),
        ),
        ),
    );

  }
}