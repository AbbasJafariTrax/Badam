import 'package:badam_app/apiReqeust/constants.dart';
import 'package:badam_app/apiReqeust/flutter_wordpress.dart';
import 'package:badam_app/apiReqeust/requests/params_post_list.dart';
import 'package:badam_app/model/Image.dart';
import 'package:badam_app/model/property.dart';
import 'package:badam_app/provider/property_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jiffy/jiffy.dart';
import 'package:loadmore/loadmore.dart';
import 'package:provider/provider.dart';

class PropertiesListHome extends StatefulWidget {
  @override
  _PropertiesListHomeState createState() => _PropertiesListHomeState();
}

class _PropertiesListHomeState extends State<PropertiesListHome> {
  ScrollController _hideButtonController;

  bool _isFilterButtonVisible = false;

  @override
  void initState() {
    super.initState();
    // await Jiffy.locale("fa");
    _hideButtonController = new ScrollController();
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isFilterButtonVisible == false) {
          print(
              "**** ${_isFilterButtonVisible} up"); //Move IO away from setState
          setState(() {
            _isFilterButtonVisible = true;
          });
        }
      } else {
        if (_hideButtonController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (_isFilterButtonVisible == true) {
            /* only set when the previous state is false
               * Less widget rebuilds 
               */
            print(
                "**** ${_isFilterButtonVisible} down"); //Move IO away from setState
            setState(() {
              _isFilterButtonVisible = false;
            });
          }
        }
      }
    });
  }

  WordPress db = new WordPress();
  bool _isActiveGoogleMapList = false;

  Future<void> _refresh() async {
    setState(() {});
  }

  Map headers = {};

  Future<bool> _loadMore() async {
    load();
    return true;
  }

  void load() {
    PropertyProvider()
        .fetchPosts(
      postParams: ParamsPostList(
        context: WordPressContext.view,
        pageNum: 1,
        perPage: 24,
        order: Order.desc,
        orderBy: PostOrderBy.date,
      ),
    )
        .then((data) {
      print(data);
      // setState(() {
      //   properties.addAll(data[0]);
      //   headers = data[1];
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: SingleChildScrollView(
        controller: _hideButtonController,
        child: FutureBuilder(
          future: PropertyProvider().fetchPosts(
            postParams: ParamsPostList(
              context: WordPressContext.view,
              pageNum: 1,
              perPage: 24,
              order: Order.desc,
              orderBy: PostOrderBy.date,
            ),
          ),
          builder: (BuildContext context, AsyncSnapshot snapshot) {


            if (snapshot.hasData) {

              List properties = snapshot.data;
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("30 ملک",
                            style: TextStyle(fontSize: 20)),
                        FlatButton(
                          onPressed: () {},
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.filter_list),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "دسته بندی",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  MyListPropertiesWidget(properties)
                ],
              );
            } else {
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              );
            }
          },
          // );
          // },
        ),
      ),
    );
  }

  Widget MyListPropertiesWidget(List data) {
    return data.length > 0
        ? new ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: data == null ? 0 : data.length,
            itemBuilder: (BuildContext context, int index) {

              Property mylist = data[index];
              List<ImageProperty> image = mylist.gallary;

              return GestureDetector(
                onTap: () => null,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Container(
                        child: new Center(
                          child: new Row(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Stack(
                                  children: <Widget>[
                                    FadeInImage.assetNetwork(
                                      placeholder: "assets/img/placehoder.png",
                                      image: image.length > 0
                                          ? image[0].sourceUrl
                                          : "",
                                      width:
                                          (MediaQuery.of(context).size.width /
                                                  2) -
                                              30,
                                      height: 115,
                                      alignment: Alignment.bottomLeft,
                                      fit: BoxFit.fitHeight,
                                    ),
                                    Positioned(
                                      child: Container(
                                        alignment: Alignment.center,
                                        color: Colors.yellow[700],
                                        width: 35,
                                        height: 20,
                                        child: Text(
                                          mylist.type,
                                          style: TextStyle(
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              new Expanded(
                                child: new Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: new Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                new Text(
                                                  mylist.title.rendered,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  // set some style to text
                                                  style: new TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                new Text(
                                                  mylist.types,
                                                  // set some style to text
                                                  style: new TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                new Text(
                                                  mylist.city +
                                                      " " +
                                                      mylist.state,
                                                  // set some style to text
                                                  style: new TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                              icon: FaIcon(
                                                  FontAwesomeIcons.heart),
                                              onPressed: null)
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(mylist.area + " متر"),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text("ساخت " +
                                              mylist.buildYear.toString()),
                                          SizedBox(
                                            width: 10,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        Jiffy(mylist.date).fromNow(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0)),
                    Divider(),
                  ],
                ),
              );
            })
        : Center(
            child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                "assets/img/logo-med.png",
                width: 200,
                color: Colors.grey.withOpacity(0.2),
              ),
              Text(
                "هیج ملک از شما ثبت نیست",
              ),
            ],
          ));
  }
}

//  new Visibility(
//                   visible: _isFilterButtonVisible,
//                   child: Container(
//                     child: RaisedButton(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(18.0),
//                       ),
//                       color: Colors.white,
//                       padding: EdgeInsets.all(8),
//                       onPressed: () {},
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: <Widget>[
//                           Icon(Icons.filter_list),
//                           SizedBox(
//                             width: 5,
//                           ),
//                           Text(
//                             "دسته بندی",
//                             style: TextStyle(
//                                 fontSize: 18, fontWeight: FontWeight.w400),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
