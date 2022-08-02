import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/user_provider.dart';

import 'package:instagram_clone/utils/global_variable.dart';
import 'package:provider/provider.dart';

class ResponsiveLayoutScreen extends StatefulWidget {
  const ResponsiveLayoutScreen({
    Key? key,
    required this.webScreenLayout,
    required this.MobileScreenLayout,
  }) : super(key: key);
  final Widget webScreenLayout;
  final Widget MobileScreenLayout;

  @override
  State<ResponsiveLayoutScreen> createState() => _ResponsiveLayoutScreenState();
}

class _ResponsiveLayoutScreenState extends State<ResponsiveLayoutScreen> {

  @override
  void initState() {
    addData();
    super.initState();
  }

  addData() async{
    UserProvider _userProvider = Provider.of(context, listen: false);
   await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(  //LayoutBuilder basically helps in creating responsive layouts
      builder: (context, constraints){
        if(constraints.maxWidth > webScreenSize )
        {
          return widget.webScreenLayout;
        }

        return widget.MobileScreenLayout;
      },
    );
  }
}
