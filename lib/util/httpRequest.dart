import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:badam_app/model/property.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';

import 'package:http_parser/http_parser.dart';

final mainUrlSite = 'http://172.16.1.180/sanhome/';

Future<void> loginUserDB(username, password) async {
  await http
      .post(mainUrlSite + "wp-json/badam/v1/login", body: {
        "username": username,
        "password": password,
      })
      .then((data) {})
      .catchError(
        (error) {
          print(error);
        },
      );
}

Future registerUserDB(phone, name, password, fbUserId) async {
  return await http.post(mainUrlSite + "wp-json/badam/v1/register", body: {
    "phone": phone,
    "name": name,
    "password": password,
    "fb_user_id": fbUserId,
  });
}

Future userAlreadyRegisterd(username) async {
  return await http.post(
      mainUrlSite + "wp-json/badam/v1/isUserRegisterd?username=admin",
      body: {
        "username": username,
      }).timeout(Duration(seconds: 30));
}

Future<bool> resetPassword(username, password) async {
  await http.post(mainUrlSite + "wp-json/badam/v1/passwordReset", body: {
    "username": username,
    "password": password,
  }).then((data) {
    return Future.value(data);
  });
  return Future.value(false);
}

Future getToken(username, password) async {
  return await http.post(mainUrlSite + "wp-json/jwt-auth/v1/token/", body: {
    "username": username,
    "password": password,
  });
}

Future getPostsHttp({String type = ""}) async {
  try {
    print(type);
    final reponse = await http.get(mainUrlSite + "wp-json/wp/v2/posts" + type,
        headers: {"Accept": "application/json"});

    return json.decode(reponse.body);
  } catch (error) {
    print(error);
  }
}

Future getListPropertiesHttp(String type) async {
  try {
    print(type);
    final reponse = await http.get(
        mainUrlSite + "wp-json/wp/v2/properties" + type,
        headers: {"Accept": "application/json"});

    print(reponse.body);
    return json.decode(reponse.body);
  } catch (error) {
    print(error);
  }
}

Future getMainSlider() async {
  try {
    final reponse = await http.get(mainUrlSite + "wp-json/wp/v2/slide",
        headers: {"Accept": "application/json"});

    return json.decode(reponse.body);
  } catch (error) {
    print(error);
  }
}

Future getMyDataList(String userId) async {
  try {
    final reponse = await http.get(
        mainUrlSite + "wp-json/wp/v2/properties?author=" + userId,
        headers: {"Accept": "application/json"}).timeout(Duration(seconds: 10));

    return json.decode(reponse.body);
  } catch (error) {
    print(error);
  }
}

Future getMeta(id, metaKey) async {
  try {
    final reponse = await http.get(
        mainUrlSite +
            "/wp-json/badam/v1/getMeta?post_id" +
            id +
            "?meta_key=" +
            metaKey,
        headers: {"Accept": "application/json"});

    return json.decode(reponse.body);
  } catch (error) {
    print(error);
  }
}

// Future getAttrubitHttp(id) async {
//   List featureName;

//   for (var item in id) {
//     try {

//        await http.get(
//           mainUrlSite + "wp-json/wp/v2/property-features/" + item.toString(),
//           headers: {"Accept": "application/json"}).then((data){

//               print(json.decode(data.body)['name']);
//               featureName.add(json.decode(data.body)['name']);
//           });

//     } catch (error) {

//       print(error);

//     }
//   }
//   return Future.value(featureName);
// }

Future getPropertieHttp(id) async {
  try {
    final reponse = await http.get(
        mainUrlSite + "wp-json/wp/v2/properties/" + id,
        headers: {"Accept": "application/json"});

    return json.decode(reponse.body);
  } catch (error) {
    print(error);
  }
}

Future sendProperty(Property property) async {
  Timer(Duration(seconds: 2), () {
    return Future.value(true);
  });
  // try {
  //   final reponse = await http.get(
  //       mainUrlSite + "wp-json/wp/v2/properties/" + id,
  //       headers: {"Accept": "application/json"});

  //   return json.decode(reponse.body);
  // } catch (error) {
  //   print(error);
  // }
}

Future getAllAgenceHttp() async {
  try {
    final reponse = await http.get(mainUrlSite + "wp-json/wp/v2/agents",
        headers: {"Accept": "application/json"});

    return json.decode(reponse.body);
  } catch (error) {
    print(error);
  }
}

Future getSmilerPropertiesHttp(id) async {
  try {
    final reponse = await http.get(
      mainUrlSite +
          "wp-json/badam/v1/similerProperties?post_id=" +
          id.toString(),
      headers: {"Accept": "application/json"},
    );

    print(reponse);
    return json.decode(reponse.body);
  } catch (error) {
    print(error);
  }
}

Future addtoFavorite(userId, propertyId) async {
  try {
    final reponse = await http.post(
      mainUrlSite + "wp-json/badam/v1/addFavorite",
      body: {"user_id": userId, "property_id": propertyId},
      headers: {"Accept": "application/json"},
    );

    print(reponse);
    return json.decode(reponse.body);
  } catch (error) {
    print(error);
  }
}

Future removetoFavorite(userId, propertyId) async {
  try {
    final reponse = await http.post(
      mainUrlSite + "wp-json/badam/v1/removeFavorite",
      body: {"user_id": userId, "property_id": propertyId},
      headers: {"Accept": "application/json"},
    );

    print(reponse);
    return json.decode(reponse.body);
  } catch (error) {
    print(error);
  }
}

Future uploadImageMedia(File fileImage, String token) async {
  final mimeTypeData =
      lookupMimeType(fileImage.path, headerBytes: [0xFF, 0xD8]).split('/');
  final imageUploadRequest = http.MultipartRequest(
      'POST', Uri.parse(mainUrlSite + "wp-json/wp/v2/media"));

  final file = await http.MultipartFile.fromPath('file', fileImage.path,
      contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));

  imageUploadRequest.files.add(file);
  imageUploadRequest.headers
      .addAll({"Authorization": "Bearer $token", 'accept': '*/*'});
  try {
    final streamedResponse = await imageUploadRequest.send();

    return await streamedResponse.stream.bytesToString();
  } catch (e) {
    print(e);
  }
}

// Future submitPropertytoServer(
//     String token, Property item, imageId, location) async {
//   try {
//     String baseUrl = mainUrlSite + 'wp-json/wp/v2/properties';
//     print(location);

//     var response = await http.post(baseUrl, body: {
//       'title': item.title,
//       'content': item.content,
//       'featured_media': imageId.toString(),
//       'property-statuses': item.status,
//       'property-cities': item.cities,
//       'property-types': item.types,
//       'property_meta[REAL_HOMES_property_price]': item.price,
//       'property_meta[REAL_HOMES_property_size]': item.area,
//       'property_meta[REAL_HOMES_property_address]': item.address,
//       'property_meta[REAL_HOMES_property_id]': "BADAM-" + imageId,
//       'property_meta[REAL_HOMES_property_location]': location,
//       'property_meta[REAL_HOMES_featured]': json.encode(item.featured),
//     }, headers: {
//       "Authorization": "Bearer $token",
//       'accept': '*/*'
//     });

//     print(response.body);

//     return Future.value(response.body);
//   } catch (error) {
//     print(error);
//   }
// }

Future updateProfileContent(
    {@required userId,
    imageId,
    @required displayLast,
    @required displayName}) async {
  try {
    String baseUrl = mainUrlSite + '/wp-json/badam/v1/updateProfile';

    var response = await http.post(baseUrl, body: {
      'image_id': imageId,
      "user_id": userId,
      "name": displayName + " " + displayLast,
    });

    return Future.value(response.body);
  } catch (error) {
    print(error);
  }
}

Future deletePropertyServer(token, id) async {
  print(token);
  print(id);
  String baseUrl = mainUrlSite + 'wp-json/wp/v2/properties/' + id.toString();
  await http.delete(baseUrl, headers: {
    "Authorization": "Bearer $token",
    'accept': '*/*'
  }).then((data) {
    print(data);
  });
}
