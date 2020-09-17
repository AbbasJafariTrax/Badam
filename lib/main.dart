import 'dart:io';

import 'package:badam_app/page/Homepage.dart';
import 'package:badam_app/page/Maps/AGoogleMap.dart';
import 'package:badam_app/page/agency/showAgencyProperties.dart';
import 'package:badam_app/page/agency/singleAgence.dart';
import 'package:badam_app/page/auth/PhoneAuthVerify.dart';
import 'package:badam_app/page/auth/Register.dart';
import 'package:badam_app/page/auth/phoneVarify.dart';
import 'package:badam_app/page/auth/profile.dart';
import 'package:badam_app/page/auth/welcome.dart';
import 'package:badam_app/page/myProperties/addpropertise.dart';
import 'package:badam_app/page/myProperties/fevorite.dart';
import 'package:badam_app/page/myProperties/myListProperties.dart';
import 'package:badam_app/page/posts/singlePosts.dart';
import 'package:badam_app/page/propeties/search.dart';
import 'package:badam_app/page/propeties/singleProperties.dart';
import 'package:badam_app/provider/auth_provider.dart';
import 'package:badam_app/provider/property_provider.dart';
import 'package:badam_app/test.dart';
import 'package:badam_app/test_login_page.dart';
import 'package:badam_app/themes/custom_theme.dart';
import 'package:badam_app/themes/my_themes.dart';

import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:hive/hive.dart';

import 'package:provider/provider.dart';

import 'apiReqeust/schemas/user.dart';
import 'modul/SearchDialog.dart';
import 'strings.dart';

final String boxName = 'favourite_list';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  HttpOverrides.global = new MyHttpOverrides();
  await Hive.initFlutter();
  await Hive.openBox<String>(boxName);
  runApp(
    CustomTheme(
      initialThemeKey: MyThemeKeys.LIGHT,
      child: MyApp(),
    ),
  );
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       child: Consumer<Auth>(
//         builder: (BuildContext context, value, Widget child) => MaterialApp(
//           title: APP_NAME,
//           theme: CustomTheme.of(context),
//           routes: <String, WidgetBuilder>{
//             '/':
//           },
//         ),
//       ),
//       providers: [
//         ChangeNotifierProvider.value(value: Auth()),
//       ],
//     );
//   }
// }

class MyApp extends StatelessWidget {
  User currentUser = User();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: Consumer<Auth>(
        builder: (BuildContext context, value, Widget child) => MaterialApp(
          debugShowCheckedModeBanner: true,
          // showSemanticsDebugger: true,
          // debugShowMaterialGrid: true,
          title: APP_NAME,
          theme: CustomTheme.of(context),
          builder: (BuildContext context, Widget child) {
            return new Directionality(
              textDirection: TextDirection.rtl,
              child: new Builder(
                builder: (BuildContext context) {
                  return new MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      textScaleFactor: 1.0,
                    ),
                    child: child,
                  );
                },
              ),
            );
          },
          routes: <String, WidgetBuilder>{
            // '/': (BuildContext context) => MyHomePage(),
            // '/': (BuildContext context) => SplashScreen(),
            // '/': (BuildContext context) => Dashboard(),
            // '/': (BuildContext context) => Test_home(),
            '/': (BuildContext context) => Dashboard(),
            '/welcome': (BuildContext context) => Welcome(),
            '/register': (BuildContext context) => RegisterUser(),
            '/codephoneVarify': (BuildContext context) => PhoneVarify(),
            '/PhoneAuthVerify': (BuildContext context) =>
                PhoneAuthVerify(ModalRoute.of(context).settings.arguments),
            '/LoginUser': (BuildContext context) => value.isAuth
                ? Test_home()
                : FutureBuilder(
                    future: value.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) {
                      print(authResultSnapshot.data);
                      return authResultSnapshot.data == false
                          ? Test_Login_page()
                          : Test_home();
                    },
                  ),

            '/Dashboard': (BuildContext context) => Dashboard(),
            '/singleAgent': (BuildContext context) =>
                SingleAgence(ModalRoute.of(context).settings.arguments),
            '/singleProperty': (BuildContext context) =>
                SingleProperties(ModalRoute.of(context).settings.arguments),
            '/singlePost': (BuildContext context) =>
                SinglePost(ModalRoute.of(context).settings.arguments),
            '/myPropertyList': (BuildContext context) =>
                MyListProperties(ModalRoute.of(context).settings.arguments),
            '/SearchDialog': (BuildContext context) => FiltersScreen(),
            '/addPropery': (BuildContext context) => AddPropertise(),
            '/agencyPropertiesList': (BuildContext context) =>
                ShowPropertyAgency(ModalRoute.of(context).settings.arguments),
            '/searchPage': (BuildContext context) => SearchPage(),
            '/profile': (BuildContext context) => ProfilePage(),
            AGoogleMap.routeName: (BuildContext context) => AGoogleMap(),
            '/favoritePage': (BuildContext context) => FevoritePage(),
            //test
          },
        ),
      ),
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProvider.value(value: PropertyProvider()),
      ],
    );
  }

//  @override
// Widget build(BuildContext context) {
//   return ChangeNotifierProvider<MyBottomSheetModel>(
//     create: (_) => MyBottomSheetModel(),
//     child: MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         fontFamily: 'OpenSans',
//       ),
//       home: HomeScreen(),
//     ),
//   );
// }
}
