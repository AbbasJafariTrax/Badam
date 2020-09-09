import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import "package:dio/dio.dart";
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future _authenticate(String username, String password) async {
    final url = 'https://www.badam.af/wp-json/jwt-auth/v1/token';
    Dio dio = new Dio();
    try {
      final response = await dio.post(url, data: {
        'username': username,
        'password': password,
      });

      final responseData = response.data;

      print(responseData);

      if (responseData['error'] != null) {
        return Future(responseData['error']['message']);
      }
      _token = responseData['token'];
      _userId = responseData['id'].toString();
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['exp'].toString(),
          ),
        ),
      );

      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'user_email': responseData['user_email'],
          'user_nicename': responseData['user_nicename'],
          'expiryDate': _expiryDate.toIso8601String(),
          'username': username,
          'password': password,
        },
      );
      prefs.setString('userData', userData);

      return Future.value([true, userData]);
    } on DioError catch (e) {
      if (e.response.statusCode == 403) {
        print(e.response.data['message']);
        print(e.response);
        return Future.value(
            [false, e.response.data['code'], e.response.data['message']]);
      }
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password);
  }

  Future login(String email, String password) async {
    return _authenticate(email, password);
  }

  Future<bool> tryGetToken() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('userData') == null) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;

    await login(extractedUserData['username'], extractedUserData['password']);
    return true;
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString('userData') == null) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
