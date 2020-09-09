import 'dart:async';
import 'package:badam_app/util/sharedPreference.dart';
import 'package:badam_app/util/utiles_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import './auth_service.dart';
import 'httpRequest.dart';

class AuthServiceFirebase extends AuthService {
  String token;
  DateTime tokenCreationDate;
  int tokenLifetimeInMinutes = 5;
  BuildContext context;

  AuthServiceFirebase({@required this.context});

  @override
  Future<String> submitPhoneNumber({String phoneNumber}) async {
    Completer<String> c = Completer();

    PhoneCodeSent codeSent = (verificationId, [forceResendingToken]) {
      print('SMS sent');
      c.complete(verificationId);
    };

    PhoneVerificationFailed phoneVerificationFailed = (authException) {
      print('phone verification failed');
      print(authException.message);
      c.completeError(Error());
    };

    PhoneVerificationCompleted phoneVerificationCompleted = (firebaseUser) {
      FirebaseAuth.instance
          .signInWithCredential(firebaseUser)
          .catchError((err) {

            return "ERROR_NETWORK_REQUEST_FAILED";
            c.completeError(err);
          })
          .whenComplete(() {
              readPreferenceString("tempUsername").then((user) {
                userAlreadyRegisterd(getPhoneforuser(user)).then((isAlreadyReister) {
                  if (isAlreadyReister.body.toString() == '0') {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, "/Dashboard");
                  } else if (isAlreadyReister.body.toString() == '1') {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, "/register");
                  }
                }).catchError((error) {
                  print(error);
                });
        }).catchError((onError) {
          print('onError');
          print(onError);
        });
      });
      return c.future;
    };
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 10),
        verificationCompleted: phoneVerificationCompleted,
        verificationFailed: phoneVerificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: null);

    return c.future;
  }

  @override
  Future<UserAuthData> confirmSMSCode(
      {String verificationId, String smsCode}) async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    var firebaseUser =
        await FirebaseAuth.instance.signInWithCredential(credential);

    return UserAuthData(
        uid: firebaseUser.user.uid,
        phoneNr: firebaseUser.user.phoneNumber ?? '');
  }

  @override
  Future<UserAuthData> getCurrentUser() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return UserAuthData(uid: null, phoneNr: '');
    return UserAuthData(
        uid: firebaseUser.uid, phoneNr: firebaseUser.phoneNumber ?? '');
  }

  @override
  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }

  @override
  Future<String> getToken() async {
    if (_tokenIsExpired()) {
      await _refreshToken();
    }
    return token;
  }

  bool _tokenIsExpired() {
    if (token == null) return true;
    if (token != null &&
        DateTime.now().difference(tokenCreationDate).abs().inMinutes >
            tokenLifetimeInMinutes) return true;
    return false;
  }

  Future<void> _refreshToken() async {
    var user = await FirebaseAuth.instance.currentUser;
    tokenCreationDate = DateTime.now();
    token = (await user.getIdToken()) as String;

    // print(user.getIdToken());
  }
}
