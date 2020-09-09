import 'package:badam_app/util/AuthServiceFirebase.dart';
import 'package:badam_app/util/sharedPreference.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String username = "";
  String displayName = "";
  String displayLast = "";
  String profileUrl = "";
  String userId = "";
  bool dont = false;

  Future getUsername() async {
    try {
      List responses = await Future.wait([
        readPreferenceString("username").then((dataUsername) {
          if (dataUsername != null) {
            print("username : " + dataUsername);
            this.username = dataUsername;
          }
        }),
        readPreferenceString("userId").then((userId) {
          if (userId != null) {
            print("userId : " + userId);
            this.userId = userId;
          }
        }),
        readPreferenceString("displayName").then((dataName) {
          if (dataName != null) {
            print("dataName : " + dataName);

            this.displayName = dataName;
          }
        }),
        readPreferenceString("displayLast").then((dataLast) {
          if (dataLast != null) {
            this.displayLast = dataLast;
          }
        }),
        readPreferenceString("profileUrl").then((pro) {
          print("profileUrl : " + pro);
          if (pro != null) {
            this.profileUrl = pro;
          }
        })
      ]);

      return Future.value(responses);
    } catch (e) {
      print("error");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder(
        future: getUsername(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height - 60,
                  child: ListView(
                    children: <Widget>[
                      UserAccountsDrawerHeader(
                        accountName:
                            Text(this.displayName + " " + this.displayLast),
                        accountEmail: Text(username),
                        currentAccountPicture: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: profileUrl == ""
                              ? Text(
                                  displayName.substring(0, 1) +
                                      displayLast.substring(1, 2),
                                  style: TextStyle(fontSize: 30),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: FadeInImage.assetNetwork(
                                    placeholder: "",
                                    alignment: Alignment.topCenter,
                                    fit: BoxFit.cover,
                                    height: 100.0,
                                    width: 100,
                                    image: (profileUrl),
                                  ),
                                ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                            border: Border(
                                left: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 5,
                        ))),
                        child: ListTile(
                          contentPadding: EdgeInsets.only(
                              top: 0, left: 10, right: 10, bottom: 0),
                          onTap: () {
                            Navigator.pushReplacementNamed(context, "/");
                          },
                          selected: true,
                          leading: Icon(
                            Icons.home,
                            size: 28,
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                          ),
                          title: Text(
                            'صفحه اصلی',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 3),
                        decoration: BoxDecoration(
                            border: Border(
                                left: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 5,
                        ))),
                        child: ListTile(
                          contentPadding: EdgeInsets.only(
                              top: 0, left: 10, right: 10, bottom: 10),
                          onTap: () => Navigator.pushNamed(
                              context, "/myPropertyList",
                              arguments: this.userId),
                          leading: Icon(
                            Icons.list,
                            size: 28,
                          ),
                          trailing: Icon(Icons.arrow_forward_ios),
                          title: Text(
                            'لیست املاک من',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 3),
                        decoration: BoxDecoration(
                            border: Border(
                                left: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 5,
                        ))),
                        child: ListTile(
                          contentPadding: EdgeInsets.only(
                              top: 0, left: 10, right: 10, bottom: 10),
                          onTap: () =>
                              Navigator.pushNamed(context, "/favoritePage"),
                          leading: Icon(
                            Icons.favorite_border,
                            size: 28,
                          ),
                          trailing: Icon(Icons.arrow_forward_ios),
                          title: Text(
                            'لیست علاقه مندان',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 3),
                        decoration: BoxDecoration(
                            border: Border(
                                left: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 5,
                        ))),
                        child: ListTile(
                          contentPadding: EdgeInsets.only(
                              top: 0, left: 10, right: 10, bottom: 10),
                          onTap: () {
                            Navigator.pushNamed(context, "/profile");
                          },
                          leading: Icon(
                            Icons.settings,
                            size: 28,
                          ),
                          trailing: Icon(Icons.arrow_forward_ios),
                          title: Text(
                            'پروفایل',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 3),
                        decoration: BoxDecoration(
                            border: Border(
                                left: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 5,
                        ))),
                        child: ListTile(
                          contentPadding: EdgeInsets.only(
                              top: 0, left: 10, right: 10, bottom: 10),
                          onTap: () {},
                          leading: Icon(
                            Icons.message,
                            size: 28,
                          ),
                          trailing: Icon(Icons.arrow_forward_ios),
                          title: Text(
                            'تماس باما',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 3),
                        decoration: BoxDecoration(
                            border: Border(
                                left: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 5,
                        ))),
                        child: ListTile(
                          contentPadding: EdgeInsets.only(
                              top: 0, left: 10, right: 10, bottom: 10),
                          onTap: () {},
                          leading: Icon(
                            Icons.inbox,
                            size: 28,
                          ),
                          trailing: Icon(Icons.arrow_forward_ios),
                          title: Text(
                            'شرایط مقرارات',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 60,
                  child: ListTile(
                    onTap: () {
                      savePreferenceString("username", null).then((data) {
                        savePreferenceString("password", null).then((data) {
                          savePreferenceString("profileUrl", null).then((data) {
                            AuthServiceFirebase(context: context)
                                .signOut()
                                .then((data) {
                              Navigator.pushReplacementNamed(
                                  context, "/welcome");
                            });
                          });
                        });
                      });
                    },
                    leading: Icon(
                      Icons.lock_open,
                      size: 28,
                    ),
                    title: Text(
                      'بیرون شدن',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
