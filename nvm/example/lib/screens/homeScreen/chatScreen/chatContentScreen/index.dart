import 'package:cached_network_image/cached_network_image.dart';
import 'package:example/models/index.dart';
import 'package:example/models/user.dart';
import 'package:example/screens/homeScreen/chatScreen/chatContentScreen/style.dart';
import 'package:flutter/material.dart';
import 'package:nvm/nvm.dart';

import '../../../../constants.dart';

class ChatContentWidget extends StatelessWidget {
  final UserModel user;
  final GlobalKey<ScaffoldState> _keyScaffold = GlobalKey<ScaffoldState>();
  final TextEditingController _inputController = TextEditingController();
  final FocusNode _focusInput = FocusNode();

  ChatContentWidget({
    this.user,
  });

  Widget _renderAppBar(String nameUser, String imagePath) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: false,
      title: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Text(
          '$nameUser',
          style: fullNameTextStyle,
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 5, bottom: 5),
        child: Hero(
          tag: imagePath,
          child: (imagePath == null || imagePath.isEmpty)
              ? CircleAvatar(
                  backgroundImage: AssetImage('assets/images/user-default.png'),
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
      ),
    );
  }

  Widget _renderBody() {
    return SafeArea(
      child: Column(
        children: <Widget>[
          this._renderMessage(),
          SizedBox(
            height: 1,
          ),
          this._renderTextComposer(),
        ],
      ),
    );
  }

  Widget _renderTextComposer() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          flex: 0,
          child: this._renderChooseOtherResources(),
        ),
        Expanded(
          flex: 1,
          child: this._renderInput(),
        ),
        Expanded(
          flex: 0,
          child: this._renderChooseOtherResources(),
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

  Widget _renderChooseOtherResources() {
    return IconButton(
      icon: Icon(Icons.add_circle),
      onPressed: this._showBottom,
      color: Colors.blue,
      iconSize: 35,
    );
  }

  Widget _renderMessage() {
    return Flexible(
      child: ListView.builder(
        itemCount: 0,
        itemBuilder: (context, index) => Container(),
      ),
    );
  }

  Widget _renderMedias(context) {
    final AppModel appModal = (Nvm.getInstance().global as AppModel);

    final double height = appModal.mediaQueryData.size.height * 0.4;

    final List<_MediaModal> _medias = [
      _MediaModal(
        name:
            '${appModal.localisedValues[CONSTANT_CHATCONTENT_SCREEN_TITLE_IMAGE]}',
        description:
            '${appModal.localisedValues[CONSTANT_CHATCONTENT_SCREEN_DESCRIPTION_IMAGE]}',
        image: 'assets/images/image.png',
      ),
      _MediaModal(
        name:
            '${appModal.localisedValues[CONSTANT_CHATCONTENT_SCREEN_TITLE_FILE]}',
        description:
            '${appModal.localisedValues[CONSTANT_CHATCONTENT_SCREEN_DESCRIPTION_FILE]}',
        image: 'assets/images/file.png',
      ),
    ];

    return Container(
      color: Colors.grey[200],
      height: height,
      child: ListView.builder(
        itemCount: _medias.length + 1,
        itemBuilder: (context, index) =>
            this._renderMedia(context, _medias, index),
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
          style: fullNameTextStyle,
        ),
        SizedBox(
          height: 5,
        ),
        Text('$description'),
        SizedBox(
          height: 5,
        ),
        Divider(
          color: Colors.black,
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
      onTap: () => this._openMediums,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        margin: const EdgeInsets.only(bottom: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
                flex: 0,
                child: CircleAvatar(
                  backgroundImage: AssetImage(
                    '${currentMediaModal.image}',
                  ),
                )),
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

  @override
  Widget build(BuildContext context) {
    final String imagePath = user.image;
    final String nameUser = user.fullName;

    return Scaffold(
      key: this._keyScaffold,
      appBar: this._renderAppBar(nameUser, imagePath),
      body: this._renderBody(),
    );
  }

  void _unFocusInput() {
    if (this._focusInput == null) {
      return;
    }

    this._focusInput.unfocus();
  }

  void _showBottom() {
    this._unFocusInput();
    this
        ._keyScaffold
        .currentState
        .showBottomSheet((context) => this._renderMedias(context));
  }

  void _openMediums() {}
}

class _MediaModal {
  _MediaModal({
    this.name,
    this.description,
    this.image,
  });

  final String name;
  final String description;
  final String image;
}
