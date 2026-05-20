import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/message_model.dart';
import '../services/chat_service.dart';

class ChatController extends GetxController {
  final ChatService _chatService = ChatService();

  final TextEditingController messageController = TextEditingController();

  final ScrollController scrollController = ScrollController();

  bool isLoading = false;

  Future<void> sendMessage(String otherUserId) async {
    if (messageController.text.trim().isEmpty) return;

    try {
      isLoading = true;
      update();

      await _chatService.sendMessage(
        otherUserId,
        messageController.text.trim(),
      );
      messageController.clear();
      _scrollToBottom();

    } catch (e) {
      Get.snackbar('Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading = false;
      update();
    }
  }
  Stream<List<MessageModel>> getMessages(String otherUserId) {
    return _chatService.getMessages(otherUserId);
  }
  void _scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}