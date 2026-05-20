import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/message_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String getChatRoomId(String otherUserId) {
    List<String> users = [_auth.currentUser!.uid, otherUserId];
    users.sort();
    return users.join('_');
  }

  Future<void> sendMessage(String otherUserId, String message) async {
   try{
     String chatRoomId = getChatRoomId(otherUserId);
     MessageModel newMessage = MessageModel(
       messageId: _firestore.collection('chats').doc().id,
       senderId: _auth.currentUser!.uid,
       message: message,
       timestamp: DateTime.now(),
     );
     await _firestore
         .collection('chats')
         .doc(chatRoomId)
         .collection('messages')
         .doc(newMessage.messageId)
         .set(newMessage.toMap());
   }
   catch(e){
     throw Exception('Message send failed: $e');
   }
  }

  Stream<List<MessageModel>> getMessages(String otherUserId) {
    String chatRoomId = getChatRoomId(otherUserId);
    return _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => MessageModel.fromMap(
      doc.data() as Map<String, dynamic>,
    ))
        .toList());
  }
}
