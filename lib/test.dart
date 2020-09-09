import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Test_home extends StatefulWidget {
  @override
  _Test_homeState createState() => _Test_homeState();
}

class _Test_homeState extends State<Test_home>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Tab demo"),
        // bottom: new TabBar(
        //   controller: _tabController,
        //   tabs: myTabs,
        // ),
      ),
      body: new TabBarView(controller: _tabController, children: [
        Container(
          child: Center(
            child: RaisedButton(onPressed: () {
             
            }),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.blueGrey[700],
          ),
        ),
        Container(
          child: Center(
            child: RaisedButton(onPressed: () {}),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.red[300],
          ),
        ),
      ]),
      floatingActionButton: new FloatingActionButton(
        onPressed: () => _tabController
            .animateTo((_tabController.index + 1) % 2), // Switch tabs
        child: new Icon(Icons.swap_horiz),
      ),
    );
  }
}
