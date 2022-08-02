
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/responsive/responsive_layout_screen.dart';
import 'package:instagram_clone/responsive/web_screen_layout.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/screens/sign_up.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(options: const FirebaseOptions(apiKey: "AIzaSyDhyl0Zjkh-RAVTtTE5fRXVZm2dqAmRh_U", appId: "1:399055603353:web:6e621824024450d37f9a08", messagingSenderId: "399055603353", projectId: "instagram-clone-3ecd5", storageBucket: "instagram-clone-3ecd5.appspot.com"));
  }
  else{
    await Firebase.initializeApp();
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Instagram Clone',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor, 
        ),
        //home: 
         home: StreamBuilder(
           stream: FirebaseAuth.instance.authStateChanges(),
           builder: (context, snapshot){
             
             if(snapshot.connectionState == ConnectionState.active){
               if(snapshot.hasData){
                 return const ResponsiveLayoutScreen(MobileScreenLayout: MobileScreenLayout(),webScreenLayout: WebScreenLayout(),);
               }
               else if(snapshot.hasError){
                 return  Center(
                   child: Text('${snapshot.error}'),
                 );
               }
               
             }
             if(snapshot.connectionState == ConnectionState.waiting){
               return const Center(
                 child: CircularProgressIndicator(
                   color: primaryColor,
                 ),
               );
             }
            return const LoginScreen();
           },)
         
        //home: SignUp(),
      ),
    );
  }
}