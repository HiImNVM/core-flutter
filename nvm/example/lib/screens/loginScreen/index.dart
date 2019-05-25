import 'package:example/components/loader/index.dart';
import 'package:example/components/snackBar/index.dart';
import 'package:example/constants.dart';
import 'package:example/models/index.dart';
import 'package:example/screens/loginScreen/constants.dart';
import 'package:example/screens/loginScreen/type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:nvm/nvm.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final TextEditingController _userNameCtrl =
      TextEditingController(text: 'admin');
  final TextEditingController _passwordCtrl =
      TextEditingController(text: 'admin');
  final TextEditingController _newUserNameCtrl = TextEditingController();
  final TextEditingController _newPasswordCtrl = TextEditingController();
  final TextEditingController _confirmPasswordCtrl = TextEditingController();

  final Size _ownSize =
      (Nvm.getInstance().global as AppModel).mediaQueryData.size;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Tabbar> _tabs;
  dynamic _localisedValues;
  bool _isRememberMe, _isShowPassword;

  @override
  void initState() {
    super.initState();

    this._isRememberMe = false;
    this._isShowPassword = false;
    this._localisedValues =
        (Nvm.getInstance().global as AppModel).localisedValues;

    final double heightContainerTab = this._ownSize.height * 0.3;
    this._tabs = [
      Tabbar(
        tab: Tab(
          text: '${this._localisedValues[CONSTANT_LOGIN_SCREEN_TITLE_SIGN_IN]}',
        ),
        widget: this._renderTabSignIn(heightContainerTab),
      ),
      Tabbar(
        tab: Tab(
          text:
              '${this._localisedValues[CONSTANT_LOGIN_SCREEN_TITLE_REGISTER]}',
        ),
        widget: this._renderTabRegister(heightContainerTab),
      ),
    ];
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
            this._renderContent(),
            this._renderFooter(),
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

  List<Tab> _renderTabs() => this._tabs.map((aTab) => aTab.tab).toList();

  List<Widget> _renderWidgets() =>
      this._tabs.map((aTab) => aTab.widget).toList();

  Widget _renderTabSignIn(double heightContainerTab) {
    final double heightOneColumn = (heightContainerTab - 30) / 4;
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: this._renderUserName(heightOneColumn),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: this._renderPassword(heightOneColumn),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: this._renderRememberAndForgot(heightOneColumn),
        ),
        SizedBox(
          height: 10,
        ),
        this._renderButtonLogin(heightOneColumn),
      ],
    );
  }

  Widget _renderTabRegister(double heightContainerTab) {
    final double heightOneColumn = (heightContainerTab - 30) / 4;
    final String hintNameNewUserName =
        '${this._localisedValues[CONSTANT_LOGIN_SCREEN_TITLE_USERNAME]}';
    final String hintNamePassword =
        '${this._localisedValues[CONSTANT_LOGIN_SCREEN_TITLE_PASSWORD]}';
    final String hintNameConfirmPassword =
        '${this._localisedValues[CONSTANT_LOGIN_SCREEN_TITLE_CONFIRM_PASSWORD]}';

    return Column(
      children: <Widget>[
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: heightOneColumn,
            child: TextField(
                obscureText: true,
                controller: this._newUserNameCtrl,
                decoration: InputDecoration(
                  hintText: hintNameNewUserName,
                  prefixIcon: Icon(Icons.account_circle),
                ),
                textInputAction: TextInputAction.done)),
        SizedBox(
          height: 10,
        ),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: heightOneColumn,
            child: TextField(
                obscureText: true,
                controller: this._newPasswordCtrl,
                decoration: InputDecoration(
                  hintText: hintNamePassword,
                  prefixIcon: Icon(Icons.vpn_key),
                ),
                textInputAction: TextInputAction.done)),
        SizedBox(
          height: 10,
        ),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: heightOneColumn,
            child: TextField(
                obscureText: true,
                controller: this._confirmPasswordCtrl,
                decoration: InputDecoration(
                  hintText: hintNameConfirmPassword,
                  prefixIcon: Icon(Icons.vpn_key),
                ),
                textInputAction: TextInputAction.done)),
        SizedBox(
          height: 10,
        ),
        Container(
          height: heightOneColumn,
          width: double.infinity,
          child: FlatButton(
            color: Colors.blue,
            onPressed: this._registerAccount,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              '${this._localisedValues[CONSTANT_LOGIN_SCREEN_TITLE_REGISTER]}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _renderContent() {
    final double heightContainerTab = this._ownSize.height * 0.3;
    final int totalTab = this._tabs.length;
    final List<Tab> tabs = this._renderTabs();
    final List<Widget> widgetsOfTabView = this._renderWidgets();

    return Container(
      margin: EdgeInsets.only(top: this._ownSize.height * 0.08),
      child: DefaultTabController(
        length: totalTab,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              color: Colors.black,
              child: TabBar(
                labelColor: Colors.white,
                labelStyle: TextStyle(fontSize: 20),
                tabs: tabs,
              ),
            ),
            Container(
              height: heightContainerTab,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.grey[50], blurRadius: 5),
                ],
              ),
              child: TabBarView(
                children: widgetsOfTabView,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderButtonLogin(double heightOneColumn) {
    return Container(
      height: heightOneColumn,
      width: double.infinity,
      child: FlatButton(
        color: Colors.blue,
        onPressed: this._login,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          '${this._localisedValues[CONSTANT_LOGIN_SCREEN_TITLE_SIGN_IN]}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _renderUserName(double heightOneColumn) {
    final String hintName =
        '${this._localisedValues[CONSTANT_LOGIN_SCREEN_TITLE_USERNAME]}';
    return Container(
      height: heightOneColumn,
      child: TextField(
          controller: this._userNameCtrl,
          decoration: InputDecoration(
            hintText: hintName,
            prefixIcon: Icon(Icons.account_circle),
          ),
          textInputAction: TextInputAction.done),
    );
  }

  Widget _renderPassword(double heightOneColumn) {
    final String hintName =
        '${this._localisedValues[CONSTANT_LOGIN_SCREEN_TITLE_PASSWORD]}';
    return Container(
      height: heightOneColumn,
      child: PasswordWidget(
        hintName: hintName,
        isShowPassword: this._isShowPassword,
        passwordCtrl: this._passwordCtrl,
      ),
    );
  }

  Widget _renderRememberAndForgot(double heightOneColumn) {
    return Container(
      height: heightOneColumn,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          this._renderRememberMe(),
          this._renderForgot(),
        ],
      ),
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
    return Container(
      margin: EdgeInsets.only(top: this._ownSize.height * 0.04),
      child: Column(
        children: <Widget>[
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: this._scaffoldKey,
      backgroundColor: Colors.grey[200],
      body: this._renderBody(context),
    );
  }

  void _login() async {
    final String userName = this._userNameCtrl.text;
    final String password = this._passwordCtrl.text;

    final String error = this._validateUserNameAndPassword(userName, password);

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

    // TODO: Hard code for working
    final String userNameExpected = 'admin';
    final String passwordExpected = 'admin';

    final bool result = await Future.delayed(Duration(seconds: 2), () {
      if (this._userNameCtrl.text == userNameExpected &&
          this._passwordCtrl.text == passwordExpected) {
        return true;
      }
      return false;
    });
    Navigator.pop(context);

    if (!result) {
      this._scaffoldKey.currentState.showSnackBar(
            SnackBarStatusWidget(
              statusEnum: StatusEnum.error,
              text:
                  '${this._localisedValues[CONSTANT_LOGIN_SCREEN_USERNAME_OR_PASSWORD_FAILED]}',
            ),
          );
      return;
    }

    Navigator.of(context).pushReplacementNamed('/home');
  }

  void _loginWithFB() {}

  void _loginWithGG() {}

  void _navigateForgotPasswordScreen() {}

  void _registerAccount() {
    showModalBottomSheet(
      context: context,
      builder: (context) => LoadingWidget(),
    );
  }

  String _validateUserNameAndPassword(String userName, String password) {
    if (userName.isEmpty) {
      return '${this._localisedValues[CONSTANT_LOGIN_SCREEN_USERNAME_NOT_NULL_OR_EMPTY]}';
    }

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
