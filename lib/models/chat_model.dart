class ChatModel{
  String message;
  String time;
  bool isMe;


  ChatModel({required this.isMe,required this.message,required this.time});
  // Convert ChatModel instance to a JSON-serializable map
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'time': time,
      'isMe': isMe,
    };
  }

  // Create a ChatModel instance from a JSON map
  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      message: json['message'],
      time: json['time'],
      isMe: json['isMe'],
    );
  }
}