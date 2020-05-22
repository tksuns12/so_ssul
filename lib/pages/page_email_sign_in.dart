import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:redux/redux.dart';
import 'package:sossul/actions/actions.dart';
import 'package:sossul/constants.dart';
import 'package:sossul/store/app_state.dart';
import 'package:sossul/routes.dart';

class EmailSignInPage extends StatefulWidget {
  @override
  _EmailSignInPageState createState() => _EmailSignInPageState();
}

class _EmailSignInPageState extends State<EmailSignInPage> {
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel.fromStore(store),
      builder: (BuildContext context, _ViewModel vm) {
        return Material(
          color: kDarkPrimaryColor,
          child: Stack(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Hero(
                        tag: 'appname',
                        child: Material(
                            color: kDarkPrimaryColor,
                            child: Text(
                              'So.SSul',
                              style:
                                  TextStyle(fontSize: 50, color: Colors.white),
                            ))),
                    Padding(
                      padding: const EdgeInsets.only(top: 200, bottom: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Icon(
                              FontAwesomeIcons.envelope,
                              size: 25,
                              color: Colors.white,
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              SizedBox(
                                width: 250,
                                child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  onChanged: (text) {
                                    email = text;
                                  },
                                  validator: (value) {
                                    Pattern emailPattern =
                                        r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$';
                                    RegExp emailRegex = RegExp(emailPattern);
                                    if (!emailRegex.hasMatch(value)) {
                                      return "이메일 주소 형식이 안 맞습니다.";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Icon(
                            FontAwesomeIcons.key,
                            color: Colors.white,
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            SizedBox(
                              width: 250,
                              child: TextFormField(
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.text,
                                obscureText: true,
                                onChanged: (text) {
                                  password = text;
                                },
                                onFieldSubmitted: (text) async {
                                  if (_formKey.currentState.validate()) {
                                    vm.trySignIn();
                            if (vm.isSignedIn) {
                              Navigator.of(context).pushReplacementNamed(Routes.main);
                            } else if (vm.isFailed) {
                              // TODO: 에러 메세지 노출 구현 필요
                            }
                                  }
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return '비밀번호를 입력하십시오.';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: FlatButton(
                        child: Container(
                          child: Text('로그인'),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            vm.trySignIn();
                            if (vm.isSignedIn) {
                              Navigator.of(context).pushReplacementNamed(Routes.main);
                            } else if (vm.isFailed) {
                              // TODO: 에러 메세지 노출 구현 필요
                            }
                          }
                                                  
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: FlatButton(
                        child: Text('계정 생성'),
                        onPressed: () {
                          Navigator.pushNamed(
                              context, Routes.emailAccountCreate);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                child: Center(child: CircularProgressIndicator()),
                visible: vm.isSigningIn,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ViewModel {
  final bool isSigningIn;
  final bool isSignedIn;
  final bool isFailed;
  final Function trySignIn;

  _ViewModel(
      {this.trySignIn, this.isSigningIn, this.isSignedIn, this.isFailed});

  factory _ViewModel.fromStore(Store<AppState> store) {
    return _ViewModel(
      isSigningIn: store.state.userState.isSigningIn,
      isSignedIn: store.state.userState.isSignedIn,
      isFailed: store.state.userState.isSignedInFailed,
      trySignIn: () => store.dispatch(SignInWithEmailAction),
    );
  }
}
