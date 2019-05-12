import 'package:example/components/loader/index.dart';
import 'package:example/components/snackBar/index.dart';
import 'package:example/constants.dart';
import 'package:example/models/index.dart';
import 'package:example/screens/loginScreen/constants.dart';
import 'package:example/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:nvm/nvm.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final TextEditingController _userNameCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();

  final Size _ownSize =
      (Nvm.getInstance().global as AppModel).mediaQueryData.size;

  dynamic _localisedValues;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isRememberMe, _isShowPassword;

  @override
  void initState() {
    super.initState();

    this._isRememberMe = false;
    this._isShowPassword = false;
  }

  Widget _renderBody(context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          left: 10,
          right: 10,
          top: this._ownSize.height * 0.18,
          bottom: 10,
        ),
        child: Column(
          children: <Widget>[
            this._renderHeader(),
            Container(
              margin: EdgeInsets.only(top: this._ownSize.height * 0.1),
              child: this._renderContent(),
            ),
            Container(
              margin: EdgeInsets.only(top: this._ownSize.height * 0.04),
              child: this._renderFooter(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderHeader() {
    return Text(
      '${this._localisedValues[CONSTANT_LOGIN_SCREEN_NAME_HEADER]}',
      style: TextStyle(
        color: Colors.blue,
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _renderContent() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey[50], blurRadius: 5),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: this._renderUserName(),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: this._renderPassword(),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: this._renderRememberAndForgot(),
          ),
          SizedBox(
            height: 10,
          ),
          this._renderButtonLogin(),
        ],
      ),
    );
  }

  Widget _renderButtonLogin() {
    final double heightButtonLogin = this._ownSize.height * 0.07;
    return Container(
      width: double.infinity,
      height: heightButtonLogin,
      child: FlatButton(
        color: Colors.blue,
        onPressed: this._login,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          'Login',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _renderUserName() {
    final String hintName =
        '${this._localisedValues[CONSTANT_LOGIN_SCREEN_TITLE_USERNAME]}';
    return TextField(
        controller: this._userNameCtrl,
        decoration: InputDecoration(
          hintText: hintName,
          labelText: hintName,
          prefixIcon: Icon(Icons.account_circle),
        ),
        textInputAction: TextInputAction.done);
  }

  Widget _renderPassword() {
    final String hintName =
        '${this._localisedValues[CONSTANT_LOGIN_SCREEN_TITLE_PASSWORD]}';
    return PasswordWidget(
      hintName: hintName,
      isShowPassword: this._isShowPassword,
      passwordCtrl: this._passwordCtrl,
    );
  }

  Widget _renderRememberAndForgot() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        this._renderRememberMe(),
        this._renderForgot(),
      ],
    );
  }

  Widget _renderRememberMe() {
    return RememberMeWidget(
      hintName:
          '${this._localisedValues[CONSTANT_LOGIN_SCREEN_TITLE_REMEMBERME]}',
      isRememberMe: this._isRememberMe,
    );
  }

  Widget _renderForgot() {
    return GestureDetector(
      onTap: this._navigateForgotPasswordScreen,
      child: Text(
        '${this._localisedValues[CONSTANT_LOGIN_SCREEN_TITLE_FORGOT_PASSWORD]}',
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _renderLoginWithFacbook() {
    return this._renderOnlyPlatform(
      namePlatform: '$CONSTANT_TITLE_FACEBOOK_PLATFORM',
      color: Colors.blue[900],
      loginWithOwnPlatform: this._loginWithFB,
    );
  }

  Widget _renderLoginWithGoogle() {
    return this._renderOnlyPlatform(
      namePlatform: '$CONSTANT_TITLE_GOOGLE_PLATFORM',
      color: Colors.red,
      loginWithOwnPlatform: this._loginWithGG,
    );
  }

  Widget _renderOnlyPlatform({
    String namePlatform,
    Color color,
    Function loginWithOwnPlatform,
  }) {
    return Container(
      height: this._ownSize.height * 0.07,
      child: RaisedButton(
        color: color,
        onPressed: loginWithOwnPlatform,
        child: Text(
          '$namePlatform',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _renderFooter() {
    return Column(
      children: <Widget>[
        Text(
          '${this._localisedValues[CONSTANT_LOGIN_SCREEN_TITLE_DONT_HAVE_AN_ACCOUNT_YET]}',
          style: TextStyle(fontSize: 15, color: Colors.grey),
        ),
        SizedBox(
          height: 8,
        ),
        GestureDetector(
          onTap: this._navigateSignUpScreen,
          child: Text(
            '${this._localisedValues[CONSTANT_LOGIN_SCREEN_TITLE_SIGN_UP_NOW]}',
            style: TextStyle(
              fontSize: 15,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: this._ownSize.height * 0.03,
        ),
        Text(
          '---OR---',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: this._ownSize.height * 0.03,
        ),
        Row(
          children: <Widget>[
            Expanded(flex: 1, child: this._renderLoginWithFacbook()),
            SizedBox(
              width: 10,
            ),
            Expanded(flex: 1, child: this._renderLoginWithGoogle()),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    this._localisedValues =
        (Nvm.getInstance().global as AppModel).localisedValues;
    return Scaffold(
      key: this._scaffoldKey,
      backgroundColor: Colors.grey[200],
      body: this._renderBody(context),
    );
  }

  void _login() async {
    final String error = this._validateUserNameAndPassword();

    if (error.isNotEmpty) {
      this._scaffoldKey.currentState.showSnackBar(
            SnackBarStatusWidget(
              statusEnum: StatusEnum.error,
              text: error,
            ),
          );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LoadingWidget(),
    );

    final dynamic result =
        await (Nvm.getInstance().global as AppModel).request.call(
              url: '/users',
            );

    Navigator.pop(context);

    print('$result');
  }

  void _loginWithFB() {}

  void _loginWithGG() {}

  void _navigateForgotPasswordScreen() {}

  void _navigateSignUpScreen() {}

  String _validateUserNameAndPassword() {
    final String userName = this._userNameCtrl.text;
    if (userName.isEmpty) {
      return '${this._localisedValues[CONSTANT_LOGIN_SCREEN_USERNAME_NOT_NULL_OR_EMPTY]}';
    }

    final String password = this._passwordCtrl.text;
    if (password.isEmpty) {
      return '${this._localisedValues[CONSTANT_LOGIN_SCREEN_PASSWORD_NOT_NULL_OR_EMPTY]}';
    }

    return '';
  }
}

class RememberMeWidget extends StatefulWidget {
  bool isRememberMe;
  final String hintName;

  RememberMeWidget({
    this.isRememberMe,
    this.hintName,
  });

  @override
  _RememberMeWidgetState createState() => _RememberMeWidgetState();
}

class _RememberMeWidgetState extends State<RememberMeWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Checkbox(
          value: this.widget.isRememberMe,
          onChanged: (newValue) => this.setState(
              () => this.widget.isRememberMe = !this.widget.isRememberMe),
        ),
        Text(
          '${this.widget.hintName}',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class PasswordWidget extends StatefulWidget {
  final TextEditingController passwordCtrl;
  final String hintName;
  bool isShowPassword;

  PasswordWidget({
    this.passwordCtrl,
    this.isShowPassword,
    this.hintName,
  });

  @override
  _PasswordWidgetState createState() => _PasswordWidgetState();
}

class _PasswordWidgetState extends State<PasswordWidget> {
  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: this.widget.passwordCtrl,
        obscureText: !this.widget.isShowPassword,
        decoration: InputDecoration(
          hintText: '${this.widget.hintName}',
          labelText: '${this.widget.hintName}',
          prefixIcon: Icon(Icons.vpn_key),
          suffix: GestureDetector(
            onTap: () => this.setState(
                () => this.widget.isShowPassword = !this.widget.isShowPassword),
            child: Icon(
              Icons.remove_red_eye,
              color: (this.widget.isShowPassword == true)
                  ? Colors.blue
                  : Colors.black,
            ),
          ),
        ),
        textInputAction: TextInputAction.done);
  }
}
