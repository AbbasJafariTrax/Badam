import 'dart:async';

abstract class AuthService{
  Future<String> submitPhoneNumber({String phoneNumber});
  Future<UserAuthData> confirmSMSCode({String verificationId,String smsCode});
  Future<void> signOut();
  Future<UserAuthData>getCurrentUser();
  Future<String>getToken();
}

class UserAuthData{
  final String uid;
  final String phoneNr;

  UserAuthData({this.uid, this.phoneNr});
}