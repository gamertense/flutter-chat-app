import 'dart:developer';
import 'dart:io';

import 'package:chat_app/widgets/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        _submitAuthForm,
        _isLoading,
      ),
    );
  }

  void _submitAuthForm(
    String email,
    String password,
    String username,
    bool isLogin,
    File? userImageFile,
    BuildContext ctx,
  ) async {
    UserCredential authResult;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        return;
      }

      authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child('${authResult.user?.uid}.jpg');
      await storageRef.putFile(userImageFile!);

      final imageUrl = await storageRef.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(authResult.user?.uid)
          .set({'username': username, 'email': email, 'image_url': imageUrl});
    } on FirebaseAuthException catch (e) {
      var message = 'An error occurred, pelase check your credentials!';

      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      } else if (e.message != null) {
        message = e.message!;
      }

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).colorScheme.error,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      log(err.toString(), name: '_submitAuthForm');

      setState(() {
        _isLoading = false;
      });
    }
  }
}
