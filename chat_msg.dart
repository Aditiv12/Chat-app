import 'package:chatapp/widgets/msg_bubble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatMsg extends StatelessWidget {
  const ChatMsg({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (ctx, chatSnapshots) {
          if (chatSnapshots.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
            return const Center(
              child: Text('No messages found'),
            );
          }
          if (chatSnapshots.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }

          final loadedMessages = chatSnapshots.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 40, left: 15, right: 15),
            reverse: true,
            itemCount: loadedMessages.length,
            itemBuilder: (ctx, index) {
              final chatMsg = loadedMessages[index].data();
              final nextChatMsg = index + 1 < loadedMessages.length
                  ? loadedMessages[index + 1].data()
                  : null;
              final currentMsgUserId = chatMsg['userId'];
              final nextMsgUserId =
                  nextChatMsg != null ? nextChatMsg['userId'] : null;
              final nextMsgUserSame = nextMsgUserId == currentMsgUserId;

              if (nextMsgUserSame) {
                return MsgBubble.next(
                    message: chatMsg['text'],
                    isMe: authenticatedUser.uid == currentMsgUserId);
              } else {
                return MsgBubble.first(
                    userImage: chatMsg['userImage'],
                    username: chatMsg['username'],
                    message: chatMsg['text'],
                    isMe: authenticatedUser.uid == currentMsgUserId);
              }
            },
          );
        });
  }
}
