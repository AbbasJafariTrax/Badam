import 'dart:async';
import 'package:badam_app/apiReqeust/schemas/user.dart';
import 'package:badam_app/style/style.dart';
import 'package:flutter/material.dart';
// import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var s = new User();

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  String textDesc = 'ب';
  Timer _timer ;
  void animationText1() {
    _timer = new Timer(
        const Duration(
          milliseconds: 1100,
        ), () {
      setState(() {
        textDesc += 'ه';
      });
    });
  }
  void animationText2() {
    _timer = new Timer(
      
        const Duration(
          milliseconds: 1150,
        ), () {
      setState(() {
        textDesc += 'ت';
      });
    });
  }
  void animationText3() {
    _timer = new Timer(
        const Duration(
          milliseconds: 1200,
        ), () {
      setState(() {
        textDesc += 'ر';
      });
    });
  }
  void animationText4() {
    _timer = new Timer(
        const Duration(
          milliseconds: 1250,
        ), () {
      setState(() {
        textDesc += 'ی';
      });
    });
  }
  void animationText5() {
    _timer = new Timer(
        const Duration(
          milliseconds: 1300,
        ), () {
      setState(() {
        textDesc += 'ن';
      });
    });
  }
  void animationText6() {
    _timer = new Timer(
        const Duration(
          milliseconds: 1350,
        ), () {
      setState(() {
        textDesc += ' ';
      });
    });
  }
  void animationText7() {
    _timer = new Timer(
        const Duration(
          milliseconds: 1400,
        ), () {
      setState(() {
        textDesc += 'م';
      });
    });
  }
  void animationText8() {
    _timer = new Timer(
        const Duration(
          milliseconds: 1450,
        ), () {
      setState(() {
        textDesc += 'ر';
      });
    });
  }
  void animationText10() {
    _timer = new Timer(
        const Duration(
          milliseconds: 1500,
        ), () {
      setState(() {
        textDesc += 'ج';
      });
    });
  }
  void animationText11() {
    _timer = new Timer(
        const Duration(
          milliseconds: 1550,
        ), () {
      setState(() {
        textDesc += 'ع';
      });
    });
  }
  void animationText12() {
    _timer = new Timer(
        const Duration(
          milliseconds: 1600,
        ), () {
      setState(() {
        textDesc += ' ';
      });
    });
  }
  void animationText13() {
    _timer = new Timer(
        const Duration(
          milliseconds: 1650,
        ), () {
      setState(() {
        textDesc += 'خ';
      });
    });
  }
  void animationText14() {
    _timer = new Timer(
        const Duration(
          milliseconds: 1700,
        ), () {
      setState(() {
        textDesc += 'ر';
      });
    });
  }
  void animationText15() {
    _timer = new Timer(
        const Duration(
          milliseconds: 1750,
        ), () {
      setState(() {
        textDesc += 'ی';
      });
    });
  }
  void animationText16() {
    _timer = new Timer(
        const Duration(
          milliseconds: 1800,
        ), () {
      setState(() {
        textDesc += 'د';
      });
    });
  }
  void animationText17() {
    _timer = new Timer(
        const Duration(
          milliseconds: 1850,
        ), () {
      setState(() {
        textDesc += ' ';
      });
    });
  }
  void animationText18() {
    _timer = new Timer(
        const Duration(
          milliseconds: 1900,
        ), () {
      setState(() {
        textDesc += 'و';
      });
    });
  }
  void animationText19() {
    _timer = new Timer(
        const Duration(
          milliseconds: 1950,
        ), () {
      setState(() {
        textDesc += ' ';
      });
    });
  }
  void animationText20() {
    _timer = new Timer(
        const Duration(
          milliseconds: 2000,
        ), () {
      setState(() {
        textDesc += 'ف';
      });
    });
  }
  void animationText21() {
    _timer = new Timer(
        const Duration(
          milliseconds: 2050,
        ), () {
      setState(() {
        textDesc += 'ر';
      });
    });
  }
  void animationText22() {
    _timer = new Timer(
        const Duration(
          milliseconds: 2100,
        ), () {
      setState(() {
        textDesc += 'و';
      });
    });
  }
  void animationText23() {
    _timer = new Timer(
        const Duration(
          milliseconds: 2150,
        ), () {
      setState(() {
        textDesc += 'ش';
      });
    });
  }
  void animationText24() {
    _timer = new Timer(
        const Duration(
          milliseconds: 2200,
        ), () {
      setState(() {
        textDesc += ' ';
      });
    });
  }
  void animationText25() {
    _timer = new Timer(
        const Duration(
          milliseconds: 2250,
        ), () {
      setState(() {
        textDesc += 'ا';
      });
    });
  }
  void animationText26() {
    _timer = new Timer(
        const Duration(
          milliseconds: 2300,
        ), () {
      setState(() {
        textDesc += 'م';
      });
    });
  }
  void animationText27() {
    _timer = new Timer(
        const Duration(
          milliseconds: 2350,
        ), () {
      setState(() {
        textDesc += 'ل';
      });
    });
  }
  void animationText28() {
    _timer = new Timer(
        const Duration(
          milliseconds: 2400,
        ), () {
      setState(() {
        textDesc += 'ا';
      });
    });
  }
  void animationText29() {
    _timer = new Timer(
        const Duration(
          milliseconds: 2450,
        ), () {
      setState(() {
        textDesc += 'ک';
      });
    });
  }
  void animationText30() {
    _timer = new Timer(
        const Duration(
          milliseconds: 2500,
        ), () {
      setState(() {
        textDesc += 'ر';
      });
    });
  }

  void animationText31() {
    _timer = new Timer(
        const Duration(
          milliseconds: 2550,
        ), () {
      setState(() {
        textDesc += 'ا';
      });
    });
  }
  void animationText32() {
    _timer = new Timer(
        const Duration(
          milliseconds: 2600,
        ), () {
      setState(() {
        textDesc += 'ف';
      });
    });
  }
  void animationText33() {
    _timer = new Timer(
        const Duration(
          milliseconds: 2650,
        ), () {
      setState(() {
        textDesc += 'ن';
      });
    });
  }


  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/welcome');
  }

  @override
  void initState() {
    super.initState();
    startTime();
    animationText1();
    animationText2();
    animationText3();
    animationText4();
    animationText5();
    animationText6();
    animationText7();
    animationText8();
    animationText10();
    animationText11();
    animationText12();
    animationText13();
    animationText14();
    animationText15();
    animationText16();
    animationText17();
    animationText18();
    animationText19();
    animationText20();
    animationText21();
    animationText22();
    animationText23();
    animationText24();
    animationText25();
    animationText26();
    animationText27();
    animationText28();
    animationText29();
    // animationText30();
    // animationText31();
    // animationText32();
    // animationText33();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            
            Image.asset(
              'assets/img/logo-larg.png',
              width: 200,
              // color: Color.alphaBlend(Colors.grey, Colors.indigo),
            ),
            
            welcomeText("بادام ملک", context),
            Text(textDesc),
          ],
        ),
      ),
    );
  }
}
