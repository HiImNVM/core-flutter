import 'dart:math';
import 'package:example/components/loader/index.dart';
import 'package:example/constants.dart';
import 'package:example/models/index.dart';
import 'package:example/models/user.dart';
import 'package:example/screens/homeScreen/chatScreen/style.dart';
import 'package:example/utils.dart';
import 'package:flutter/material.dart';
import 'package:nvm/nvm.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChatWidget extends StatelessWidget {
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

          return ChaterWidget(
            users: users,
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
}

class ChaterWidget extends StatefulWidget {
  List<UserModel> users;

  ChaterWidget({
    this.users,
  });

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
    return Hero(
      tag: imagePath,
      transitionOnUserGestures: true,
      child: (imagePath == null || imagePath.isEmpty)
          ? CircleAvatar(
              backgroundImage: AssetImage('assets/images/user-default.png'),
            )
          : CircleAvatar(
              radius: 20,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  placeholder: (context, message) =>
                      CircularProgressIndicator(),
                  imageUrl: '$imagePath',
                ),
              ),
            ),
    );
  }

  Widget _renderNameAndMessage(String name, String message) {
    final int maxChars = 30;
    final String charsAppend = '...';

    final String currentName = (name == null || name.isEmpty)
        ? ''
        : Utils.getInstance()
            .convertShortStringWithAppendChars(maxChars, name, charsAppend);

    final String currentMessage = (message == null || message.isEmpty)
        ? (Nvm.getInstance().global as AppModel)
            .localisedValues[CONSTANT_CHATCONTENT_SCREEN_NO_MESSAGE]
        : Utils.getInstance()
            .convertShortStringWithAppendChars(maxChars, message, charsAppend);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '$currentName',
          textAlign: TextAlign.start,
          style: fullNameTextStyle,
        ),
        Text(
          '$currentMessage',
          style: messageTextStyle,
        ),
      ],
    );
  }

  Widget _renderTime(int time) {
    final String formattedTime =
        Utils.getInstance().convertMiliToTimeFormat(time, 'HH:mm');
    return Container(
      alignment: Alignment.topCenter,
      child: Text(
        '$formattedTime',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _renderUser(UserModel user, Animation<double> animation, int index) {
    return Dismissible(
      key: Key(user.id),
      background: Container(
        color: Colors.red,
      ),
      onDismissed: (dismissDirection) =>
          this._dismissed(dismissDirection, index),
      confirmDismiss: this._confirmDismiss,
      child: InkWell(
        onTap: () => this._navigateToChatScreen(user),
        child: FadeTransition(
          opacity: animation,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(flex: 0, child: this._renderAvatar(user.image)),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      flex: 1,
                      child: this._renderNameAndMessage(
                          user.fullName, user.latestMessage)),
                  Expanded(flex: 0, child: this._renderTime(user.timeSent)),
                ],
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
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
              return this._renderUser(user, animation, index);
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

  void _navigateToChatScreen(UserModel user) =>
      Navigator.pushNamed(context, '/chat', arguments: user);

  Future<bool> _confirmDismiss(_) async {
    final dynamic localisedValues =
        (Nvm.getInstance().global as AppModel).localisedValues;
    final String title =
        localisedValues[CONSTANT_CHAT_SCREEN_TITLE_ARE_YOU_SURE_TO_DELETE];
    final String strYes = localisedValues[CONSTANT_CHAT_SCREEN_TITLE_OK];
    final String strNo = localisedValues[CONSTANT_CHAT_SCREEN_TITLE_NO];

    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
            title: Text('$title'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('$strYes'),
              ),
              FlatButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('$strNo'),
              ),
            ],
          ),
    );
  }

  void _dismissed(DismissDirection dismissDirection, int indexItem) {
    // TODO: Call API to delete

    this.widget.users.removeAt(indexItem);
    this._currentUsers.removeAt(indexItem);
    this
        ._keyAnimatedUsers
        .currentState
        .removeItem(indexItem, (context, animation) => Container());
  }
}
