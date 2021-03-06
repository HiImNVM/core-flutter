class UserModel {
  String id;
  String image;
  String fullName;
  String latestMessage;
  int timeSent;

  UserModel({
    this.fullName,
    this.image,
    this.id,
  });

  static List<UserModel> parseJsonToListObjects(dynamic json) => json
      .map<UserModel>((aUser) => UserModel.parseJsonToObject(aUser))
      .toList();

  UserModel.parseJsonToObject(dynamic json) {
    this.id = json['id'];
    this.fullName = json['name'];
    this.image = json['image'];
    this.latestMessage = json['latestMessage'];
    this.timeSent = json['timeSent'];
  }
}
