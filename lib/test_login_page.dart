import 'package:badam_app/page/Homepage.dart';
import 'package:badam_app/page/myProperties/manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import './provider/auth_provider.dart';

class Test_Login_page extends StatefulWidget {
  @override
  _Test_Login_pageState createState() => _Test_Login_pageState();
}

class _Test_Login_pageState extends State<Test_Login_page> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider.of<Auth>(context, listen: false).isAuth
        ? ManagerPage()
        : FutureBuilder(
            future: Provider.of<Auth>(context, listen: false).tryAutoLogin(),
            builder: (ctx, authResultSnapshot) =>
                authResultSnapshot.connectionState == ConnectionState.waiting
                    ? ManagerPage()
                    : unAuthWidget(),
          );
  }

  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();

  Widget unAuthWidget() {
    return Scaffold(
      appBar: AppBar(title: Text("حساب کاربری")),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Text(
                "برای ثبت و مدیریت آگهی های خود وارد سیستم شوید.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
            ),
            FlatButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ManagerPage(),
                ),
              ),
              // showDialog(
              // context: context,
              // builder: (_) {
              //   return ShowLoginDialog();
              // }),
              child: Container(
                padding: EdgeInsets.all(10),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "ورود / ثبت نام",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget authWidget() {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          onPressed: () async {
            setState(() {});
            await Provider.of<Auth>(context, listen: false).logout();
          },
          child: Text("logout"),
        ),
      ),
    );
  }
}

class ShowLoginDialog extends StatefulWidget {
  @override
  _ShowLoginDialogState createState() => _ShowLoginDialogState();
}

class _ShowLoginDialogState extends State<ShowLoginDialog> {
  TextEditingController username = new TextEditingController();
  TextEditingController password = new TextEditingController();
  bool _isLoading = false;
  Color _c = Colors.redAccent;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: username,
            decoration: InputDecoration(
              icon: Icon(Icons.account_circle),
              labelText: 'نام کاربری ویا ایمیل',
            ),
          ),
          TextField(
            obscureText: true,
            controller: password,
            decoration: InputDecoration(
              icon: Icon(Icons.lock),
              labelText: 'رمز عبور',
            ),
          ),
        ],
      ),
      actions: <Widget>[
        RaisedButton(
          color: Theme.of(context).primaryColor,
          elevation: 10,
          onPressed: () async {
            print("Mahdi: ... ");
            // if (_isLoading) {
            //   return null;
            // }
            setState(() {
              _isLoading = true;
            });
            await Provider.of<Auth>(context, listen: false)
                .login(username.text, password.text)
                .then((data) {
              if (data[0]) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => Dashboard(
                      currentIndexTab: 0,
                    ),
                  ),
                );
              } else {
                switch (data[1]) {
                  case '[jwt_auth] incorrect_password':
                }
              }
              setState(() {
                _isLoading = false;
              });
              print(data);
            });
          },
          child: _isLoading
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,

                    backgroundColor: Colors.white,
                    // valueColor: Colors.white,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text(
                        "وارد شدن",
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ],
                  ),
                ),
        )
      ],
    );
  }
}
