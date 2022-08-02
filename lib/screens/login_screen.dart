import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/screens/sign_up.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void loginUser() async{
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethods().loginTheUser(email: _emailController.text, password: _passwordController.text);

    if(res == 'Success!'){

    }
    else{
      showSnackBar(res, context);
    }
    setState(() {
      isLoading = false;
    });
  }

  void navigateToSignUp(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const SignUp()));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: Container(), flex: 2,),
              SvgPicture.asset('assets/sample.svg', color: primaryColor, height: 64,),
              const SizedBox(height: 64,),
              TextFieldInput(textEditingController: _emailController, hintText: "Enter your email address...", textInputType: TextInputType.emailAddress),
              const SizedBox(height: 24,),
              TextFieldInput(textEditingController: _passwordController, hintText: "Enter your password...", textInputType: TextInputType.text, isPassword: true,),
              const SizedBox(height: 24,),
              InkWell(
                onTap: loginUser,
                child: Container(
                  child:  isLoading? const Center(child: CircularProgressIndicator(color: primaryColor,),) :const Text("Log In"),
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
              const SizedBox(height: 12,),
              Flexible(child: Container(), flex: 2,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: const Text("Don\'t have an account?"),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),

                  GestureDetector(
                    onTap: navigateToSignUp,
                    child: Container(
                      child: const Text("Sign Up", style: TextStyle(fontWeight: FontWeight.bold),),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ],
              )
            ],
          ),
          )
        ),
    );
  }
}