import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/global_variable.dart';
import 'package:provider/provider.dart';
import 'package:instagram_clone/models/user.dart' as model;

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({ Key? key }) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {

 

  // String username = '';
  // @override
  // void initState() {
  //   getUserName();
  //   super.initState();
  // }

  // void getUserName() async {
  //  DocumentSnapshot snap = await FirebaseFirestore.instance.
  //   collection('users').
  //   doc(FirebaseAuth.instance.currentUser!.uid)
  //   .get();

  //   print(snap.data());

  //   setState(() {
      
  //   username = (snap.data() as Map<String, dynamic>)['username'];
  //   });
  // }
  late PageController pageController;
  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
  int _page = 0;

  void navigationTap(int page){
    
    pageController.jumpToPage(page);
  }
  void onPageChanged(int page){
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
   // model.User user = Provider.of<UserProvider>(context).getUser;
   
    return Scaffold(
      body: PageView(
        children: homeScreenItems,
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: mobileBackgroundColor,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home, color: _page == 0? primaryColor : secondaryColor,), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search, color: _page == 1? primaryColor : secondaryColor,), label: ''  ),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle, color:  _page == 2? primaryColor : secondaryColor,), label: '', ),
          BottomNavigationBarItem(icon: Icon(Icons.favorite, color: _page == 3? primaryColor : secondaryColor,), label: '' ),
          BottomNavigationBarItem(icon: Icon(Icons.person, color: _page == 4? primaryColor : secondaryColor,), label: '' ),
        ],
      onTap: navigationTap
      ),
    );
  }
}