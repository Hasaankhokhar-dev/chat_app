import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../controller/chat_controller.dart';
import '../../models/message_model.dart';
import '../../models/userModel.dart';
import 'widgets/message_bubble.dart';
import 'widgets/message_input.dart';

class ChatScreen extends StatelessWidget {
  final UserModel otherUser;

  const ChatScreen({super.key, required this.otherUser});

  @override
  Widget build(BuildContext context) {
    final ChatController controller = Get.put(ChatController());
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey[300],
              backgroundImage: otherUser.photoUrl.isNotEmpty
                  ? NetworkImage(otherUser.photoUrl)
                  : null,
              child: otherUser.photoUrl.isEmpty
                  ? const Icon(Icons.person, size: 18)
                  : null,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(otherUser.name, style: const TextStyle(fontSize: 16)),
                Text(
                  otherUser.isOnline ? 'Online' : 'Offline',
                  style: TextStyle(
                    fontSize: 12,
                    color: otherUser.isOnline ? Colors.green : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream: controller.getMessages(otherUser.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No messages yet. Say Hi! 👋'));
                }

                final messages = snapshot.data!;

                return ListView.builder(
                  controller: controller.scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message.senderId == currentUserId;

                    return MessageBubble(
                      message: message,
                      isMe: isMe,
                    );
                  },
                );
              },
            ),
          ),
          MessageInput(
            controller: controller,
            otherUserId: otherUser.uid,
          ),
        ],
      ),
    );
  }
}
