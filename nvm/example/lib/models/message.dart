class MessageModel {
  String id;
  String message;
  int time;
  bool isOwnerMessage;

  MessageModel({
    this.id,
    this.isOwnerMessage,
    this.message,
    this.time,
  });

  static List<MessageModel> parseJsonToListObjects(dynamic json) => json
      .map<MessageModel>((aMessage) => MessageModel.parseJsonToObject(aMessage))
      .toList();

  MessageModel.parseJsonToObject(dynamic json) {
    this.id = json['id'];
    this.message = json['message'];
    this.time = json['time'];
    this.isOwnerMessage = json['isOwnerMessage'];
  }
}
