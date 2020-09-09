import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:badam_app/modul/loaderProperties.dart';
import 'package:badam_app/style/style.dart';
import 'package:badam_app/util/httpRequest.dart';
import 'package:badam_app/util/sharedPreference.dart';
import 'package:badam_app/util/utiles_functions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class MyListProperties extends StatefulWidget {
  final String id;
  MyListProperties(this.id);
  @override
  _MyListPropertiesState createState() => new _MyListPropertiesState(this.id);
}

class _MyListPropertiesState extends State<MyListProperties> {
  final String id;
  _MyListPropertiesState(this.id);

  Widget _buildTitle(BuildContext context) {
    print(this.id);

    var horizontalTitleAlignment =
        Platform.isIOS ? CrossAxisAlignment.center : CrossAxisAlignment.center;

    return new InkWell(
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: horizontalTitleAlignment,
          children: <Widget>[
            new Text(
              'املاک من',
              style: new TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildActions() {
    return <Widget>[
      new IconButton(
        icon: Row(children: <Widget>[
          FaIcon(FontAwesomeIcons.plus),
          
        ],),
        onPressed: () => Navigator.pushNamed(context, "/addPropery"),
      ),
      
    ];
  }
  

  var refreshkey = GlobalKey<RefreshIndicatorState>();

  Future<Null> refreshlist() async {

    refreshkey.currentState?.show(atTop:true);
    await Future.delayed(Duration(seconds: 2)); //wait here for 2 second
    setState(() {

    });

  }
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: _buildTitle(context),
        actions: _buildActions(),
      ),
      body:  RefreshIndicator(
        key: refreshkey,
        onRefresh: refreshlist,
        child: FutureBuilder(
          future: getMyDataList(this.id),
          builder: (context, snapshot) {
            var data = snapshot.data;
            
            return snapshot.hasData
                ?  MyListPropertiesWidget(data)
                : loaderMyProperties();
          },
        ),
      ),
    );
  }

  Widget MyListPropertiesWidget(List data) {

    

    return data.length > 0 ? new ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index) {
          Map mylist = data[index];


          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/singleProperty',
                arguments: mylist),
            child: new Card(
              child: new Container(
                  child: new Center(
                    child: new Row(
                      children: <Widget>[
                        new CircleAvatar(
                          radius: 30.0,
                          child: Hero(
                            tag:mylist['id'] ,
                                                      child: FadeInImage.assetNetwork(
                              placeholder: "assets/img/placehoder.png",
                              image: mylist["better_featured_image"] != null
                                  ? mylist["better_featured_image"]
                                          ["media_details"]["sizes"]["medium"]
                                      ["source_url"]
                                  : "",
                              width: 150,
                              alignment: Alignment.bottomLeft,
                              fit: BoxFit.fitHeight,
                              height: 150,
                            ),
                          ),
                          backgroundColor: const Color(0xFF20283e),
                        ),
                        new Expanded(
                          child: new Padding(
                            padding: EdgeInsets.all(10.0),
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text(
                                  mylist['title']['rendered'],
                                  // set some style to text
                                  style: new TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                                new Text(
                                  mylist['property_meta']
                                      ['REAL_HOMES_property_id'][0],
                                  // set some style to text
                                  style: new TextStyle(
                                    fontSize: 15.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new IconButton(
                              padding: EdgeInsets.all(3),
                              icon: const Icon(
                                Icons.delete,
                                color: const Color(0xFF167F67),
                                size: 25,
                              ),
                              onPressed: () {
                                Alert(
                                  context: context,
                                  type: AlertType.warning,
                                  title: "حذف کردن !",
                                  desc: "آیا مطمین استن که ملک را حذف شود.",
                                  buttons: [
                                    DialogButton(
                                      child: Text(
                                        "بله",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () {
                                     
                                        Navigator.pop(context);
                                        deleteProperty(mylist['id']).then((data){
                                          if(data != null){
                                             
                                               _isLoading = false;
                                              refreshlist();
                                            
                                          }
                                        });
                                      },
                                      color: Color.fromRGBO(0, 179, 134, 1.0),
                                    ),
                                    DialogButton(
                                      child: Text(
                                        "نخیر",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                      color: Colors.redAccent,
                                    )
                                  ],
                                ).show();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0)),
            ),
          );
        }) :   Center(child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset("assets/img/logo-med.png",width: 200,color: Colors.grey.withOpacity(0.2),),
                Text("هیج ملک از شما ثبت نیست",style: titleMedum(context),),
              ],
            ));
  }

  Future deleteProperty(id) {
    readPreferenceString("username").then((username) {
      readPreferenceString("password").then((password) {
        getToken(getPhoneforuser(username), password).then((value) {
          Map<String, dynamic> tokens = json.decode(value.body);
          String token = tokens['token'];
          return Future.value(deletePropertyServer(token, id));
        });
      });
    });
  }
}
