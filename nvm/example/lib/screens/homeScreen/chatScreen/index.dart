import 'dart:math';
import 'package:example/components/loader/index.dart';
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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: NvmFutureBuilder(
        loadingBuilder: (context) => Center(
              child: LoadingWidget(),
            ),
        errorBuilder: (context, errorMessage) => Center(
              child: Text('$errorMessage'),
            ),
        future: this._loadUsers(),
        successBuilder: (context, datas) {
          final List<UserModel> users = UserModel.parseJsonToListObjects(datas);

          return RefreshIndicator(
            child: ChaterWidget(
              users: users,
              key: UniqueKey(),
            ),
            onRefresh: this._refreshUsers,
          );
        },
      ),
    );
  }

  Future<dynamic> _loadUsers() async {
    return await (Nvm.getInstance().global as AppModel).request.call(
          method: MethodEnum.GET,
          url: '/users',
        );
  }

  Future<void> _refreshUsers() async =>
      await Future.delayed(Duration(seconds: 1), () => this.setState(() {}));
}

class ChaterWidget extends StatefulWidget {
  final List<UserModel> users;

  ChaterWidget({
    Key key,
    this.users,
  }) : super(key: key);

  @override
  _ChaterWidgetState createState() => _ChaterWidgetState();
}

class _ChaterWidgetState extends State<ChaterWidget> {
  final GlobalKey<AnimatedListState> _keyAnimatedUsers =
      GlobalKey<AnimatedListState>();
  final ScrollController _scrollController = ScrollController();
  List<UserModel> _currentUsers;
  final int MAX_USER = 20;

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

  Widget _renderUser(UserModel user, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: Row(
        children: <Widget>[
          Expanded(flex: 0, child: this._renderAvatar(user.image)),
          SizedBox(
            width: 10,
          ),
          Expanded(flex: 1, child: this._renderName(user.fullName)),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    this._init();
  }

  @override
  Widget build(BuildContext context) {
    return this._currentUsers.length > 0
        ? AnimatedList(
            key: this._keyAnimatedUsers,
            initialItemCount: this._currentUsers.length,
            controller: this._scrollController,
            itemBuilder: (context, index, animation) {
              final UserModel user = this._currentUsers[index];
              return this._renderUser(user, animation);
            },
          )
        : Container();
  }

  @override
  void dispose() {
    this._scrollController.removeListener(this._changePositionScroll);
    super.dispose();
  }

  void _init() {
    this._registerScroll();
    this._currentUsers = [];
    final List<UserModel> newUsers = this._caculateNewUsers();
    if (newUsers != null && newUsers.length > 0) {
      this._currentUsers = newUsers;
    }
  }

  List<UserModel> _caculateNewUsers() {
    final int currentUsersLength = this._currentUsers.length;
    final int usersLength = this.widget.users.length;

    if (currentUsersLength >= usersLength) {
      return null;
    }

    int minUsers = min(currentUsersLength + MAX_USER, usersLength);

    if (minUsers > 20) {
      minUsers = MAX_USER;
    }
    return this.widget.users.skip(currentUsersLength).take(minUsers).toList();
  }

  void _loadMoreUsers() {
    final List<UserModel> newUsers = this._caculateNewUsers();

    if (newUsers == null || newUsers.length == 0) {
      return;
    }

    newUsers.forEach((user) {
      this._currentUsers.add(user);
      this
          ._keyAnimatedUsers
          .currentState
          .insertItem(0, duration: Duration(milliseconds: 500));
    });
  }

  void _changePositionScroll() {
    if (this._scrollController.position.pixels ==
        this._scrollController.position.maxScrollExtent) {
      this._loadMoreUsers();
    }
  }

  void _registerScroll() {
    this._scrollController.addListener(this._changePositionScroll);
  }
}
