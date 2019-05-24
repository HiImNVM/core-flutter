import 'package:example/models/base.dart';

class UserModel implements IParser<UserModel> {
  String id;
  String image;
  String fullName;

  UserModel({
    this.fullName,
    this.image,
    this.id,
  });

  @override
  List<UserModel> parseJsonToListObjects(dynamic json) {
    return json
        .map<UserModel>((aUser) => this.parseJsonToObject(aUser))
        .toList();
  }

  @override
  UserModel parseJsonToObject(dynamic json) => UserModel(
        id: json['id'],
        fullName: json['name'],
        image: json['image'],
      );
}
