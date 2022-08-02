import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/responsive/responsive_layout_screen.dart';
import 'package:instagram_clone/responsive/web_screen_layout.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';
class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  Uint8List? _image;
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _userNameController.dispose();
    super.dispose();
  }

  void selectImage() async{
   Uint8List im = await pickImage(ImageSource.gallery);
   setState(() {
     _image = im; 
    
   });
  }

  void signUpUser() async {
    setState(() {
      isLoading = true;
    });
     String res = await AuthMethods().
     signUpTheUser(email: _emailController.text, 
     userName: _userNameController.text, 
     password: _passwordController.text, 
     bio: _bioController.text, 
     file: _image!);
    print('****$res');

    if(res != 'Success!'){
      showSnackBar(res, context);

      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> const ResponsiveLayoutScreen(MobileScreenLayout: MobileScreenLayout(),webScreenLayout: WebScreenLayout(),)));
    }

    setState(() {
      isLoading = false;
    });
  }

  void navigateToLogin(){
      
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const LoginScreen()));
  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
         
          child:Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(child: Container(), flex: 1,),
                SvgPicture.asset('assets/sample.svg', color: primaryColor, height: 64,),
                const SizedBox(height: 08,),
                Stack(
                  children: [
                    _image != null ? 
                     CircleAvatar(
                      radius: 64,
                      backgroundImage: MemoryImage(_image!),
                    ):
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/dp.jpg'),
                    ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(onPressed:selectImage, icon: const Icon(Icons.add_a_photo))),
                  ],
                ),
                const SizedBox(height: 18,),
                TextFieldInput(textEditingController: _userNameController, hintText: "Enter your username...", textInputType: TextInputType.text,),
                const SizedBox(height: 18,),
                TextFieldInput(textEditingController: _emailController, hintText: "Enter your email address...", textInputType: TextInputType.emailAddress),
                const SizedBox(height: 18,),
                TextFieldInput(textEditingController: _passwordController, hintText: "Enter your password...", textInputType: TextInputType.text, isPassword: true,),
                const SizedBox(height: 18,),
                TextFieldInput(textEditingController: _bioController, hintText: "Enter your bio...", textInputType: TextInputType.text,),
                const SizedBox(height: 18,),
                InkWell(
                  onTap: signUpUser,
                  child: Container(
                    child: isLoading? const Center(child: CircularProgressIndicator(color: primaryColor,),) : const Text("Sign Up"),
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                      color: blueColor,
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    )),
                    
                  ),
                ),
                const SizedBox(height: 10,),
                Flexible(child: Container(), flex: 1,),
          
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: const Text("Already have an account?"),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
          
                    GestureDetector(
                      onTap: navigateToLogin,
                      child: Container(
                        child: const Text("Log in", style: TextStyle(fontWeight: FontWeight.bold),),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ],
                )
              ],
            ),
        
          ),
        ),
    );
  }
}