import 'dart:io';
import 'package:badam_app/modul/GoogleMapListProperties.dart';
import 'package:badam_app/modul/SearchDialog.dart';
import 'package:badam_app/modul/propertiesList.dart';
import 'package:badam_app/util/feature_property.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _typeListViewState = 0;

  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: FlatButton(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.arrow_drop_down),
              Text(
                'خرید',
              ),
            ],
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FeatureProperty()),
            ).then((data) {
              print(data);
            });
          },
        ),
        //  Navigator.pushNamed(widget.ctx, "/")),
      ),
      body: Column(
        children: <Widget>[
          new Card(
            elevation: 5,
            child: new ListTile(
              contentPadding:
                  EdgeInsets.only(top: 0, left: 0, right: 10, bottom: 0),
              onTap: () {},
              leading: const Icon(Icons.search),
              title: Row(
                children: <Widget>[
                  Expanded(
                      child: Text(
                    'جستجو ولایت ، شهر ، محل ...',
                  )),
                ],
              ),
              trailing: FlatButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) => FiltersScreen() ),);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.filter_list),
                      Text("فلتر"),
                    ],
                  )),
            ),
          ),
          Expanded(
            child: new TabBarView(
                controller: _tabController,
                children: <Widget>[
                  PropertiesListHome(),
                  GoogleMapListProperties()
                ]),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            _typeListViewState == 1
                ? _typeListViewState = 0
                : _typeListViewState = 1;
            _tabController.animateTo(
              _typeListViewState,
            );
          });
        },
        backgroundColor: Colors.white,
        splashColor: Colors.white,
        label: _typeListViewState == 1
            ? Row(
                children: <Widget>[
                  Icon(
                    Icons.map,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "نقشه",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ],
              )
            : Row(
                children: <Widget>[
                  Icon(
                    Icons.format_list_numbered,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "لیست",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ],
              ),
      ),
    );
  }
  // Widget googleMapWidget() {
  //   // print(currentLocation.latitude.toString()+" , "+currentLocation.longitude.toString());
  //   return GoogleMap(
  //     myLocationButtonEnabled: true,
  //     buildingsEnabled: true,
  //     myLocationEnabled: true,
  //     initialCameraPosition: CameraPosition(
  //       target: currentLocation != null ? currentLocation : LatLng(34.0, 62.0),
  //       zoom: 10.0,
  //     ),
  //   );
  // }
}
