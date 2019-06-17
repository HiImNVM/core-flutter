import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:example/components/loader/index.dart';
import 'package:example/models/index.dart';
import 'package:example/models/message.dart';
import 'package:example/models/user.dart';
import 'package:example/screens/homeScreen/chatScreen/chatContentScreen/style.dart';
import 'package:example/utils.dart';
import 'package:flutter/material.dart';
import 'package:nvm/nvm.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../constants.dart';

class ChatContentWidget extends StatelessWidget {
  final UserModel user;
  final TextEditingController _inputController = TextEditingController();
  final FocusNode _focusInput = FocusNode();
  final List<_MediaModal> _medias = [
    _MediaModal(
      name:
          '${(Nvm.getInstance().global as AppModel).localisedValues[CONSTANT_CHATCONTENT_SCREEN_TITLE_IMAGE]}',
      description:
          '${(Nvm.getInstance().global as AppModel).localisedValues[CONSTANT_CHATCONTENT_SCREEN_DESCRIPTION_IMAGE]}',
      icon: Icon(Icons.image),
      type: ImageSource.gallery,
    ),
    _MediaModal(
      name:
          '${(Nvm.getInstance().global as AppModel).localisedValues[CONSTANT_CHATCONTENT_SCREEN_TITLE_CAMERA]}',
      description:
          '${(Nvm.getInstance().global as AppModel).localisedValues[CONSTANT_CHATCONTENT_SCREEN_DESCRIPTION_CAMERA]}',
      icon: Icon(Icons.camera),
      type: ImageSource.camera,
    ),
  ];

  ChatContentWidget({
    this.user,
  });

  Widget _renderAppBar(String nameUser, String imagePath) {
    return AppBar(
      backgroundColor: Colors.blue,
      centerTitle: true,
      title: Row(
        children: <Widget>[
          Hero(
            tag: imagePath,
            child: (imagePath == null || imagePath.isEmpty)
                ? CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/user-default.png'),
                  )
                : CircleAvatar(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: CachedNetworkImage(
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        placeholder: (context, message) =>
                            CircularProgressIndicator(),
                        imageUrl: '$imagePath',
                      ),
                    ),
                  ),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            '$nameUser',
            style: fullNameTextStyle,
          ),
        ],
      ),
    );
  }

  Widget _renderBody(context) {
    return Column(
      children: <Widget>[
        this._renderMessages(),
        SizedBox(
          height: 1,
        ),
        this._renderTextComposer(context),
      ],
    );
  }

  Widget _renderTextComposer(context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 0,
          child: this._renderChooseOtherResources(context),
        ),
        Expanded(
          flex: 1,
          child: this._renderInput(),
        ),
        Expanded(
          flex: 0,
          child: this._renderButtonSend(),
        ),
      ],
    );
  }

  Widget _renderInput() {
    final String hintTextInput = (Nvm.getInstance().global as AppModel)
        .localisedValues[CONSTANT_CHATCONTENT_SCREEN_HINTTEXT_TYPE_SOMETHING];

    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      child: TextField(
        focusNode: this._focusInput,
        controller: this._inputController,
        textInputAction: TextInputAction.done,
        maxLines: 6,
        minLines: 1,
        decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.only(left: 13, top: 5, bottom: 5, right: -5),
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                const Radius.circular(20),
              ),
            ),
            suffixIcon: Icon(Icons.insert_emoticon),
            hintText: hintTextInput),
      ),
    );
  }

  Widget _renderChooseOtherResources(context) {
    return IconButton(
      icon: Icon(Icons.add_circle),
      onPressed: () => this._showBottom(context),
      color: Colors.blue,
      iconSize: 35,
    );
  }

  Widget _renderMessages() {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: NvmFutureBuilder(
            future: this._loadMessage(),
            loadingBuilder: (context) => Center(
                  child: LoadingWidget(),
                ),
            errorBuilder: (context, error) {},
            successBuilder: (context, datas) {
              final List<MessageModel> messages =
                  MessageModel.parseJsonToListObjects(datas);

              return ListView.builder(
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) =>
                    this._renderAMessage(context, messages, index),
              );
            }),
      ),
    );
  }

  Widget _renderAvatar() {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      child: CircleAvatar(
        backgroundImage: AssetImage('assets/images/user-default.png'),
      ),
    );
  }

  Widget _renderAMessage(context, messages, index) {
    final MessageModel messageModel = messages[index];
    final bool isOwnerMessage = messageModel.isOwnerMessage;
    final String message = messageModel.message ?? '';
    final String time = messageModel.time != null
        ? Utils.getInstance()
            .convertMiliToTimeFormat(messageModel.time, 'HH:mm')
        : '00:00';
    final double marginVerticalMessage =
        (Nvm.getInstance().global as AppModel).mediaQueryData.size.width * 0.2;

    final EdgeInsets marginContainerMessage = isOwnerMessage
        ? EdgeInsets.only(
            bottom: 20,
            left: marginVerticalMessage,
          )
        : EdgeInsets.only(
            bottom: 20,
            right: marginVerticalMessage,
          );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
          isOwnerMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        isOwnerMessage ? Container() : this._renderAvatar(),
        Flexible(
          child: Container(
            margin: marginContainerMessage,
            child: Column(
              crossAxisAlignment: isOwnerMessage
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: isOwnerMessage
                      ? const EdgeInsets.only(
                          right: 10,
                        )
                      : const EdgeInsets.only(
                          left: 10,
                        ),
                  child: Text(
                    '$time',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: isOwnerMessage ? Colors.blue : Colors.grey[300],
                  ),
                  child: Text(
                    '$message',
                    style: TextStyle(
                      color: isOwnerMessage ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _renderMedias(context) {
    final double height =
        (Nvm.getInstance().global as AppModel).mediaQueryData.size.height * 0.3;
    return Container(
      height: height,
      color: Colors.blue,
      child: ListView.builder(
        itemCount: this._medias.length + 1,
        itemBuilder: (context, index) =>
            this._renderMedia(context, this._medias, index),
      ),
    );
  }

  Widget _renderContentMedia(_MediaModal currentMediaModal) {
    final String name = currentMediaModal.name;
    final String description = currentMediaModal.description;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '$name',
          style: titleMediaStyle,
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          '$description',
          style: descriptionMediaStyle,
        ),
        SizedBox(
          height: 5,
        ),
        Divider(
          color: Colors.white,
        ),
      ],
    );
  }

  Widget _renderButtonCloseBottom(context) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.bottomRight,
          child: IconButton(
            color: Colors.white,
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close),
          ),
        ),
      ],
    );
  }

  Widget _renderMedia(context, _medias, index) {
    if (index == 0) {
      return this._renderButtonCloseBottom(context);
    }

    final _MediaModal currentMediaModal = _medias[--index];

    return InkWell(
      onTap: () => this._openMediums(context, currentMediaModal.type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        margin: const EdgeInsets.only(bottom: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(flex: 0, child: currentMediaModal.icon),
            SizedBox(
              width: 15,
            ),
            Expanded(
              flex: 1,
              child: this._renderContentMedia(currentMediaModal),
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderButtonSend() {
    return IconButton(
      icon: Icon(Icons.send),
      onPressed: () {},
      color: Colors.blue,
      iconSize: 35,
    );
  }

  @override
  Widget build(BuildContext context) {
    final String imagePath = user.image;
    final String nameUser = user.fullName;

    return Scaffold(
      appBar: this._renderAppBar(nameUser, imagePath),
      body: this._renderBody(context),
    );
  }

  void _unFocusInput() {
    if (this._focusInput == null) {
      return;
    }

    this._focusInput.unfocus();
  }

  void _showBottom(context) {
    this._unFocusInput();

    showModalBottomSheet(
      context: context,
      builder: (context) => this._renderMedias(context),
    );
  }

  void _openMediums(context, ImageSource type) async {
    File file = await ImagePicker.pickImage(source: type);

    if (file == null) {
      return;
    }

    showDialog(
        context: context,
        builder: (context) {
          return Image.file(file);
        });
  }

  Future<dynamic> _loadMessage() async {
    return await (Nvm.getInstance().global as AppModel).request.call(
          method: MethodEnum.GET,
          url: '/messages',
        );
  }
}

class _MediaModal {
  _MediaModal({
    this.name,
    this.description,
    this.icon,
    this.type,
  });

  final String name;
  final String description;
  final Icon icon;
  final ImageSource type;
}
