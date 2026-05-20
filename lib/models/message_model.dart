
class MessageModel {
  final String messageId;
  final String senderId;
  final String message;
  final DateTime timestamp;

  MessageModel({
    required this.messageId,
    required this.senderId,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'senderId': senderId,
      'message': message,
      'timestamp': timestamp,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      messageId: map['messageId'] ?? '',
      senderId: map['senderId'] ?? '',
      message: map['message'] ?? '',
      timestamp: map['timestamp']?.toDate() ?? DateTime.now(),
    );
  }
}