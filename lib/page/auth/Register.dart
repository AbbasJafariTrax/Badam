import 'package:badam_app/util/AuthServiceFirebase.dart';
import 'package:badam_app/util/httpRequest.dart';
import 'package:badam_app/util/sharedPreference.dart';
import 'package:badam_app/util/utiles_functions.dart';
import 'package:flutter/material.dart';

class RegisterUser extends StatefulWidget {
  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  AuthServiceFirebase authCurrent;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  @override
  void initState() {
    authCurrent = new AuthServiceFirebase(context: context);
    super.initState();
  }

  var nameInput, lastnameInput;

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

  LoginUserDB() {
    setState(() {
      _isLoading = true;
    });

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      Navigator.pop(context);
                            Navigator.pushReplacementNamed(
                                context, "/Dashboard");

                                
      readPreferenceString("tempUsername").then((data) {
        var username = data;
        readPreferenceString("tempPassword").then((data) {
          var password = data;
          print("username : " + getPhoneforuser(username));
          authCurrent.getCurrentUser().then((valu) {
            print("current user Id: " + valu.uid);

            String displayName =
                this.nameInput.toString() + " " + this.lastnameInput.toString();
            registerUserDB(
                    getPhoneforuser(username), displayName, password, valu.uid)
                .then((dataIn) {
              if (int.parse(dataIn.body) > 0) {
                savePreferenceString(
                        "userId", int.parse(dataIn.body).toString())
                    .then((data) {
                  savePreferenceString("displayName", nameInput).then((data) {
                    savePreferenceString("displayLast", lastnameInput)
                        .then((val) {
                      savePreferenceString("profileUrl", "").then((da) {
                        savePreferenceString("username", username).then((data) {
                          savePreferenceString("password", password)
                              .then((data) {
                            
                          });
                        });
                      });
                    });
                  });
                });
              } else if (int.parse(dataIn.body) == 0) {
                _scaffoldKey.currentState.showSnackBar(
                  new SnackBar(
                    backgroundColor: Colors.redAccent,
                    content: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Text(
                          "شما قبلا ثبت نام کرده بودین",
                          style: TextStyle(fontFamily: "Vazir"),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                _scaffoldKey.currentState.showSnackBar(
                  new SnackBar(
                    backgroundColor: Colors.redAccent,
                    content: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Text(
                          "انترنت تان را چک کنید",
                          style: TextStyle(fontFamily: "Vazir"),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }).catchError((error) {
              print("registerition : " + error);
            });
          }).catchError((error) {
            print(error);
          });
        });
      });
    }
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("کامل کردن پروفایل"),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                        textDirection: TextDirection.rtl,
                        onSaved: (String value) {
                          this.nameInput = value;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'نام تان را وارد کنید';
                          }
                          return null;
                        },
                        autofocus: true,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'نام تان را وارد کنید ',
                        ),
                        obscureText: false),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      textDirection: TextDirection.rtl,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'تخلص تان را وارد کنید';
                        }
                        return null;
                      },
                      onSaved: (String value) {
                        this.lastnameInput = value;
                      },
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'تخلص تان را وارد کنید ',
                      ),
                      obscureText: false,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      textDirection: TextDirection.rtl,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'رمز عبور را وارد کنید';
                        }
                        return null;
                      },
                      onSaved: (String value) {
                        this.lastnameInput = value;
                      },
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: ' رمز عبور تان وارد کنند',
                      ),
                      obscureText: false,
                    ),
                  ),
                    SizedBox(
                    height: 20,
                  ),
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
                        child: submitButton(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
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
