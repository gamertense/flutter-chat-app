import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final messagesStream = FirebaseFirestore.instance
        .collection('chats')
        .doc('uYX0Ex0Ng81hwDjcjvO0')
        .collection('messages')
        .snapshots();

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
                  child: Container(
                    child: Row(
                      children: const <Widget>[
                        Icon(Icons.exit_to_app),
                        SizedBox(width: 8),
                        Text('Logout'),
                      ],
                    ),
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
        body: StreamBuilder<QuerySnapshot>(
            stream: messagesStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView(
                children: snapshot.data!.docs
                    .map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;

                      return ListTile(
                        title: Text(data['text']),
                        // subtitle: Text(data['company']),
                      );
                    })
                    .toList()
                    .cast(),
              );
            }));
  }
}
