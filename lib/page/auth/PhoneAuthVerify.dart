import 'dart:async';

import 'package:badam_app/util/AuthServiceFirebase.dart';
import 'package:badam_app/util/httpRequest.dart';
import 'package:badam_app/util/sharedPreference.dart';
import 'package:badam_app/util/utiles_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Countdown extends AnimatedWidget {
  Countdown({Key key, this.animation}) : super(key: key, listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context) {
    return new Text(
      animation.value.toString(),
      style: new TextStyle(fontSize: 150.0),
    );
  }
}

// ignore: must_be_immutable
class PhoneAuthVerify extends StatefulWidget {
  final varify_id;
  PhoneAuthVerify(this.varify_id);
  @override
  _PhoneAuthVerifyState createState() => _PhoneAuthVerifyState(this.varify_id);
}

class _PhoneAuthVerifyState extends State<PhoneAuthVerify>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  var varify_id;
  _PhoneAuthVerifyState(this.varify_id);
  double _height, _width, _fixedPadding;

  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();
  FocusNode focusNode5 = FocusNode();
  FocusNode focusNode6 = FocusNode();
  String code = "";

  AnimationController _controller;

  static const int kStartValue = 4;

  bool _isLoading = false;

  Widget submitButton() {
    return _isLoading
        ? Container(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(backgroundColor: Colors.white))
        : Text(
            "ارسال کردن",
            style: TextStyle(color: Colors.white, fontSize: 16),
          );
  }

  AuthServiceFirebase insta;
  bool _resendLoader = false;
  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: kStartValue),
    );

    insta = AuthServiceFirebase(context: context);
  }

  bool _showTimer = true;
  Widget resendWidget() {
    return _showTimer
        ? new Countdown(
            animation: new StepTween(
              begin: kStartValue,
              end: 0,
            ).animate(_controller),
          )
        : FlatButton(
            onPressed: () {
              setState(() {
                _resendLoader = true;
              });
              readPreferenceString("tempUsername").then((username) {
                insta
                    .submitPhoneNumber(phoneNumber: username)
                    .then((phoneVarifyId) {
                  setState(() {
                    this.varify_id = phoneVarifyId;
                    _isLoading = false;
                    _resendLoader = false;
                  });
                });
              }).catchError((error) {
                print(error.toString());
                setState(() {
                  _isLoading = false;
                  _resendLoader = false;
                });
              });
            },
            child: _resendLoader
                ? Container(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        backgroundColor: Colors.white))
                : Text(
                    "ارسال مجدد",
                    style: TextStyle(color: Colors.white),
                  ),
          );
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _fixedPadding = _height * 0.025;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("تشخص کد"),
        actions: <Widget>[resendWidget()],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: _getBody(),
          ),
        ),
      ),
    );
  }

  Widget _getBody() => _getColumnBody();

  Widget _getColumnBody() => Column(
        children: <Widget>[
          //  Logo: scaling to occupy 2 parts of 10 in the whole height of device
          Image.asset(
            "assets/img/Vault.png",
            width: 250,
          ),

          //  Info text
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'کد ۶ رقمی تان را وارد کنید.',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Vazir"),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(width: 16.0),
            ],
          ),

          Row(
            textDirection: TextDirection.ltr,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              getPinField(key: "1", focusNode: focusNode1),
              SizedBox(width: 5.0),
              getPinField(key: "2", focusNode: focusNode2),
              SizedBox(width: 5.0),
              getPinField(key: "3", focusNode: focusNode3),
              SizedBox(width: 5.0),
              getPinField(key: "4", focusNode: focusNode4),
              SizedBox(width: 5.0),
              getPinField(key: "5", focusNode: focusNode5),
              SizedBox(width: 5.0),
              getPinField(key: "6", focusNode: focusNode6),
              SizedBox(width: 5.0),
            ],
          ),

          SizedBox(height: 32.0),

          Container(
            width: 200,
            padding: EdgeInsets.all(10),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
              ),
              child: FlatButton(
                onPressed: signIn,
                child: submitButton(),
              ),
            ),
          ),
        ],
      );

  signIn() {
    if (code.length < 6) {
      print(code.length);
      _scaffoldKey.currentState.showSnackBar(
        new SnackBar(
          backgroundColor: Colors.redAccent,
          content: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Text(
                "کد نمبر را وارد کنید.",
                style: TextStyle(fontFamily: "Vazir"),
              ),
              Icon(Icons.error)
            ],
          ),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      signInToRegister(code);
    }
  }

  Future<void> signInToRegister(String smsCode) async {
    setState(() {
      _isLoading = true;
    });

    print(varify_id.toString());

        Navigator.pop(context);
              Navigator.pushReplacementNamed(context, "/register");
    AuthServiceFirebase authSer = new AuthServiceFirebase(context: context);

    readPreferenceString("tempUsername").then((user) {
      userAlreadyRegisterd(getPhoneforuser(user)).then((isAlreadyReister) {
        authSer
            .confirmSMSCode(smsCode: smsCode, verificationId: this.varify_id)
            .then((data) {
          if (data != null) {
            setState(() {
              _isLoading = false;
            });

            print(isAlreadyReister.body.toString());

            if (isAlreadyReister.body.toString() == '0') {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, "/Dashboard");
            } else if (isAlreadyReister.body.toString() == '1') {
              
            } else {
              _scaffoldKey.currentState.showSnackBar(new SnackBar(
                backgroundColor: Colors.redAccent,
                content: new Text(
                  'اتصال انترنت تان را چک کنید',
                  style: TextStyle(fontFamily: "Vazir"),
                ),
              ));
              Timer(Duration(seconds: 1), () {
                Navigator.pop(context);
              });
            }
          }
        }).catchError((e) {
          setState(() {
            _isLoading = false;
          });
          print(e);
          if (e.code == "ERROR_INVALID_VERIFICATION_CODE") {
            setState(() {
              _isLoading = false;
            });

            _scaffoldKey.currentState.showSnackBar(new SnackBar(
              backgroundColor: Colors.redAccent,
              content: new Text(
                'کد نمبر درست نمیباشد.',
                style: TextStyle(fontFamily: "Vazir"),
              ),
            ));
          } else {
            setState(() {
              _isLoading = false;
            });
            _scaffoldKey.currentState.showSnackBar(new SnackBar(
              backgroundColor: Colors.redAccent,
              content: new Text(
                'اتصال انترنت تان را چک کنید',
                style: TextStyle(fontFamily: "Vazir"),
              ),
            ));
          }
        });
      }).catchError((error) {
        setState(() {
          _isLoading = false;
        });

        print(error);
        _scaffoldKey.currentState.showSnackBar(new SnackBar(
          backgroundColor: Colors.redAccent,
          content: new Text(
            'اتصال انترنت تان را چک کنید',
            style: TextStyle(fontFamily: "Vazir"),
          ),
        ));
      });
    });
  }

  // This will return pin field - it accepts only single char
  Widget getPinField({String key, FocusNode focusNode}) => SizedBox(
        height: 40.0,
        width: 35.0,
        child: TextField(
          key: Key(key),
          expands: false,
          autofocus: key.contains("1") ? true : false,
          focusNode: focusNode,
          onChanged: (String value) {
            if (value.length == 1) {
              code += value;
              switch (code.length) {
                case 1:
                  FocusScope.of(context).requestFocus(focusNode2);
                  break;
                case 2:
                  FocusScope.of(context).requestFocus(focusNode3);
                  break;
                case 3:
                  FocusScope.of(context).requestFocus(focusNode4);
                  break;
                case 4:
                  FocusScope.of(context).requestFocus(focusNode5);
                  break;
                case 5:
                  FocusScope.of(context).requestFocus(focusNode6);
                  break;
                default:
                  FocusScope.of(context).requestFocus(FocusNode());
                  break;
              }
            }
          },
          maxLengthEnforced: false,
          textAlign: TextAlign.center,
          cursorColor: Theme.of(context).primaryColor,
          keyboardType: TextInputType.number,
          style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor),
        ),
      );
}
