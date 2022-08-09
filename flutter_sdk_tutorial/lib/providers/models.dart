//  Class to represent a message object, used to display messages
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
