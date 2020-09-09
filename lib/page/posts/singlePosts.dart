import 'package:badam_app/modul/html_converter.dart';
import 'package:badam_app/style/style.dart';
import 'package:badam_app/util/httpRequest.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class SinglePost extends StatefulWidget {
  Map<String, dynamic> pro_in;

  SinglePost(this.pro_in);


  @override
  _SinglePostState createState() => _SinglePostState(this.pro_in);
}

class _SinglePostState extends State<SinglePost> {
  Map<String, dynamic> pro_in;

  _SinglePostState(this.pro_in);
  
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
            ), actions: <Widget>[
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
                  ),Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, right: 8),
                        child: Text(
                          "پست های مشابه",
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
                    future: getPostsHttp(type : "?per_page=2&exclude=" + pro['id'].toString()),
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
                                     Navigator.pushNamed(context, '/singlePost',
                                    arguments: wp);
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
                                              ),],
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

}
