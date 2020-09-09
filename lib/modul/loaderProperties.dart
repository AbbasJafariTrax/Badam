import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget loaderProperties() {
  return ListView.builder(
    itemCount: 3,
    itemBuilder: (BuildContext context, int index) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        enabled: true,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          child: Card(
            elevation: 10,
            color: Colors.transparent,
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10),
                  width: double.infinity,
                  height: 150,
                  color: Colors.white,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 100,
                      margin: EdgeInsets.only(left: 10, right: 10, bottom: 5),
                      color: Colors.white,
                      height: 20,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 200,
                      margin: EdgeInsets.only(left: 10, right: 10),
                      color: Colors.white,
                      height: 20,
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 5),
                  height: 1,
                  decoration:
                      BoxDecoration(color: Colors.grey.withOpacity(0.5)),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(left: 10, right: 10, top: 5),
                  height: 20,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget loaderPostProperties() {
  return ListView.builder(
    itemCount: 3,
    itemBuilder: (BuildContext context, int index) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        enabled: true,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          child: Card(
            elevation: 10,
            color: Colors.transparent,
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10),
                  width: double.infinity,
                  height: 150,
                  color: Colors.white,
                ), Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 200,
                      margin: EdgeInsets.only(left: 10, right: 10),
                      color: Colors.white,
                      height: 20,
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 5),
                  height: 50,
                  decoration:
                      BoxDecoration(color: Colors.grey.withOpacity(0.5)),
                ),
               
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget loaderAgencyProperties() {
  return ListView.builder(
    itemCount: 8,
    itemBuilder: (BuildContext context, int index) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        enabled: true,
           child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(5),

          child: Card(
            elevation: 8,
            color: Colors.transparent,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                                      child: Container(
                        width: 70,
                        height: 70,
                        color: Colors.white,
                      ),
                    ),
                     new Expanded(
                          child: new Padding(
                            
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  color: Colors.white,
                                  width: 100,
                                  height: 20,
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  color: Colors.white,
                                  width: double.infinity,
                                  height: 30,
                                )
                              ],
                            ),
                          ),
                        ),
                        
                  
                  ],
                ),
                Row(
                  children: <Widget>[
                   
                     new Expanded(
                          child: new Padding(
                            
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  color: Colors.white,
                                  width: 200,
                                  height: 20,
                                )
                              ],
                            ),
                          ),
                        ),
                        new Expanded(
                          child: new Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  color: Colors.white,
                                  width: 200,
                                  height: 20,
                                )
                              ],
                            ),
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
  );

}

Widget loaderMyProperties() {
  return ListView.builder(
    itemCount: 8,
    itemBuilder: (BuildContext context, int index) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        enabled: true,
           child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(5),

          child: Card(
            elevation: 8,
            color: Colors.transparent,
            child: Row(
              children: <Widget>[
                Container(
                  width: 70,
                  height: 70,
                  color: Colors.white,
                ),
                 new Expanded(
                      child: new Padding(
                        padding: EdgeInsets.all(10.0),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              color: Colors.white,
                              width: 100,
                              height: 20,
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              color: Colors.white,
                              width: 100,
                              height: 20,
                            )
                          ],
                        ),
                      ),
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.white,
                          height: 30,
                          width: 20,
                        )
                        
                      ],
                    ),
              
              ],
            ),
          ),
        ),
     
       );
    },
  );
}


  // child: new Card(
  //         child: new Container(
  //             color: Colors.white,
  //             child: new Center(
  //               child: new Row(
  //                 children: <Widget>[
  //                   new CircleAvatar(
                      
  //                     radius: 30.0,
  //                     child: Container(
  //                       color: Colors.white,
  //                       width: 150,
  //                       alignment: Alignment.bottomLeft,
  //                       height: 150,
  //                     ),
  //                     backgroundColor: const Color(0xFF20283e),
  //                   ),
  //                   new Expanded(
  //                     child: new Padding(
  //                       padding: EdgeInsets.all(10.0),
  //                       child: new Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: <Widget>[
  //                           Container(
  //                             color: Colors.white,
  //                             width: 100,
  //                             height: 30,
  //                           ),
  //                           Container(
  //                             color: Colors.white,
  //                             width: 100,
  //                             height: 30,
  //                           )
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                   new Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: <Widget>[
                        
  //                       new IconButton(
  //                         padding: EdgeInsets.all(3),
  //                         icon: const Icon(
  //                           Icons.delete_forever,
  //                           color: Colors.white,
  //                           size: 20,
  //                         ),
  //                         onPressed: () {},
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0)),
  //       ),
     