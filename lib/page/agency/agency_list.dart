import 'package:badam_app/modul/html_converter.dart';
import 'package:badam_app/modul/loaderProperties.dart';
import 'package:badam_app/util/httpRequest.dart';
import 'package:flutter/material.dart';

class AgencyList extends StatefulWidget {
  @override
  _AgencyListState createState() => _AgencyListState();
}

class _AgencyListState extends State<AgencyList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("لیست مشاوران املاک"),
      ),
      body: FutureBuilder(
        future: getAllAgenceHttp(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              padding: EdgeInsets.only(top: 5, bottom: 10),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Map<String, dynamic> currentAgent = snapshot.data[index];
                print(currentAgent['id']);
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  child: GestureDetector(
                    onTap: () {},
                    child: Card(
                      elevation: 5,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(40.0),
                                    child: FadeInImage.assetNetwork(
                                      // image: "",
                                      image: currentAgent['better_featured_image']['source_url'],
                                      placeholder: "assets/img/placehoder.png",
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      alignment: Alignment.topRight,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          currentAgent['title']['rendered'],
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              wordSpacing: 0.5),
                                        ),
                                      getHtmlFile(currentAgent['excerpt']['rendered'])
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 8, bottom: 8),
                                child: Text(
                                  "ملک های قابل دسترس : ",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, bottom: 8),
                                child: Text(
                                  currentAgent['property-count'].toString(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      right: BorderSide(
                                        color: Colors.grey.withOpacity(0.5),
                                        width: 1,
                                      ),
                                      top: BorderSide(
                                        color: Colors.grey.withOpacity(0.5),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: FlatButton(
                                    onPressed: () {
                                      
                                      List<String> d = new List();
                                      d.add(currentAgent['id'].toString());
                                      d.add(currentAgent['title']['rendered']);

                                      Navigator.pushNamed(context, "/agencyPropertiesList",arguments: d);
                                      
                                    },
                                    child: Text(
                                      "نمایش املاک",
                                      style: TextStyle(
                                        color: Colors.blue
                                            .withGreen(100)
                                            .withBlue(240)
                                            .withRed(1),
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      right: BorderSide(
                                        color: Colors.grey.withOpacity(0.5),
                                        width: 1,
                                      ),
                                      top: BorderSide(
                                        color: Colors.grey.withOpacity(0.5),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: FlatButton(
                                    onPressed: () {
                                     
                                      Map<String, dynamic> agent = currentAgent;
                                      Navigator.pushNamed(context, "/singleAgent",arguments: agent);
                                      
                                    },
                                    child: Text(
                                      "نمایش پروفایل",
                                      style: TextStyle(
                                        
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return loaderAgencyProperties();
          }
        },
      ),
    );
  }
}
