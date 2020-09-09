import 'package:badam_app/modul/bottom_nav/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../strings.dart';
import '../test_login_page.dart';
import 'agency/agency_list.dart';
import 'home.dart';
import 'myProperties/addpropertise.dart';

class Dashboard extends StatefulWidget {
 
  int currentIndexTab = 3;
  Dashboard({Key key, this.currentIndexTab = 3})
      : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    final List<Widget> _children = [
      Test_Login_page(),
      AddPropertise(),
      AgencyList(),
      HomePage(),
    ];


    return Scaffold(
     
      body: _children[widget.currentIndexTab],
      bottomNavigationBar: FancyBottomNavigation(
        activeIconColor: Colors.white,
        circleColor: Theme.of(context).primaryColor,
        textColor: Theme.of(context).primaryColor,
        barBackgroundColor: Colors.white,
        inactiveIconColor: Theme.of(context).primaryColor,
        tabs: [
          TabData(iconData: FontAwesomeIcons.user, title: PROFILE),
          TabData(
              iconData: FontAwesomeIcons.plusSquare, title: SUBMIT_PROPERTY),
          TabData(iconData: FontAwesomeIcons.users, title: AGENCIES),
          TabData(iconData: FontAwesomeIcons.searchLocation, title: SEARCH),
        ],
        onTabChangedListener: (position) {
          setState(() {
            widget.currentIndexTab = position;
          });
        },
      ),
      // drawer: AppDrawer()
    );
  }
}
