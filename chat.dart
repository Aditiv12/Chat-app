import 'package:chatapp/widgets/chat_msg.dart';
import 'package:chatapp/widgets/new_msg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void setupPushNotif() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    //sending notif to individual device using token
    //final token = await fcm.getToken();
    //print(token);

    //sending notif to all devices using topic
    fcm.subscribeToTopic('chat');
  }

  @override
  void initState() {
    super.initState();
    setupPushNotif();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('FlutterChat'),
          actions: [
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: Icon(Icons.exit_to_app,
                    color: Theme.of(context).colorScheme.primary))
          ],
        ),
        body: const Column(
          children: [
            Expanded(
              child: ChatMsg(),
            ),
            NewMsg(),
          ],
        ));
  }
}
