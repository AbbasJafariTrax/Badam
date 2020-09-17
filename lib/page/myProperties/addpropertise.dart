import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:badam_app/model/city.dart';
import 'package:badam_app/model/model.dart';
import 'package:badam_app/model/property.dart';
import 'package:badam_app/modul/dropDownField.dart';
import 'package:badam_app/modul/myTextFormField.dart';
import 'package:badam_app/page/Maps/AGoogleMap.dart';
import 'package:badam_app/util/sharedPreference.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'map_screen.dart';

class AddPropertise extends StatefulWidget {
  @override
  _AddPropertiseState createState() => _AddPropertiseState();
}

enum AimCharacter { buy, run, graw }
enum TypeCharacter { land, home, unit, office, shop, apartment, vela }

class _AddPropertiseState extends State<AddPropertise> {
  GlobalKey _globleKey = GlobalKey();
  String selectedValue = "";
  bool crop = false;
  bool _isLoading = false;
  String token;
  String featureId;
  File _myImageFile;
  File tmpFile;

  final titleTxt = TextEditingController();
  final descriptionTxt = TextEditingController();
  final valueTxt = TextEditingController();
  final areaTxt = TextEditingController();
  final adressTxt = TextEditingController();

  LatLng _showMailk;

  Property addItem;
  final List<DropdownMenuItem> items = [];
  List<Asset> images = List<Asset>();
  String _errorMultiImage;

  AimCharacter _aim = AimCharacter.buy;
  TypeCharacter _typeProperty = TypeCharacter.land;

  final _formKey = GlobalKey<FormState>();
  Model model = Model();

  String username = "";
  String password = "";
  String userId = "";
  String locationSelected = "0,0";

  bool _locationSelected = false;

  Location location;
  LocationData currentLocation;
  PermissionStatus _permissionGranted;
  String selectedSalutation;
  String selectedYear;
  bool _serviceEnabled;
  LatLng propertyLatLng;

  Future<void> _requestService() async {
    if (_serviceEnabled == null || !_serviceEnabled) {
      final bool serviceRequestedResult = await location.requestService();
      setState(() {
        _serviceEnabled = serviceRequestedResult;
      });
      if (!serviceRequestedResult) {
        return;
      }
    }
  }

  Future<void> _checkPermissions() async {
    final PermissionStatus permissionGrantedResult =
        await location.hasPermission();
    setState(() {
      _permissionGranted = permissionGrantedResult;
    });
  }

  Future<void> _requestPermission() async {
    if (_permissionGranted != PermissionStatus.granted) {
      final PermissionStatus permissionRequestedResult =
          await location.requestPermission();
      setState(() {
        _permissionGranted = permissionRequestedResult;
      });
      if (permissionRequestedResult != PermissionStatus.granted) {
        return;
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleTxt.dispose();
    descriptionTxt.dispose();
    valueTxt.dispose();
    areaTxt.dispose();
    adressTxt.dispose();
  }

  @override
  void initState() {
    CityList.list.forEach((word) {
      items.add(DropdownMenuItem(
        child: Text(word.toString()),
        value: word.toString(),
      ));
    });

    _permissionGranted == PermissionStatus.granted ? null : _requestPermission;
    _serviceEnabled == true ? null : _requestService;

    super.initState();

    location = new Location();
    location.getLocation().then((data) {
      currentLocation = data;
    });
  }

  Widget submitButton() {
    return _isLoading
        ? Container(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(backgroundColor: Colors.white))
        : Text(
            "ارسال کردن",
            style: TextStyle(color: Colors.white, fontSize: 16),
          );
  }

  Future getUsername() async {
    try {
      List responses = await Future.wait([
        readPreferenceString("username").then((dataUsername) {
          if (dataUsername != null) {
            this.username = dataUsername;
          }
        }),
        readPreferenceString("password").then((dataPassword) {
          if (dataPassword != null) {
            this.password = dataPassword;
          }
        }),
        readPreferenceString("userId").then((userId) {
          if (userId != null) {
            this.userId = userId;
          }
        })
      ]);

      return Future.value(responses);
    } catch (e) {
      print("error");
    }
  }

  void submitProperty() async {
    Map<int, String> typeProperty = {
      10: "Apartment",
      11: "Office",
      12: "Bussnice",
      13: "land",
      14: 'Villa',
      15: "Store",
      16: "shop"
    };
    Map<int, int> year = {10: 1390, 11: 1391, 12: 1392};
    String base64Image;

    base64Image = base64Encode(_myImageFile.readAsBytesSync());

    var myMap = new Map<String, dynamic>();
    myMap['title'] = titleTxt.text;
    myMap['decription'] = descriptionTxt.text;
    myMap['value'] = valueTxt.text;
    myMap['area'] = areaTxt.text;
    myMap['adressTxt'] = adressTxt.text;
    myMap['aim'] = _aim.toString();
    myMap['selectedSalutation'] = typeProperty[int.parse(selectedSalutation)];
    myMap['buildYear'] = year[int.parse(selectedYear)];
    myMap['propertyLatLng'] = propertyLatLng;
    myMap['base64Image'] = base64Image;

    final urlToken = 'https://www.badam.af/wp-json/jwt-auth/v1/token';

    try {
      Dio dio = new Dio();
      final response = await dio.post(
        urlToken,
        data: {
          'username': 'admin',
          'password': 'mahdi@raham786',
        },
      );
      String mToken = response.data['token'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('stringValue', mToken);

      final url = 'https://www.badam.af/wp-json/wp/v2/property';
      Map<String, String> _urlHeader = {'Authorization': ''};

      _urlHeader['Authorization'] = 'Bearer $mToken';

      http.post(
        url,
        headers: _urlHeader,
        body: {"Map": myMap.toString()},
      ).then((response) {
        print(response.statusCode);
        String jsonsDataString = response.body.toString();
        var _data = jsonDecode(jsonsDataString);
        print("Hi Mahdi V ${_data.toString()}");
      }).catchError((e) => print("Hi Mahdi E $e"));
    } catch (e) {
      print("Mahdi: $e");
    }

    setState(() {
      _isLoading = true;
    });
  }

  _openImagePickerModal(BuildContext context) {
    _myImageFile = null;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("انتخاب عکس"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                InkWell(
                  child: ListTile(
                    contentPadding: EdgeInsets.all(0),
                    title: Text("گالری"),
                  ),
                  onTap: () {
                    _openGallery(context);
                  },
                ),
                InkWell(
                  child: ListTile(
                    contentPadding: EdgeInsets.all(0),
                    title: Text("دوربین"),
                  ),
                  onTap: () {
                    _openCamera(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _openGallery(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      _myImageFile = picture;
    });
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState(() {
      _myImageFile = picture;
    });
    Navigator.of(context).pop();
  }

  Widget _imageProfile() {
    return _myImageFile == null
        ? Container(
            height: 150,
            child: Icon(
              Icons.camera_alt,
              color: Colors.white,
              size: 45,
            ),
          )
        : Container(
            alignment: Alignment.topCenter,
            width: MediaQuery.of(context).size.width,
            child: Image.file(
              _myImageFile,
              fit: BoxFit.cover,
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    // addItem = new Property();
    final halfMediaWidth = MediaQuery.of(context).size.width / 2.0;
    return Scaffold(
      appBar: AppBar(
          // title: Text("اضافیه کردن ملک جدید"),
          ),
      body: FutureBuilder(
        future: getUsername(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Card(
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            alignment: Alignment.centerRight,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                            ),
                            child: Text(
                              "مشخصات ملک",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16),
                            ),
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            title: Text(
                              "نوع اعلان ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text('کرایی'),
                                    Radio(
                                      value: AimCharacter.run,
                                      groupValue: _aim,
                                      onChanged: (AimCharacter value) {
                                        setState(() {
                                          _aim = value;
                                        });
                                      },
                                    )
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text('فروشی'),
                                    Radio(
                                      value: AimCharacter.buy,
                                      groupValue: _aim,
                                      onChanged: (AimCharacter value) {
                                        setState(() {
                                          _aim = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text('گروه'),
                                    Radio(
                                      value: AimCharacter.graw,
                                      groupValue: _aim,
                                      onChanged: (AimCharacter value) {
                                        setState(() {
                                          _aim = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'عنوان ملک',
                                ),
                                Text("0/100")
                              ],
                            ),
                          ),
                          MyTextFormField(
                            controller: titleTxt,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'عنوان ملک را وارد کنید';
                              }
                              return null;
                            },
                            onSaved: (String value) {
                              // addItem.title = value;
                            },
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    ListTile(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 8),
                                      title: Text("نوعیت ملک"),
                                    ),
                                    DropDownFormField(
                                      value: selectedSalutation,
                                      onSaved: (value) {
                                        setState(() {
                                          selectedSalutation = value;
                                        });
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                          selectedSalutation = value;
                                        });
                                      },
                                      dataSource: [
                                        {
                                          "display": "Apartment",
                                          "value": "10",
                                        },
                                        {
                                          "display": "Office",
                                          "value": "11",
                                        },
                                        {
                                          "display": "Bessince",
                                          "value": "12",
                                        },
                                        {
                                          "display": "land",
                                          "value": "13",
                                        },
                                        {
                                          "display": "Villa",
                                          "value": "14",
                                        },
                                        {
                                          "display": "Store",
                                          "value": "15",
                                        },
                                        {
                                          "display": "Shop",
                                          "value": "16",
                                        },
                                      ],
                                      textField: 'display',
                                      valueField: 'value',
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Visibility(
                                  child: Column(
                                    children: <Widget>[
                                      ListTile(
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 8),
                                        title: Text("سال ساخت"),
                                      ),
                                      DropDownFormField(
                                        value: selectedYear,
                                        onSaved: (value) {
                                          setState(() {
                                            selectedYear = value;
                                          });
                                        },
                                        onChanged: (value) {
                                          setState(() {
                                            selectedYear = value;
                                          });
                                        },
                                        dataSource: [
                                          {
                                            "display": "1390",
                                            "value": "10",
                                          },
                                          {
                                            "display": "1391",
                                            "value": "11",
                                          },
                                          {
                                            "display": "1392",
                                            "value": "12",
                                          },
                                        ],
                                        textField: 'display',
                                        valueField: 'value',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          MyTextFormField(
                            maxLines: 5,
                            hintText: 'توضيحات ملک',
                            isMultiline: true,
                            controller: descriptionTxt,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'توضيحات ملک را وارد کنید';
                              }
                              return null;
                            },
                            onSaved: (String value) {
                              // addItem.content = value;
                            },
                          ),
                          ListTile(
                            title: Text("مکان ملک"),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 10.0,
                              left: 10.0,
                              right: 10.0,
                            ),
                            child: GestureDetector(
                              onTap: () => _openImagePickerModal(context),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    _imageProfile(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text('دوکان'),
                                  Radio(
                                    value: TypeCharacter.shop,
                                    groupValue: _typeProperty,
                                    onChanged: (TypeCharacter value) {
                                      setState(() {
                                        _typeProperty = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text('واحد'),
                                  Radio(
                                    value: TypeCharacter.unit,
                                    groupValue: _typeProperty,
                                    onChanged: (TypeCharacter value) {
                                      setState(() {
                                        _typeProperty = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text('اپارتمان'),
                                  Radio(
                                    value: TypeCharacter.apartment,
                                    groupValue: _typeProperty,
                                    onChanged: (TypeCharacter value) {
                                      setState(() {
                                        _typeProperty = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text('ویلا'),
                                  Radio(
                                    value: TypeCharacter.vela,
                                    groupValue: _typeProperty,
                                    onChanged: (TypeCharacter value) {
                                      setState(() {
                                        _typeProperty = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          MyTextFormField(
                            controller: valueTxt,
                            hintText: 'قمیت فروش یا اجاره به افغانی',
                            isNumber: true,
                            validator: (String value) {
                              // if (!validator.isNumeric(value)) {
                              //   return 'قمیت فروش یا اجاره را وارد کنید';
                              // }
                              return null;
                            },
                            onSaved: (String value) {
                              setState(() {
                                // addItem.price = value;
                              });
                            },
                          ),
                          MyTextFormField(
                            controller: areaTxt,
                            hintText: 'مساحت ملک',
                            isNumber: true,
                            validator: (String value) {
                              // if (!validator.isNumeric(value)) {
                              //   return 'مساحت ملک را وارد کنید';
                              // }
                              return null;
                            },
                            onSaved: (String value) {
                              setState(() {
                                // addItem.area = value;
                              });
                            },
                          ),
                          MyTextFormField(
                            controller: adressTxt,
                            hintText: 'آدرس',
                            maxLines: 3,
                            validator: (String value) {
                              if (value.length < 7) {
                                return 'آدرس تان را وارد کنید';
                              }
                              _formKey.currentState.save();
                              return null;
                            },
                            onSaved: (String value) {
                              setState(() {
                                // addItem.address = value;
                              });
                            },
                          ),
                          Divider(height: 12),
                          _locationSelected
                              ? SizedBox(
                                  width: double.infinity,
                                  height: 200.0,
                                  child: googleMapWidget())
                              : SizedBox(),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                ),
                              ),
                              child: FlatButton(
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "گرفتن موقعیت از نقشه",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                      ],
                                    )),
                                  ],
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    AGoogleMap.routeName,
                                  ).then(
                                    (homeLatLng) {
                                      propertyLatLng = homeLatLng;
                                      print("Mahdi Home: $homeLatLng");
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                          Divider(height: 12),
                          buildGridView(halfMediaWidth),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                ),
                              ),
                              child: FlatButton(
                                onPressed: loadAssets,
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "انتخاب عکس های دیگر",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                      ],
                                    )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 200,
                            padding: EdgeInsets.all(10),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                ),
                              ),
                              child: FlatButton(
                                // onPressed: _isLoading ? null : submitProperty,
                                onPressed: submitProperty,
                                child: submitButton(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget buildGridView(double width) {
    if (images != null)
      return Container(
        height: images.length < 3 ? width : width * 2,
        child: GridView.count(
          primary: false,
          crossAxisCount: 3,
          children: List.generate(images.length, (index) {
            Asset asset = images[index];
            return AssetThumb(
              asset: asset,
              width: 300,
              height: 300,
            );
          }),
        ),
      );
    else
      return Container(color: Colors.white);
  }

  Future<void> loadAssets() async {
    setState(() {
      images = List<Asset>();
    });

    List<Asset> resultList;
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      if (error == null) _errorMultiImage = 'No Error Dectected';
    });
  }

  int indexLoadingImage;

  Widget googleMapWidget() {
    return GoogleMap(
      myLocationButtonEnabled: true,
      buildingsEnabled: true,
      myLocationEnabled: true,
      initialCameraPosition: CameraPosition(
        target: _showMailk != null ? _showMailk : LatLng(34.0, 62.0),
        zoom: 13.0,
      ),
      markers: {
        Marker(
            markerId: MarkerId("id"),
            position: _showMailk != null ? _showMailk : LatLng(34.0, 62.0)),
      },
    );
  }

  Future goToSecondScreen(context, LatLng location) async {
    return await Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (BuildContext context) => new MapScreen(
            key: _globleKey,
            initialLocation: location,
          ),
          fullscreenDialog: true,
        ));
  }

  Widget checkbox(String title, bool boolValue) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(title),
        Checkbox(
          value: boolValue,
          onChanged: (bool value) {},
        )
      ],
    );
  }
}
