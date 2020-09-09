import 'package:badam_app/modul/html_converter.dart';
import 'package:badam_app/modul/loaderProperties.dart';
import 'package:badam_app/style/style.dart';
import 'package:badam_app/util/httpRequest.dart';
import 'package:flutter/material.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  ScrollController _scrollController = new ScrollController();

  int paginate = 1;

  String getPara() {
    return "?per_page=5&page=" + paginate.toString();
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getPostsHttp(),
      // you should put here your method that call your web service
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List listdata = snapshot.data;

          if (snapshot.data.length > 0) {
            return Column(
              children: <Widget>[
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (!_isLoading &&
                          scrollInfo.metrics.pixels ==
                              scrollInfo.metrics.maxScrollExtent) {
                        setState(() {
                          _isLoading = true;
                          ++paginate;
                        });

                        getListPropertiesHttp(getPara()).then((datain) {
                          setState(() {
                            _isLoading = false;
                            listdata.addAll(datain);
                          });
                        });
                      }
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: listdata.length,
                      itemBuilder: (BuildContext context, int index) {
                        Map wp = listdata[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/singlePost',
                                arguments: wp);
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
                                        tag: wp['id'],
                                        child: FadeInImage.assetNetwork(
                                          placeholder:
                                              "assets/img/placehoder.png",
                                          image: wp["better_featured_image"]
                                                  ["media_details"]["sizes"]
                                              ["medium"]["source_url"],
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          height: 150,
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
                                            top: 8.0, left: 8, right: 8),
                                        child: Text(
                                          wp["title"]["rendered"],
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 10, right: 10, top: 5),
                                    height: 1,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.5)),
                                  ),
                                  getHtmlFile(wp['excerpt']['rendered']),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset(
                  "assets/img/logo-med.png",
                  width: 200,
                  color: Colors.grey.withOpacity(0.2),
                ),
                Text(
                  "هیج پست ثبت نیست",
                  style: titleMedum(context),
                ),
              ],
            ));
          }
        }
        return loaderPostProperties();
      },
    );
  }
}
