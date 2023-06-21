import 'package:chapapp/auth_service.dart';
import 'package:chapapp/components/myButton.dart';
import 'package:chapapp/components/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key,
  required this.onTap,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
 //text controller
 final emailController = TextEditingController();
 final passwordController = TextEditingController();

 void signIn() async{
  final authService = Provider.of<AuthService>(context, listen: false);
  try{
    await authService.signInWithEmailandPassword(emailController.text, passwordController.text); 
  }
  catch(ex){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ex.toString(),
        ),
        ),
    );
  }
 }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height:50),
                //Logo
                Icon(
                  Icons.message,
                  size: 100,
                  color: Colors.grey[800],
                ),
                const SizedBox(height:50),
                //Welcome back
                const Text(
                  "Welcome back You have been Missed!",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height:25),
                //emailTextfield
                MyTextField(controller: emailController, hintText: "Email", obscureText: false),
                
                const SizedBox(height:10),

                //passwordTextfield
                MyTextField(controller: passwordController, hintText: "Password", obscureText: true),
                //sign in button
                  const SizedBox(height:25),
                  MyButton(onTap: signIn, text: 'Sign In'),
                //not a member? register now
                const SizedBox(height:50),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Not a member?'),
                    const SizedBox(width: 4,),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text('Register Now',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                    ),
                ],
                
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}