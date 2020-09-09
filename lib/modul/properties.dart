import 'package:badam_app/util/httpRequest.dart';
import 'package:flutter/material.dart';
import 'package:loadmore/loadmore.dart';

class PropertiesList extends StatefulWidget {
  String type;
  PropertiesList({this.type = ""});
  @override
  _PropertiesListState createState() => _PropertiesListState(typeIn: this.type);
}

class _PropertiesListState extends State<PropertiesList> {
  String typeIn;

  _PropertiesListState({this.typeIn});

  int paginate = 1;
  String getPara() {
    if (typeIn != null && typeIn != "") {
      return typeIn + "&per_page=5&page=" + paginate.toString();
    } else {
      return "?per_page=5&page=" + paginate.toString();
    }
  }

  bool _isLoading = false;

  List listdata = new List();

  Future<bool> _loadMore() async {
    if (_isLoading == false) {
      _isLoading = true;
      paginate++;
      getListPropertiesHttp(getPara()).then((datain) {
        print(getPara());
        setState(() {
          listdata.addAll(datain);
          _isLoading = false;
        });
      });
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: // you should put here your method that call your web service
        LoadMore(
                onLoadMore: _loadMore,
                child: ListView.builder(
                 
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                

                    return GestureDetector(
                      onTap: () {
                        
                      
                      },
                      child: Container(
                        width: double.infinity,
                        child: Card(
                          elevation: 5,
                          margin: EdgeInsets.all(10),
                          child: Column(
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  Hero(
                                    tag: 10,
                                    child: FadeInImage.assetNetwork(
                                      placeholder: "assets/img/placehoder.png",
                                      image: "https://www.google.com/imgres?imgurl=https%3A%2F%2Fmiro.medium.com%2Fmax%2F1200%2F1*D6Kwcvd_dfP43oaCPWH3Ew.jpeg&imgrefurl=https%3A%2F%2Fmedium.com%2F%40wnsfernando95%2Fhide-or-show-floating-button-on-scroll-in-flutter-636d660ff9fb&tbnid=5rwY_ScQpBt8SM&vet=12ahUKEwjv3MjG1drqAhVT0oUKHeGRCyYQMygDegUIARCeAQ..i&docid=VgI87p2n6MgegM&w=1200&h=600&q=how%20hide%20after%20scrolling%20and%20change%20to%20float%20button%20flutter&safe=strict&ved=2ahUKEwjv3MjG1drqAhVT0oUKHeGRCyYQMygDegUIARCeAQ",
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      height: 150,
                                    ),
                                  ),
                                  Positioned(
                                    left: 10,
                                    bottom: 10,
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50)),
                                        ),
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          "1000",
                                          style: TextStyle(color: Colors.white),
                                        )),
                                  ),
                                  Positioned(
                                    right: 10,
                                    bottom: 10,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50)),
                                      ),
                                      padding: EdgeInsets.all(10),
                                      child: IconButton(
                                        icon: Icon(Icons.favorite),
                                        onPressed: () => {},
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0, left: 8, right: 8),
                                    child: Text(
                                      "title",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 3, right: 8),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.location_on,
                                        color: Colors.grey,
                                        size: 19,
                                      ),
                                      Text(
                                        "Herat Afghanistan",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey),
                                      ),
                                    ]),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 10, right: 10, top: 5),
                                height: 1,
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.5)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                          style:
                                              TextStyle(color: Colors.black87),
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
                                          style:
                                              TextStyle(color: Colors.black87),
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
                                          style:
                                              TextStyle(color: Colors.black87),
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
              ),
    );
  }
}
