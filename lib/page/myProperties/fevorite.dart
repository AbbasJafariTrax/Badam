import 'package:badam_app/modul/properties.dart';
import 'package:badam_app/util/sharedPreference.dart';
import 'package:flutter/material.dart';

class FevoritePage extends StatefulWidget {



  @override
  _FevoritePageState createState() => _FevoritePageState();
}

class _FevoritePageState extends State<FevoritePage> {

  String userId="";
  Future getUsername() async {
    try {

      List responses = await Future.wait([
       
        readPreferenceString("userId").then((userId) {
          
          if (userId != null) {
             print("userId : "+userId);
            this.userId = userId;
          }
        }),

      ]);
       
    } catch (e) {
      print("error");
    }
  }

  @override
  void initState() {
    
    getUsername();
    super.initState();
  }

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text("لیست علاقه مندان"),
     ),
     body: PropertiesList(type : "?favoriteList['user_id']="+this.userId),
   );
 }
}