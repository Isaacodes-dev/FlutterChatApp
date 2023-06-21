import 'package:chapapp/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:chapapp/components/myButton.dart';
import 'package:chapapp/components/my_text_field.dart';
import 'package:provider/provider.dart';


class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
   //text controller
 final emailController = TextEditingController();
 final passwordController = TextEditingController();
 final confirmPasswordController = TextEditingController();
  void signUp() async{
    if(passwordController.text != confirmPasswordController.text){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords dont match!')
        )
      );
      return;
    }
    //get auth service
    final authService = Provider.of<AuthService>(context, listen: false);
    try{
      await authService.signUpWithEmailandPassword
      (emailController.text, passwordController.text);
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          )
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
                const SizedBox(height:5),
                //Logo
                Icon(
                  Icons.message,
                  size: 100,
                  color: Colors.grey[800],
                ),
                const SizedBox(height:10),
                //Welcome back
                const Text(
                  "Let's create an account for you!",
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
                
                 const SizedBox(height:10),

                //confirm password
                MyTextField(controller: confirmPasswordController, hintText: "Confirm Password", obscureText: true),

                //sign in button
                  const SizedBox(height:25),
                  MyButton(onTap: signUp, text: 'Sign Up'),
                
                //not a member? register now
                const SizedBox(height:25),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already a member?'),
                    const SizedBox(width: 4,),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text('Login Now',
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