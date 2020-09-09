import 'package:badam_app/modul/properties.dart';
import 'package:flutter/material.dart';

class ShowPropertyAgency extends StatefulWidget {
 List<String> id;

 ShowPropertyAgency(this.id);

  @override
  _ShowPropertyAgencyState createState() => _ShowPropertyAgencyState(this.id);
}

class _ShowPropertyAgencyState extends State<ShowPropertyAgency> {
  List<String> par;
  _ShowPropertyAgencyState(this.par);
 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text("لیست املاک ${this.par[1].toString()}" ),
     ),
     body: PropertiesList(
                  type:'?filter[meta_query][0][key]=REAL_HOMES_agents&filter[meta_query][0][value]='+this.par[0]
                ),
   );
 }
}