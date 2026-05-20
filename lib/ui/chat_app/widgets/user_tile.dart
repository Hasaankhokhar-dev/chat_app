import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app_with_firebase/models/userModel.dart';
import '../chat_screen.dart';

class UserTile extends StatelessWidget {
  final UserModel user;
  final String? lastMessage;
  final DateTime? lastMessageTime;

  const UserTile({
    super.key,
    required this.user,
    this.lastMessage,
    this.lastMessageTime
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => ChatScreen(otherUser: user)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Row(
          children: [
            // Profile Image with Online Indicator
            Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: user.isOnline ? Colors.green : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: user.photoUrl.isNotEmpty
                        ? NetworkImage(user.photoUrl)
                        : null,
                    child: user.photoUrl.isEmpty
                        ? const Icon(Icons.person, size: 30, color: Colors.grey)
                        : null,
                  ),
                ),
                if (user.isOnline)
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),

            // Name and Last Message
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lastMessage ?? 'Say Hi! 👋',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Time
            if (lastMessageTime != null)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  _formatTime(lastMessageTime!),
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final hour = time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    final amPm = time.hour >= 12 ? 'PM' : 'AM';
    final minute = time.minute.toString().padLeft(2, '0');

    if (now.day == time.day && now.month == time.month && now.year == time.year) {
      return '$hour:$minute $amPm'; // Aaj ka time
    } else {
      return '${time.day}/${time.month}'; // Purani date
    }
  }
}