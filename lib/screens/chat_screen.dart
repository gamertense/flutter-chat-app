import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      padding: const EdgeInsets.all(20.0),
      children: const <Widget>[
        Text("I'm dedicating every day to you"),
        Text('Domestic life was never quite my style'),
        Text('When you smile, you knock me out, I fall apart'),
        Text('And I thought I was so smart'),
      ],
    ));
  }
}
