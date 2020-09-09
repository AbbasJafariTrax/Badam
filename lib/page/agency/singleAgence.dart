import 'package:badam_app/modul/html_converter.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SingleAgence extends StatefulWidget {
  Map<String, dynamic> agency;
  SingleAgence(this.agency);
  @override
  _SingleAgenceState createState() => _SingleAgenceState(this.agency);
}

class _SingleAgenceState extends State<SingleAgence> {
  Map<String, dynamic> agency;
  _SingleAgenceState(this.agency);

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    print(agency);
    return Scaffold(
      appBar: AppBar(
        title: Text("جزییات نماینده"),
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).primaryColor,
        child: Row(
          children: <Widget>[
            Expanded(
              child: FlatButton(
                onPressed: () {
                  _launchURL("tel:"+agency['agent_meta']['REAL_HOMES_mobile_number'][0]);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FaIcon(
                      FontAwesomeIcons.phone,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "تماس",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: FlatButton(
                onPressed: () {
                  _launchURL("sms:"+agency['agent_meta']['REAL_HOMES_mobile_number'][0]);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FaIcon(
                      FontAwesomeIcons.facebookMessenger,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "ارسال پیام",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: FlatButton(
                onPressed: () {
                  
                  _launchURL(
                      'mailto:'+agency['agent_meta']['REAL_HOMES_agent_email'][0]+'?subject=مشاور املاک&body=');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FaIcon(
                      FontAwesomeIcons.envelope,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "ارسال ایمیل",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              child: Card(
                elevation: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100.0),
                              child: FadeInImage.assetNetwork(
                                height: 150,
                                width: 150,
                                image: agency['better_featured_image']
                                    ['source_url'],
                                placeholder: "assets/img/placehoder.png",
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              agency["title"]['rendered'],
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  wordSpacing: 0.5),
                            ),
                          )
                        ],
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            // print(agency['agent_meta']['REAL_HOMES_office_number'][0]);

                            FlatButton(
                                onPressed: () => _launchURL(agency['agent_meta']
                                    ['REAL_HOMES_facebook_url'][0]),
                                child: FaIcon(FontAwesomeIcons.facebook)),
                            FlatButton(
                              onPressed: () => _launchURL(agency['agent_meta']
                                  ['REAL_HOMES_telegram_url'][0]),
                              child: FaIcon(FontAwesomeIcons.telegram),
                            ),
                            FlatButton(
                              onPressed: () => _launchURL(agency['agent_meta']
                                  ['REAL_HOMES_instagram_url'][0]),
                              child: FaIcon(FontAwesomeIcons.instagram),
                            )
                          ],
                        ),
                        ListTile(
                          leading: Text("آدرس: "),
                          title: Text(agency['agent_meta']
                              ['inspiry_office_address'][0]),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          border: Border.all(
                              color: Colors.grey.withOpacity(0.5), width: 1)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "ملک های قابل دسترس :",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            agency["property-count"].toString(),
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
                        right: 10,
                      ),
                      child: Text(
                        "درباره ما",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                          left: 10.0,
                          right: 10,
                          bottom: 10,
                        ),
                        child: getHtmlFile(agency['content']['rendered']))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
