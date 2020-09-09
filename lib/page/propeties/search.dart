import 'dart:async';

import 'package:badam_app/modul/properties.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchPage extends StatefulWidget {
  String searchQuery;

  SearchPage({this.searchQuery});

  @override
  _SearchPageState createState() =>
      _SearchPageState(searchQuery: this.searchQuery);
}

class _SearchPageState extends State<SearchPage> {
  String searchQuery;
  _SearchPageState({this.searchQuery});

  @override
  void initState() {
    super.initState();
  }

  String searchQuerySecond;
  @override
  Widget build(BuildContext context) {
    return PropertiesList(type: searchQuery);
  }
}


