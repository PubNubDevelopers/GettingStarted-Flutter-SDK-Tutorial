class ChatMessage {
  final String timetoken;
  final String channel;
  final String uuid;
  final String message;

  ChatMessage(
      {required this.timetoken,
      required this.channel,
      required this.uuid,
      required this.message});
}
