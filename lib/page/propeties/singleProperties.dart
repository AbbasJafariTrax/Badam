import 'package:badam_app/modul/html_converter.dart';
import 'package:badam_app/page/propeties/showOnMap.dart';
import 'package:badam_app/style/style.dart';
import 'package:badam_app/util/httpRequest.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share/share.dart';

class SingleProperties extends StatefulWidget {
  Map<String, dynamic> pro_in;

  SingleProperties(this.pro_in);


  @override
  _SinglePropertiesState createState() => _SinglePropertiesState(this.pro_in);
}

class _SinglePropertiesState extends State<SingleProperties> {
  Map<String, dynamic> pro_in;

  _SinglePropertiesState(this.pro_in);
  
  @override
  
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> pro = pro_in;
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 25,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(pro['property_meta']['REAL_HOMES_property_id'][0]),
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 25,
                  ),
                  onPressed: () {}),
              IconButton(
                  icon: Icon(
                    Icons.share,
                    color: Colors.white,
                    size: 25,
                  ),
                  onPressed: () {
                    final RenderBox box = context.findRenderObject();
                              Share.share(pro['link'],
                                  subject: pro['title']['rendered'],
                                  sharePositionOrigin:
                                      box.localToGlobal(Offset.zero) &
                                          box.size);
                  }),
            ],
            pinned: true,
            floating: false,
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: pro['id'],
                                  child: FadeInImage.assetNetwork(
              placeholder: "assets/img/placehoder.png",
              image: pro["better_featured_image"] != null
                                  ? pro['better_featured_image']['source_url'] : "",
              fit: BoxFit.cover,
            ),
                )),
          ),
          SliverList(
            delegate: SliverChildListDelegate(<Widget>[
              Container(
                child: Column(children: <Widget>[
                  Card(
                    elevation: 5,
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 8, right: 10, left: 10),
                                    child: Text(
                                      pro['title']['rendered'],
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 3, right: 10, left: 10),
                                    child: Text(
                                      pro['property_meta']
                                              ['REAL_HOMES_property_price'][0] +
                                          " افغانی",
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 8, right: 10, left: 10),
                                    child: Text(
                                      "admin",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 3, right: 10, left: 10),
                                    child: Text(
                                      "",
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: 15, right: 15, top: 5, bottom: 5),
                            color: Colors.grey.withOpacity(0.3),
                            height: 1.5,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: getHtmlFile(pro['content']['rendered']),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, right: 8),
                        child: Text(
                          "مشخصات ملک",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Card(
                    elevation: 5,
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.only(bottom: 10),
                      child: Column(
                        children: <Widget>[
                          cityWidget(pro['property-cities-list']),
                          Container(
                              height: 1.5,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              color: Colors.grey.withOpacity(0.5)),
                          statusWidget(pro['property-statuses-list']),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0, right: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "تاریخ ساخت",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey),
                                    ),
                                    Text(
                                      "1390",
                                      // pro['property_meta'][
                                      // 'REAL_HOMES_property_year_built'],
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0, left: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      "مساحت",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey),
                                    ),
                                    Text(
                                      pro['property_meta']
                                              ['REAL_HOMES_property_size'][0] +
                                          " ",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                              height: 1.5,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              color: Colors.grey.withOpacity(0.5)),
                          // attrWidget(pro['list_name_attribute']),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, right: 8),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.location_on),
                                Text(
                                  pro['property_meta']
                                      ['REAL_HOMES_property_address'][0],
                                ),
                              ],
                            ),
                          ),
                           Container(
                              padding: EdgeInsets.all(10),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).accentColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),
                                child: FlatButton(
                                  onPressed: () {


                                    LatLng currentLocation = getCurrentLocation( pro['property_meta']
                                      ['REAL_HOMES_property_location'][0]);
                                    goToSecondScreen(
                                            context,
                                            currentLocation != null
                                                ? LatLng(
                                                    currentLocation.latitude,
                                                    currentLocation.longitude)
                                                : LatLng(34, 65));
                                       
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      FaIcon(FontAwesomeIcons.map,
                                          color: Colors.white),
                                      Expanded(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            " موقعیت در نقشه",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                        ],
                                      )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                           
                         
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, right: 8),
                        child: Text(
                          "ملک های مشابه",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  FutureBuilder(
                    future: getListPropertiesHttp("?per_page=2&exclude=" +
                        pro['id']
                            .toString()), // you should put here your method that call your web service
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        print(snapshot.data);

                        if (snapshot.data.length > 0) {
                          return Container(
                            height: 280,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                Map wp = snapshot.data[index];

                                return GestureDetector(
                                  onTap: () {
                                    print(wp['id']);
                                    Navigator.pushNamed(
                                        context,
                                        '/singleProperty/' +
                                            wp['id'].toString());
                                  },
                                  child: Container(
                                    width: 300,
                                    child: Card(
                                      elevation: 5,
                                      margin: EdgeInsets.all(10),
                                      child: Column(
                                        children: <Widget>[
                                          Stack(
                                            children: <Widget>[
                                              FadeInImage.assetNetwork(
                                                placeholder:
                                                    "assets/img/placehoder.png",
                                                image:
                                                    wp["better_featured_image"]
                                                                [
                                                                "media_details"]
                                                            ["sizes"]["medium"]
                                                        ["source_url"],
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                                height: 150,
                                              ),
                                              Positioned(
                                                left: 10,
                                                bottom: 10,
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.blue,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  50)),
                                                    ),
                                                    padding: EdgeInsets.all(10),
                                                    child: Text(
                                                      wp["property_meta"][
                                                                  "REAL_HOMES_property_price"]
                                                              [0] +
                                                          " افغانی",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    )),
                                              ),
                                              Positioned(
                                                right: 10,
                                                bottom: 10,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                50)),
                                                  ),
                                                  padding: EdgeInsets.all(10),
                                                  child: Icon(
                                                    Icons.favorite,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0,
                                                    left: 8,
                                                    right: 8),
                                                child: Text(
                                                  wp["title"]["rendered"],
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 3, right: 8),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.location_on,
                                                    color: Colors.grey,
                                                    size: 19,
                                                  ),
                                                  Text(
                                                     wp['property_meta']
                                      ['REAL_HOMES_property_address'][0],
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.grey),
                                                  ),
                                                ]),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 10, right: 10, top: 5),
                                            height: 1,
                                            decoration: BoxDecoration(
                                                color: Colors.grey
                                                    .withOpacity(0.5)),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.border_all,
                                                      color: Colors.black87,
                                                    ),
                                                    Text(
                                                      "4 Bet",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.black87),
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.border_all,
                                                      color: Colors.black87,
                                                    ),
                                                    Text(
                                                      "4 Bet",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.black87),
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.border_all,
                                                      color: Colors.black87,
                                                    ),
                                                    Text(
                                                      "4 Bet",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.black87),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          return Container(
                            height: 250,
                            child: Center(
                                child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Image.asset(
                                  "assets/img/logo-med.png",
                                  width: 200,
                                  color: Colors.grey.withOpacity(0.2),
                                ),
                                Text(
                                  "هیج ملک ثبت نیست",
                                  style: titleMedum(context),
                                ),
                              ],
                            )),
                          );
                        }
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                ]),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget attrWidget(data) {
    List dataIn = data;
    return Column(
      children: <Widget>[
        Container(
          child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: dataIn.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(dataIn[index]),
                      Icon(Icons.check, color: Colors.green, size: 25),
                    ],
                  ),
                );
              }),
        ),
      ],
    );
  }

  Widget statusWidget(pro) {
    List dataIn = pro;
    return Column(
      children: <Widget>[
        Container(
          child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(0),
              physics: NeverScrollableScrollPhysics(),
              itemCount: dataIn.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(dataIn[index]),
                      Icon(Icons.home, size: 25),
                    ],
                  ),
                );
              }),
        ),
      ],
    );
  }

  Widget cityWidget(pro) {
    List dataIn = pro;
    return Column(
      children: <Widget>[
        textMedim("موقعیت", context),
        Container(
          child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(0),
              physics: NeverScrollableScrollPhysics(),
              itemCount: dataIn.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(dataIn[index]),
                      Icon(Icons.location_city, size: 25),
                    ],
                  ),
                );
              }),
        ),
      ],
    );
  }

  LatLng getCurrentLocation(String location){

    List d = location.split(",");
    print(d);
    return LatLng(double.parse(d[0]),double.parse(d[1]));

  } 

   Future goToSecondScreen(context, LatLng location) async {
    return await Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (BuildContext context) => new ShowLocation(  
          initialLocation: location,
          ),
          fullscreenDialog: true,
        ));
  }

}
