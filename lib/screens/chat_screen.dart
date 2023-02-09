import 'dart:developer';

import 'package:chat_app/widgets/chat/messages.dart';
import 'package:chat_app/widgets/chat/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Chat'),
          actions: [
            DropdownButton(
              underline: Container(),
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).primaryIconTheme.color,
              ),
              items: [
                DropdownMenuItem(
                  value: 'logout',
                  child: Row(
                    children: const <Widget>[
                      Icon(Icons.exit_to_app),
                      SizedBox(width: 8),
                      Text('Logout'),
                    ],
                  ),
                ),
              ],
              onChanged: (itemIdentifier) {
                if (itemIdentifier == 'logout') {
                  FirebaseAuth.instance.signOut();
                }
              },
            ),
          ],
        ),
        body: Column(
          children: const [
            Expanded(
              child: Messages(),
            ),
            NewMessage(),
          ],
        ));
  }

  @override
  void initState() {
    super.initState();

    final messaging = FirebaseMessaging.instance;
    messaging.requestPermission();

    FirebaseMessaging.onMessage.listen((message) {
      log(
          message.notification?.toMap().toString() ??
              "Can't convert notification message to map",
          name: "FirebaseMessaging.onMessage.listen");
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      log(
          message.notification?.toMap().toString() ??
              "Can't convert notification message to map",
          name: "FirebaseMessaging.onMessageOpenedApp.listen");
    });
  }
}
