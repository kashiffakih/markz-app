import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/core/providers/auth_pr.dart';
import 'package:sales_app/core/providers/config_pr.dart';
import 'package:sales_app/locator.dart';
import 'package:sales_app/ui/shared/images_sh.dart';
import 'dart:io' show Platform;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;

  final GlobalKey<FormState> _loginKey = GlobalKey<FormState>();

  ConfigModel _configModel = locator<ConfigModel>();

  Map<String, dynamic> _loginData = {
    'email': '',
    'password': '',
    'rememberme': 1,
  };

  // Map<String, dynamic> _loginData = {
  //   'email': 'BD001',
  //   'password': '123456',
  //   'rememberme': 1,
  // };

  // Map<String, dynamic> _loginData = {};

  bool _isLoading = false;

  @override
  void initState() {
    fetchLoginData();

    super.initState();
  }

  fetchLoginData() async {
    await _configModel.fetchLoginData();
  }

  @override
  Widget build(BuildContext context) {
    // _loginData = _configModel.loginData;
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Images.backgroundImg),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(4),
              child: Container(
                child: Card(
                  color: Color.fromRGBO(255, 255, 255, 0.6),
                  elevation: 7,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _loginKey,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          if (Platform.isAndroid)
                            Image.asset(
                              Images.logo,
                              height: 150,
                            ),
                          if (Platform.isIOS)
                            Image.asset(
                              Images.logoIOS,
                              height: 150,
                            ),
                          Text(
                            'BD APPLICATION',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Username',
                            ),
                            initialValue: _loginData['email'],
                            validator: (value) {
                              if (value!.isEmpty)
                                return 'Username cannot be empty';
                              return null;
                            },
                            onSaved: (value) {
                              _loginData['email'] = value;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Password',
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                                child: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                            ),
                            obscureText: _obscurePassword,
                            initialValue: _loginData['password'],
                            validator: (value) {
                              if (value!.isEmpty)
                                return 'Password cannot be empty';
                              return null;
                            },
                            onSaved: (value) {
                              _loginData['password'] = value;
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () {
                                        setState(() {
                                          _loginData['rememberme'] =
                                              _loginData['rememberme'] == 1
                                                  ? 0
                                                  : 1;
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.blue,
                                            ),
                                            child: _loginData['rememberme'] == 1
                                                ? Icon(
                                                    Icons.check,
                                                    size: 15.0,
                                                    color: Colors.white,
                                                  )
                                                : Icon(
                                                    Icons
                                                        .check_box_outline_blank,
                                                    size: 15.0,
                                                    color: Colors.blue,
                                                  ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text('Remember Me')
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Consumer<AuthModel>(
                            builder: (context, authModel, child) =>
                                MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(16.0)),
                              minWidth: MediaQuery.of(context).size.width * .8,
                              color: Theme.of(context).primaryColor,
                              onPressed: () async {
                                setState(() {
                                  _isLoading = true;
                                });

                                if (_loginKey.currentState!.validate()) {
                                  _loginKey.currentState!.save();

                                  await authModel.login(loginData: _loginData);
                                  if (_configModel.isLoggedIn) {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      '/',
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: Text(
                                            _configModel.loginFailedMessage),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('Ok'),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                }

                                setState(() {
                                  _isLoading = false;
                                });
                              },
                              child: _isLoading
                                  ? SizedBox(
                                      child: CircularProgressIndicator(
                                        backgroundColor: Colors.white,
                                      ),
                                      height: 20,
                                      width: 20,
                                    )
                                  : Text(
                                      'Login',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
