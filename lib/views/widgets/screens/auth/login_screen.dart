import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:eduquality/constants.dart';
import 'package:eduquality/views/widgets/text_input_field.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import 'singup_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'eduquality',
            style: TextStyle(
              fontSize: 35.0,
              color: buttonColor,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Text(
            'login',
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 25.0,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: TextInputField(
              controller: _emailController,
              labelText: 'Email',
              icon: Icons.email,
            ),
          ),
          const SizedBox(
            height: 25.0,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: TextInputField(
              controller: _passwordController,
              labelText: 'Password',
              icon: Icons.lock,
              isObscure: true,
            ),
          ),
          const SizedBox(
            height: 30.0,
          ),
          Container(
            width: MediaQuery.of(context).size.width - 40,
            height: 50,
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            child: InkWell(
              onTap: () => authController.loginUser(
                  _emailController.text, _passwordController.text),
              child: const Center(
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Don\'t have an account? ',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SignupScreen(),
                  ),
                ),
                child: Text(
                  'Register',
                  style: TextStyle(fontSize: 20, color: buttonColor),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'OR',
            style: TextStyle(fontSize: 20, color: buttonColor),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // LOTS OF CODE TO CENTER THE Google ICON IN A CIRCLE BOARDER
              Container(
                width: 60, // Adjust the width and height as needed for the desired size
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white, // Change the color of the border as needed
                    width: 2.0, // Change the width of the border as needed
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        FontAwesome.google,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30.0),
                          onTap: () {
                            authController.signInWithGoogle();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),


              //CODE TO CENTER LOGIN WITH APPLE ICON IN A CIRCLE
              if (Platform.isIOS) ...[
                const SizedBox(
                  width: 30,
                ),
                Container(
                  width: 60, // Adjust the width and height as needed for the desired size
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white, // Change the color of the border as needed
                      width: 2.0, // Change the width of the border as needed
                    ),
                  ),
                  child: IconButton(
                    onPressed: () {
                      authController.signInWithApple();
                    },
                    icon: const Icon(
                      FontAwesome.apple,
                      size: 40,
                    ),
                  ),
                ),
              ],

            ],
          ),const SizedBox(
            height: 20,
          ),
          Text(
            'OR',
            style: TextStyle(fontSize: 20, color: buttonColor),
          ),const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Login with limited function as ',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              InkWell(
                onTap: () => authController.loginUser(
                    "guest@mhs-innovations.com", "mhsguest"),
                child: const Center(
                  child: Text(
                    'Guest',
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
