// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:eduquality/app_pref.dart';
import 'package:eduquality/constants.dart';
import 'package:eduquality/models/user.dart' as model;
import 'package:eduquality/views/widgets/screens/auth/login_screen.dart';
import 'package:eduquality/views/widgets/screens/home_screen.dart';
import 'package:crypto/crypto.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  Rx<File> pickedImage = File("").obs;

  File? get profilePhoto => pickedImage.value;
  User get user => FirebaseAuth.instance.currentUser!;

  @override
  void onReady() {
    super.onReady();
    // _user = Rx<User?>(firebaseAuth.currentUser);
    // _user.bindStream(firebaseAuth.authStateChanges());
    // ever(_user, _setInitialScreen);

    //Used manual check instead of stream check so that the auth state works when we are complete with process
    _setInitialScreen();
  }

  _setInitialScreen() {
    if (FirebaseAuth.instance.currentUser == null) {
      Get.offAll(() => LoginScreen());
    } else {
      Get.offAll(() => const HomeScreen());
    }
  }

  void pickImage() async {
    final pickedImage2 =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage2 != null) {
      Get.snackbar('Profile Picture',
          'You have successfully selected your profile picture');
    }
    pickedImage = Rx<File>(File(pickedImage2!.path));
    update();
  }

  // upload to firebase storage
  Future<String> uploadToStorage(File image) async {
    TaskSnapshot snapshot = await firebaseStorage
        .ref()
        .child("images/${firebaseAuth.currentUser!.uid}.jpg")
        .putFile(image);
    String downloadUrl = "";
    if (snapshot.state == TaskState.success) {
      downloadUrl = await snapshot.ref.getDownloadURL();
    }
    return downloadUrl;
  }

  //registering the user
  void registerUser(
      String username, String email, String password, File? image) async {
    try {
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          image != null) {
        //save out user to our auth and firebase firestore
        UserCredential cred = await firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);
        String downloadUrl = "";
        try {
          downloadUrl = await uploadToStorage(image);
        } catch (e) {
          downloadUrl = "error";
          print(e);
        }
        model.User user = model.User(
            name: username,
            email: email,
            uid: cred.user!.uid,
            profilePhoto: downloadUrl,
            role: 1);
        cred.user!.uid.printInfo();
        setPrefValue("Role", "1");

        // Updated This are and directly used the firebase firestore instance
        await FirebaseFirestore.instance
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());
        _setInitialScreen();
      } else {
        Get.snackbar(
          'Error Creating Account',
          'Please enter all the fields',
        );
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Error Creating Account',
        e.message.toString(),
      );
    }
  }

  getUserData() async {
    DocumentSnapshot userDoc = await firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    final userData = userDoc.data() ?? {} as dynamic;
    int role1 = userData['role'] ?? 1;
    await setPrefValue("Role", role1.toString());
  }

  void loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        await getUserData();
        print('log success');
        _setInitialScreen();
      } else {
        Get.snackbar(
          'Error Logging in',
          'Please enter all the fields',
        );
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Error Creating Account',
        e.message.toString(),
      );
    }
  }

  Future signInWithGoogle() async {
    try {
      Get.dialog(Container(
        color: Colors.grey.withOpacity(0.2),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ));
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential cred = await FirebaseAuth.instance.signInWithCredential(credential);
      if (cred.user != null) {
        model.User user = model.User(
            name: cred.user!.displayName ?? "",
            email: cred.user!.email ?? "",
            uid: cred.user!.uid,
            profilePhoto: cred.user!.photoURL ?? "",
            role: 1);
        cred.user!.uid.printInfo();
        setPrefValue("Role", "1");

        // Updated This are and directly used the firebase firestore instance
        await FirebaseFirestore.instance
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());
        _setInitialScreen();
      }
    }
    on FirebaseAuthException catch (e) {
      Get.back();
      Get.snackbar(
        'Error In Social Login',
        e.message.toString(),
      );
      print('prash : ${e.message}');
    } catch (e) {
      Get.back();
      print('prash1 : ${e.toString()}');
      Get.snackbar(
        'Error In Social Login',
        e.toString(),
      );
    }
  }

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.

    try {
      Get.dialog(Container(
        color: Colors.grey.withOpacity(0.2),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ));
      // Trigger the authentication flow
      // final AuthorizationCredentialAppleID appleCredential =
      //     await SignInWithApple.getAppleIDCredential(
      //   scopes: [
      //     AppleIDAuthorizationScopes.email,
      //     AppleIDAuthorizationScopes.fullName,
      //   ],
      // webAuthenticationOptions: WebAuthenticationOptions(
      //   clientId: 'L6X9W624KJ',
      //   redirectUri: Uri.parse(
      //       'https://eduquality-49b2d.firebaseapp.com/auth/handler'),
      // ),
      //   nonce: 'yourNonce',
      // );
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'com.mhsinnovations.eduquality.android',
          redirectUri: Uri.parse(
              'https://eduquality-49b2d.firebaseapp.com/__/auth/handler'),
        ),
      );

      // Create an `OAuthCredential` from the credential returned by Apple.
      final credential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // final OAuthProvider oAuthProvider = OAuthProvider('apple.com');
      // final OAuthCredential credential = oAuthProvider.credential(
      //     idToken: appleCredential.identityToken,
      //     accessToken: appleCredential.authorizationCode,
      //     rawNonce: 'yourNonce');

      final UserCredential cred =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (cred.user != null) {
        model.User user = model.User(
            name: cred.user!.displayName ?? "",
            email: cred.user!.email ?? "",
            uid: cred.user!.uid,
            profilePhoto: cred.user!.photoURL ?? "",
            role: 1);
        cred.user!.uid.printInfo();
        setPrefValue("Role", "1");

        // Updated This are and directly used the firebase firestore instance
        await FirebaseFirestore.instance
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());
        _setInitialScreen();
      }
    } on FirebaseAuthException catch (e) {
      Get.back();
      Get.snackbar(
        'Error In Social Login',
        e.message.toString(),
      );
    } catch (e) {
      print(e);
      Get.back();
      Get.snackbar(
        'Error In Social Login',
        e.toString(),
      );
    }
  }

  void signOut() async {
    await firebaseAuth.signOut();
    _setInitialScreen();
  }
}
