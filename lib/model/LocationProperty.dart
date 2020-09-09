import 'dart:convert';

import 'package:flutter/material.dart';



class LocationProperty {
  String json;
  LocationProperty({@required this.json});

  List jsonToList() {
    return jsonDecode(json);
  }

  double getLat() {
   
    print(jsonToList());
     return 9;
  }
}
