import 'dart:convert';
import 'dart:async';

import 'package:badam_app/apiReqeust/constants.dart';
import 'package:badam_app/apiReqeust/requests/params_post_list.dart';
import 'package:badam_app/apiReqeust/schemas/wordpress_error.dart';
import 'package:badam_app/model/property.dart';
import 'package:flutter/widgets.dart';
import "package:dio/dio.dart";
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_provider.dart';

class PropertyProvider with ChangeNotifier {
  final BASE_URL = "http://192.168.43.186/beyot";
  Dio dio = new Dio();

  Map<String, String> _urlHeader = {
    'Authorization': '',
  };

  Future<void> _headerSetToken() async {
    String token = "";
    if (Auth().isAuth) {
      token = Auth().token;
    } else {
      await Auth().tryAutoLogin();
      token = Auth().token;
    }
    _urlHeader['Authorization'] = 'Bearer $token';

    print(_urlHeader);
  }

  Future fetchPosts({
    @required ParamsPostList postParams,
  }) async {
    await _headerSetToken();
    final StringBuffer url = new StringBuffer(BASE_URL + URL_PROPERTY);

    url.write(postParams.toString());
    print(url.toString());
    try {
      final response = await dio.get(
        url.toString(),
        options: Options(headers: _urlHeader),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        List<Property> properties = new List<Property>();

        final list = response.data;

        for (var property in list) {
          properties.add(Property.fromJson(property));
        }

        notifyListeners();
        // print(properties[0].title.rendered);
        return Future.value(properties);
      } else {
        try {
          WordPressError err = WordPressError.fromJson(response.data);
          throw err;
        } catch (e) {
          throw new WordPressError(message: response.data);
        }
      }
    } on DioError catch (e) {
      print(e.response.statusMessage);
    }
  }
}
