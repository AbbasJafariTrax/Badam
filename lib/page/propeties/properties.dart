import 'package:badam_app/modul/properties.dart';
import 'package:flutter/material.dart';

class AllProperties extends StatefulWidget {
  @override
  _AllPropertiesState createState() => _AllPropertiesState();
}

class _AllPropertiesState extends State<AllProperties>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 8, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          TabBar(
            unselectedLabelColor: Colors.grey,
            indicatorColor: Theme.of(context).primaryColor,
            controller: _tabController,
            labelColor: Theme.of(context).primaryColor,
            isScrollable: true,
            tabs: [
              Tab(
                child: Text(
                  "همه",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.8),
                ),
              ),
               Tab(
                child: Text(
                  "زمین",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.8),
                ),
              ),
              Tab(
                child: Text(
                  "خانه",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.8),
                ),
              ),
              Tab(
                child: Text(
                  "واحد",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.8),
                ),
              ),
              Tab(
                child: Text(
                  "ارپاتمان ",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.8),
                ),
              ),
              Tab(
                child: Text(
                  "دوکان ",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.8),
                ),
              ),
              Tab(
                child: Text(
                  "دفتر ",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.8),
                ),
              ),
              
             
              Tab(
                child: Text(
                  "ویلا",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.8),
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.topCenter,
            height: MediaQuery.of(context).size.height - 130,
            child: TabBarView(
              controller: _tabController,
              children: [
                PropertiesList(type: ""),
                PropertiesList(
                  type:'?property-types=65'
                ),
                PropertiesList(
                  type: "?property-types=67",
                ),
                PropertiesList(
                  type: "?property-types=47",
                ),
                PropertiesList(
                  type: "?property-types=48",
                ),
                PropertiesList(
                  type: "?property-types=43",
                ),
                PropertiesList(
                  type: "?property-types=40",
                ),
                PropertiesList(
                  type: "?property-types=46",
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
