import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {     //logo
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: SvgPicture.asset('assets/sample.svg', color: primaryColor, height: 32,),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.message_outlined))
        ],
      ),
      body: StreamBuilder(        //Connect Firestore and Stream
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(     //List View to present all the posted posts
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index){
              return PostCard(
                snap: snapshot.data!.docs[index].data(),
              );
          });
        },
      ),
    );
  }
}