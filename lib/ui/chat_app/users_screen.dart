import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:notes_app_with_firebase/controller/auth_controller.dart';
import 'package:notes_app_with_firebase/models/userModel.dart';
import 'widgets/user_tile.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Messages',
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          GetBuilder<AuthController>(
            builder: (controller) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  icon: const Icon(Icons.logout_rounded, color: Colors.black87, size: 28),
                  onPressed: () => controller.logout(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Elegant Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(25),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search chats...',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Colors.grey),
                ),
              ),
            ),
          ),
          
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.blue));
                }

                if (!userSnapshot.hasData) return const SizedBox();

                // Stream for chat rooms to get sorting metadata
                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('chats')
                      .where('participants', arrayContains: currentUserId)
                      .snapshots(),
                  builder: (context, chatSnapshot) {
                    
                    List<UserModel> users = userSnapshot.data!.docs
                        .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
                        .where((u) => u.uid != currentUserId)
                        .toList();

                    // Map to store chat metadata for each user
                    Map<String, dynamic> chatMetadata = {};
                    if (chatSnapshot.hasData) {
                      for (var doc in chatSnapshot.data!.docs) {
                        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                        List participants = data['participants'] ?? [];
                        String otherId = participants.firstWhere(
                          (id) => id != currentUserId, 
                          orElse: () => '',
                        );
                        if (otherId.isNotEmpty) {
                          chatMetadata[otherId] = {
                            'lastMessage': data['lastMessage'] ?? '',
                            'timestamp': data['lastMessageTimestamp'] as Timestamp?,
                          };
                        }
                      }
                    }

                    // ⚡ Sorting Logic: Users with latest messages at the top
                    users.sort((a, b) {
                      Timestamp? timeA = chatMetadata[a.uid]?['timestamp'];
                      Timestamp? timeB = chatMetadata[b.uid]?['timestamp'];
                      
                      if (timeA == null && timeB == null) return 0;
                      if (timeA == null) return 1;
                      if (timeB == null) return -1;
                      
                      return timeB.compareTo(timeA);
                    });

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        final metadata = chatMetadata[user.uid];
                        
                        return UserTile(
                          user: user, 
                          lastMessage: metadata?['lastMessage'],
                          lastMessageTime: (metadata?['timestamp'] as Timestamp?)?.toDate(),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
