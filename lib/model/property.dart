import 'dart:convert';

import 'package:badam_app/apiReqeust/constants.dart';
import 'package:badam_app/apiReqeust/schemas/content.dart';
import 'package:badam_app/apiReqeust/schemas/title.dart';

import 'Image.dart';
import 'user.dart';
import 'package:meta/meta.dart';

class Property {
  /// ID of the post
  int id;
  String date;
  String slug;
  PostPageStatus status;
  String type;
  String link;
  Title title;
  Content content;
  int authorID;
  int featuredMediaID;

  String price;
  String area;
  String address;
  String areaPrefix;
  String propertyId;
  // double lat;
  // double lon;
  // List featured;
  List<ImageProperty> gallary;
  // String cities;
  List attribute;
  String types;
  String state;
  String statusProperty;
  String city;
  String buildYear;
  // String featureId;

  Property({
    this.date,
    this.slug,
    this.status = PostPageStatus.publish,
    @required String title,
    @required String content,
    @required this.authorID,
    this.featuredMediaID,
  })  : this.title = new Title(rendered: title),
        this.content = new Content(rendered: content);

  Property.fromJson(Map<String, dynamic> json) {
    // print(json['property_meta']['real_estate_property_address'][0]);

    id = json['id'];

    date = json['date'].toString();

    attribute = json['property_feature'];

    types = json['property_types'].toString();
    state = json['property_state'].toString();
    statusProperty = json['property_status'];
    city = json['property_city'];

    slug = json['slug'].toString();

    if (json['status'] != null) {
      PostPageStatus.values.forEach((val) {
        if (enumStringToName(val.toString()) == json['status']) {
          status = val;
          return;
        }
      });
    }

    type = json['type'];
    link = json['link'];
    title = json['title'] != null ? new Title.fromJson(json['title']) : null;
    content =
        json['content'] != null ? new Content.fromJson(json['content']) : null;

    authorID = json['author'];
    featuredMediaID = json['featured_media'];

    area = json['property_meta']['real_estate_property_size'][0] != null
        ? json['property_meta']['real_estate_property_size'][0]
        : null;

    buildYear = json['property_meta']['real_estate_property_year'][0] != null
        ? json['property_meta']['real_estate_property_year'][0].toString()
        : null;

    address = json['property_meta']['real_estate_property_address'] != null
        ? json['property_meta']['real_estate_property_address'][0]
        : null;

    price = json['property_meta']['real_estate_property_price'] != null
        ? json['property_meta']['real_estate_property_price'][0]
        : null;
    propertyId = json['property_meta']['real_estate_property_identity'] != null
        ? json['property_meta']['real_estate_property_identity'][0]
        : null;
    areaPrefix = "متر";

    // gallary = json['property_image'];
    List items = json['property_image'];

    List<ImageProperty> gal = List<ImageProperty>();
    if (items != null) {

      for (var i = 0; i < items.length; i++) {
        gal.add(
          ImageProperty(
            id: int.parse(items[i]['id']),
            mediaType: items[i]['media_type'],
            sourceUrl: items[i]['source_url'],
          ),
        );
      }

     
    }
    gallary = gal;
    // prin
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.date != null) data['date'] = this.date;

    if (this.slug != null) data['slug'] = this.slug;
    if (this.status != null)
      data['status'] = enumStringToName(this.status.toString());
    if (this.title != null) data['title'] = this.title.rendered;
    if (this.content != null) data['content'] = this.content.rendered;

    if (this.authorID != null) data['author'] = this.authorID.toString();
    if (this.featuredMediaID != null)
      data['featured_media'] = this.featuredMediaID.toString();

    return data;
  }

  // @override
  // String toString() {
  //   return 'Post: { id: $id, title: ${title.rendered}, '
  //       'author: {id: $authorID, name: ${author.name}}}';
  // }
}

// class Property {
//   String id;
//   String date;
//   String title;
//   String content;
//   String price;
//   String area;
//   String yearBulid;
//   String address;
//   String areaPrefix;
//   double lat;
//   double lon;
//   String propertyId;
//   String status;
//   List featured;
//   List gallary;
//   String cities;
//   List attribute;
//   String types;
//   String featureId;

//   Property({
//     this.featureId,
//     this.id,
//     this.status,
//     this.yearBulid,
//     this.areaPrefix,
//     this.propertyId,
//     this.featured,
//     this.date,
//     this.lon,
//     this.lat,
//     this.gallary,
//     this.title,
//     this.content,
//     this.price,
//     this.area,
//     this.address,
//     this.cities,
//     this.attribute,
//     this.types,
//   });

// }
