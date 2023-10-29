import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eduquality/constants.dart';
import 'package:eduquality/views/widgets/text_input_field.dart';

import 'login_screen.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({Key? key}) : super(key: key);


  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Container(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        reverse: true,
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
              'Register',
              style: TextStyle(
                fontSize: 25.0, 
                fontWeight: FontWeight.w700
                ),
            ),
            const SizedBox(
              height: 25.0,
            ),
            // REMOVE PROFILE PICTURE FROM REGISTER SCREEN
            /*Stack(
              children: [
                Obx(() => authController.pickedImage.value.path != ""
                    ? CircleAvatar(
                        radius: 64,
                        backgroundColor: Colors.black,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(64),
                            child: Image.file(authController.pickedImage.value)),
                      )
                    : const CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                            'https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg'),
                        backgroundColor: Colors.black,
                      )),
                Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                    onPressed: () => authController.pickImage(),
                    icon: const Icon(
                      Icons.add_a_photo,
                    ),
                  ),
                ),
              ],
            ),*/
            const SizedBox(
              height: 15.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextInputField(
                controller: _usernameController,
                labelText: 'Username',
                icon: Icons.person,
              ),
            ),
            const SizedBox(
              height: 15.0,
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
              height: 15.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextInputField(
                controller: _passwordController,
                labelText: 'Password',
                icon: Icons.lock,
                isObscure : true,
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width-40,
              height: 50,
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: InkWell(
                onTap: () {
                  authController.registerUser(
                    _usernameController.text,
                    _emailController.text,
                    _passwordController.text,
                    authController.profilePhoto,
                  );
                  // authController
                  //     .uploadToStorage(File(authController.profilePhoto!.path));
                },
                // onTap: () => authController.registerUser(
                //   _usernameController.text,
                //   _emailController.text,
                //   _passwordController.text,
                //   authController.profilePhoto,
                // ),
                child: const Center(
                  child: Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 20.0, 
                      fontWeight: FontWeight.w700
                      ),
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
                  'Already have an account? ',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 20, 
                      color: buttonColor
                      ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    )
    );
  }
}
