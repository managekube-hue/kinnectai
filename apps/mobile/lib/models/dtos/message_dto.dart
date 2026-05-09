class MessageDTO {
  const MessageDTO({
    required this.id,
    required this.threadId,
    required this.senderId,
    required this.recipientId,
    required this.ciphertext,
    required this.sentAt,
    this.isDelivered = false,
    this.isRead = false,
  });

  final String id;
  final String threadId;
  final String senderId;
  final String recipientId;
  final String ciphertext;
  final DateTime sentAt;
  final bool isDelivered;
  final bool isRead;

  MessageDTO copyWith({
    String? id,
    String? threadId,
    String? senderId,
    String? recipientId,
    String? ciphertext,
    DateTime? sentAt,
    bool? isDelivered,
    bool? isRead,
  }) {
    return MessageDTO(
      id: id ?? this.id,
      threadId: threadId ?? this.threadId,
      senderId: senderId ?? this.senderId,
      recipientId: recipientId ?? this.recipientId,
      ciphertext: ciphertext ?? this.ciphertext,
      sentAt: sentAt ?? this.sentAt,
      isDelivered: isDelivered ?? this.isDelivered,
      isRead: isRead ?? this.isRead,
    );
  }
}
