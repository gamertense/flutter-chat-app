import 'package:chat_app/widgets/chat/message_buble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final messagesStream = FirebaseFirestore.instance
        .collection('chat')
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots();

    return StreamBuilder(
      stream: messagesStream,
      builder: (ctx, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = chatSnapshot.data!.docs;

        return ListView.builder(
            reverse: true,
            itemCount: chatDocs.length,
            itemBuilder: (ctx, index) {
              Map<String, dynamic> data =
                  chatDocs[index].data() as Map<String, dynamic>;

              return MessageBubble(data['text'], data['username'], 'userImage',
                  data['userId'] == user?.uid);
            });
      },
    );
  }
}
