import 'package:badam_app/util/AuthServiceFirebase.dart';
import 'package:badam_app/util/sharedPreference.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class PhoneVarify extends StatefulWidget {
  @override
  _PhoneVarifyState createState() => _PhoneVarifyState();
}

class _PhoneVarifyState extends State<PhoneVarify> {
  String phoneNo, passwordInput;
  bool _isLoading = false;

  Widget innerButton() {
    return _isLoading
        ? Container(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(backgroundColor: Colors.white))
        : Text(
            "وارد شدن",
            style: TextStyle(color: Colors.white, fontSize: 16),
          );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  AuthServiceFirebase insta ;
  bool _toggleVistibal = true;
  submitNumber() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      setState(() {
        _isLoading = true;
      });
      
      insta.submitPhoneNumber(phoneNumber: this.phoneNo)
      .then((phoneVarifyId) {
        
        print(phoneVarifyId);
        savePreferenceString("tempUsername", this.phoneNo).then((data) {  
          savePreferenceString("tempPassword", this.passwordInput).then((data) {
            setState(() {
              _isLoading = false;
            });
            print(data);
            Navigator.pushNamed(context, "/PhoneAuthVerify", arguments: phoneVarifyId);
           
          });
        });
        
      })
      .catchError((error) {

        print(error);
        setState(() {
          _isLoading = false;
        });
        _scaffoldKey.currentState.showSnackBar(
          new SnackBar(
            backgroundColor: Colors.redAccent,
            content: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(
                  "لطفا انترنت تان را چک کنید",
                  style: TextStyle(fontFamily: "Vazir"),
                ),
                FaIcon(Icons.error)
              ],
            ),
            duration: Duration(seconds: 2),
          ),
        );
      }).whenComplete((){
      });
    }
  }

  @override
  void initState() {
    insta = AuthServiceFirebase(context: context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var number = TextInputType.number;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('ثبت و وارد شدن')),
      body: SingleChildScrollView(
              child: Center(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  TextFormField(
                                    autofocus: true,
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                    keyboardType: TextInputType.phone,
                                    maxLength: 10,
                                    textDirection: TextDirection.ltr,
                                    textAlign: TextAlign.left,
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return 'شماره تلفون را وارد کنید';
                                      }
                                      if (value.length < 10) {
                                        return 'شماره تلفون معتبر وارد کنید';
                                      }
                                      return null;
                                    },
                                    onSaved: (String value) {
                                      this.phoneNo = "+93" + value;
                                    },
                                    decoration: new InputDecoration(
                                        labelText: ' شماره تلفون تان وارد کنند',
                                        hintText: "0785185336",
                                        suffixStyle:
                                            const TextStyle(color: Colors.green)),
                                  ),
                                 
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 0.0),
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
                          onPressed: submitNumber,
                          child: innerButton(),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
