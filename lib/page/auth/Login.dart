import 'package:badam_app/style/style.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class LoginUser extends StatefulWidget {
  @override
  _LoginUserState createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  var usernameInput, passwordInput;


  Future<void> LoginUserDB() async {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      backgroundColor: Colors.green,
      content: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          new Text(
            "لطفا صبر کنید...",
            style: TextStyle(fontFamily: "Vazir"),
          ),
          new CircularProgressIndicator(),
        ],
      ),
    ));
    // print(nameInput);
    // print(passwordInput);
    await http.post("http://192.168.43.186/FamooWebsite/wp-json/badam/v1/login",
        body: {
          "username": usernameInput,
          "password": passwordInput,
        }).then((data) {
      print(data.body);
      if (data.body == "2") {
        _scaffoldKey.currentState.showSnackBar(
          new SnackBar(
            backgroundColor: Colors.redAccent,
            content: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(
                  "شما قبلا ثبت نام کردین",
                  style: TextStyle(fontFamily: "Vazir"),
                ),
              ],
            ),
          ),
        );
      } else if (data.body == "1") {}
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("بخش ورود"),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            // Image.asset("assets/images/fifthflour.png"),
            Card(
              margin: EdgeInsets.only(left: 10, right: 10, bottom: 30),
              elevation: 0,
              child: Container(
                padding: EdgeInsets.only(top: 10),
                width: double.infinity,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                          textDirection: TextDirection.rtl,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please Enter Password';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            this.usernameInput = value;
                          },
                          autofocus: true,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: ' شماره تلفون تان وارد کنند',
                            // labelText: 'نام و تخلص',
                          ),
                          obscureText: false),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(
                    //       horizontal: 20, vertical: 10),
                    //   child: TextFormField(
                    //     textDirection: TextDirection.rtl,
                    //     validator: (value) {
                    //       if (value.isEmpty) {
                    //         return 'Please Enter Password';
                    //       }
                    //       return null;
                    //     },
                    //     onSaved: (value) {
                    //       this.passwordInput = value;
                    //     },
                    //     onChanged: (value) {
                    //       this.passwordInput = value;
                    //     },
                    //     keyboardType: TextInputType.visiblePassword,
                    //     decoration: InputDecoration(
                    //       labelText: 'رمز عبور وارد کنید',
                     
                    //     ),
                    //     obscureText: true,
                    //   ),
                    // ),
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
                          onPressed: LoginUserDB,
                          child: Text(
                            "وارد شدن",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topRight,
                      child: FlatButton(
                        onPressed: () {},
                        child: textMedim(
                          "فراموشی رمز عبور؟",
                          context,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

//  var displayName = user.displayName;
//             var email = user.email;
//             var emailVerified = user.emailVerified;
//             var photoURL = user.photoURL;
//             var uid = user.uid;
//             var phoneNumber = user.phoneNumber;
//             var providerData = user.providerData;
