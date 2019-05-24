import 'package:example/models/index.dart';
import 'package:example/models/user.dart';
import 'package:example/screens/homeScreen/chatScreen/style.dart';
import 'package:flutter/material.dart';
import 'package:nvm/nvm.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChatWidget extends StatefulWidget {
  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  Widget _renderAvatar(String imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return CircleAvatar(
        backgroundImage: AssetImage('assets/images/user-default.png'),
      );
    }

    return CircleAvatar(
      radius: 20,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: CachedNetworkImage(
          errorWidget: (context, url, error) => Icon(Icons.error),
          placeholder: (context, message) => CircularProgressIndicator(),
          imageUrl: '$imagePath',
        ),
      ),
    );
  }

  Widget _renderName(String name) {
    final String currentName =
        (name == null || name.isEmpty) ? 'Username Default' : name;

    return Text(
      '$currentName',
      style: fullNameTextStyle,
    );
  }

  Widget _renderUser(UserModel user) {
    return Row(
      children: <Widget>[
        Expanded(flex: 0, child: this._renderAvatar(user.image)),
        SizedBox(
          width: 10,
        ),
        Expanded(flex: 1, child: this._renderName(user.fullName)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: NvmFutureBuilder(
        loadingBuilder: (context) => Center(
              child: CircularProgressIndicator(),
            ),
        errorBuilder: (context, errorMessage) => Center(
              child: Text('$errorMessage'),
            ),
        future: this._loadUsers(),
        successBuilder: (context, datas) {
          final List<UserModel> users =
              UserModel().parseJsonToListObjects(datas);

          return RefreshIndicator(
            child: ListView.separated(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final UserModel user = users[index];
                return this._renderUser(user);
              },
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 20,
                );
              },
            ),
            onRefresh: this._refreshUsers,
          );
        },
      ),
    );
  }

  Future<dynamic> _loadUsers() async {
    final dynamic response =
        await (Nvm.getInstance().global as AppModel).request.call(
              method: MethodEnum.GET,
              url: '/users',
            );

    return await Future.delayed(Duration(seconds: 2), () => response);
  }

  Future<void> _refreshUsers() async =>
      await Future.delayed(Duration(seconds: 1), () => this.setState(() {}));
}
