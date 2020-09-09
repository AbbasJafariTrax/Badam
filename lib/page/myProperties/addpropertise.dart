import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:badam_app/apiReqeust/constants.dart';
import 'package:badam_app/apiReqeust/schemas/jwt_response.dart';
import 'package:badam_app/model/city.dart';
import 'package:badam_app/model/model.dart';
import 'package:badam_app/model/property.dart';
import 'package:badam_app/style/style.dart';
import 'package:badam_app/util/httpRequest.dart';
import 'package:badam_app/util/sharedPreference.dart';
import 'package:badam_app/util/utiles_functions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

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
  bool _isUploadingImage = false;
  bool _isLoading = false;
  String token;
  String featureId;

  final titleTxt = TextEditingController();
  final descriptionTxt = TextEditingController();
  final valueTxt = TextEditingController();
  final areaTxt = TextEditingController();
  final adressTxt = TextEditingController();

  LatLng _showMailk;

  Property addItem;
  File _imageFile;
  final List<DropdownMenuItem> items = [];

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

  Future<void> _checkService() async {
    final bool serviceEnabledResult = await location.serviceEnabled();
    setState(() {
      _serviceEnabled = serviceEnabledResult;
    });
  }

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

  void _openImagePickerModal(BuildContext context) {
    final flatButtonColor = Theme.of(context).primaryColor;
    print('Image Picker Modal Called');
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150.0,
            child: Column(
              children: <Widget>[
                Container(
                  height: 50,
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(0),
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                  ),
                  width: double.infinity,
                  child: Text(
                    'انتخاب تصویر',
                    style: titleMedum(context),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FlatButton(
                      textColor: flatButtonColor,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          FaIcon(FontAwesomeIcons.camera),
                          Text('از دوربین'),
                        ],
                      ),
                      onPressed: () {
                        _getImage(context, ImageSource.camera);
                      },
                    ),
                    FlatButton(
                      textColor: flatButtonColor,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          FaIcon(FontAwesomeIcons.images),
                          Text('از گالری'),
                        ],
                      ),
                      onPressed: () {
                        _getImage(context, ImageSource.gallery);
                      },
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  void _getImage(BuildContext context, ImageSource source) async {
    File image = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = image;
    });

    Navigator.pop(context);

    if (_imageFile != null) {
      _cropImage(_imageFile).then((data) {
        setState(() {
          _imageFile = data;
        });
      });
    }

    if (_imageFile != null) {
      setState(() {
        _isUploadingImage = true;
      });

      print("username: " + this.username);
      print("username: " + this.password);
      getToken(getPhoneforuser(this.username), this.password).then((value) {
        Map<String, dynamic> tokens = json.decode(value.body);
        token = tokens['token'];

        uploadImageMedia(_imageFile, token).then((data) {
          Map<String, dynamic> d = json.decode(data);

          setState(() {
            _isUploadingImage = false;

            featureId = d['id'].toString();
          });
        });
      });
    }
  }

  Future<File> _cropImage(File file) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: file.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
              ]
            : [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'ویرایش عکس پروفایل',
            toolbarColor: Theme.of(context).primaryColor,
            cropFrameColor: Theme.of(context).primaryColor,
            statusBarColor: Theme.of(context).primaryColor,
            activeControlsWidgetColor: Theme.of(context).primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'ویرایش عکس پروفایل',
        ));
    if (croppedFile != null) {
      return Future.value(croppedFile);
    }
  }

  void submitProperty() async {
    Map<int, String> type = {
      10: "Apartment",
      11: "Office",
      12: "Bussnice",
      13: "land",
      14: 'Villa',
      15: "Store",
      16: "shop"
    };
    Map<int, int> year = {
      10: 1390,
      11: 1391,
      12: 1392,
    };

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      var map = new Map<String, dynamic>();
      map['title'] = titleTxt.text;
      map['decription'] = descriptionTxt.text;
      map['value'] = valueTxt.text;
      map['area'] = areaTxt.text;
      map['adressTxt'] = adressTxt.text;
      map['aim'] = _aim.toString();
      map['selectedSalutation'] = type[int.parse(selectedSalutation)];
      map['selectedYear'] = year[int.parse(selectedYear)].toString();
      createProperty(map)
          .then((res) => print("Mahdi Res: " + res.body))
          .catchError((err) => print("Mahdi Err" + err));

      setState(() {
        _isLoading = true;
      });
    }
  }

  Future<http.Response> createProperty(Map map) async {
    String _baseUrl = "http://www.badam.af/";
    final body = {
      'username': username,
      'password': password,
    };
    Map<String, String> _urlHeader = {
      'Authorization': '',
    };

    final response = await http.post(
      _baseUrl + URL_JWT_TOKEN,
      body: body,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      JWTResponse authResponse =
          JWTResponse.fromJson(json.decode(response.body));
      _urlHeader['Authorization'] = 'Bearer ${authResponse.token}';
    }

    return http.post(
      'https://www.badam.af/wp-json/wp/v2/property',
      headers: _urlHeader,
      body: jsonEncode(<String, Map>{
        'map': map,
      }),
    );
  }

  Widget _imageProfile() {
    return _imageFile == null
        ? Container(
            height: 150,
          )
        : Container(
            alignment: Alignment.topCenter,
            width: MediaQuery.of(context).size.width,
            child: Image.file(
              _imageFile,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                  top: 10.0, left: 10.0, right: 10.0),
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
                                      Positioned(
                                        child: _isUploadingImage
                                            ? CircularProgressIndicator()
                                            : Icon(
                                                Icons.camera_alt,
                                                color: Colors.white,
                                                size: 45,
                                              ),
                                      ),
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
                                  onPressed: () {},
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "گرفتن موقعیت از نقشه",
                                            style:
                                                TextStyle(color: Colors.white),
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
                                  onPressed:
                                      _addImageToGallary ? loadAssets : null,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            "انتخاب عکس های دیگر",
                                            style:
                                                TextStyle(color: Colors.white),
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
          }),
    );
  }

  bool _addImageToGallary = true;
  List<File> gallaryimages = List<File>();
  List gallaryimagesId = List();

  Future<void> loadAssets() async {
    String error = 'No Error Dectected';

    try {
      if (gallaryimages.length < 5) {
        File imagesPick = await ImagePicker.pickImage(
          source: ImageSource.gallery,
        );

        _cropImage(imagesPick).then((data) {
          if (data != null) {
            setState(() {
              if (gallaryimages.length >= 4) {
                _addImageToGallary = false;
              }
              gallaryimages.add(data);
            });
          }
        }).whenComplete(() {
          if (gallaryimages.length > 0) {
            setState(() {
              indexLoadingImage = gallaryimages.length - 1;
            });
            int indexFile = gallaryimages.length;

            uploadImageMedia(gallaryimages[indexFile - 1], token).then((data) {
              if (data != null) {
                Map<String, dynamic> d = json.decode(data);
                setState(() {
                  _isUploadingImage = false;
                  gallaryimagesId.add(d['id']);
                  indexLoadingImage = null;
                });

                print(gallaryimagesId.toString());
              }
            });
          }
        });
      }
    } on Exception catch (e) {
      error = e.toString();
    }
  }

  Widget buildGridView(width) {
    return Container(
      height: gallaryimages.length < 3 ? width : width * 2,
      child: gallaryimages.length > 0
          ? GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              padding: EdgeInsets.all(5),
              children: List.generate(gallaryimages.length, (index) {
                File asset = gallaryimages[index];
                return Stack(
                  children: <Widget>[
                    Image.file(
                      asset,
                      width: width,
                      height: width,
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, size: 30),
                      onPressed: () {
                        setState(() {
                          gallaryimages.removeAt(index);
                          gallaryimagesId.removeAt(index);
                        });
                        print(gallaryimagesId.toString());
                      },
                    ),
                    index == indexLoadingImage
                        ? Center(child: CircularProgressIndicator())
                        : Text(""),
                  ],
                );
              }),
            )
          : Center(
              child: Text("هیج تصویر انتخاب نشده"),
            ),
    );
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

class MyTextFormField extends StatelessWidget {
  final String hintText;
  final int maxLines;
  final Function validator;
  final Function onSaved;
  final bool isPassword;
  final bool isNumber;
  final bool isMultiline;
  final TextEditingController controller;

  MyTextFormField({
    this.hintText,
    this.validator,
    this.onSaved,
    this.isPassword = false,
    this.isMultiline = false,
    this.isNumber = false,
    this.maxLines = 1,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        maxLines: this.maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: EdgeInsets.all(15.0),
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.grey[200],
        ),
        obscureText: isPassword ? true : false,
        validator: validator,
        onSaved: onSaved,
        enableInteractiveSelection: true,
        keyboardType: isNumber
            ? TextInputType.number
            : isMultiline ? TextInputType.multiline : TextInputType.text,
      ),
    );
  }
}

class DropDownFormField extends FormField<dynamic> {
  final String titleText;
  final String hintText;
  final bool required;
  final String errorText;
  final dynamic value;
  final List dataSource;
  final String textField;
  final String valueField;
  final Function onChanged;
  final bool filled;
  final bool enable;

  DropDownFormField(
      {FormFieldSetter<dynamic> onSaved,
      FormFieldValidator<dynamic> validator,
      bool autovalidate = false,
      this.titleText = 'Title',
      this.hintText = 'Select one option',
      this.required = false,
      this.errorText = 'Please select one option',
      this.value,
      this.dataSource,
      this.textField,
      this.valueField,
      this.onChanged,
      this.enable = true,
      this.filled = true})
      : super(
          onSaved: onSaved,
          validator: validator,
          autovalidate: autovalidate,
          initialValue: value == '' ? null : value,
          builder: (FormFieldState<dynamic> state) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              // padding: EdgeInsets.only(right: 5,left: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InputDecorator(
                    decoration: InputDecoration(
                      // hintText: hintText,
                      contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    // decoration: new InputDecoration(
                    //   filled: true,
                    //   fillColor: Colors.white,

                    //   border: new OutlineInputBorder(
                    //     borderRadius: new BorderRadius.circular(12.0),
                    //     borderSide: new BorderSide(),
                    //   ),
                    // ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<dynamic>(
                        // hint: Text(
                        //   // hintText,
                        //   style: TextStyle(color: Colors.grey.shade500),
                        // ),
                        value: value == '' ? dataSource[0][valueField] : value,
                        onChanged: enable
                            ? (dynamic newValue) {
                                state.didChange(newValue);
                                onChanged(newValue);
                              }
                            : null,
                        items: dataSource.map((item) {
                          return DropdownMenuItem<dynamic>(
                            value: item[valueField],
                            child: Text(item[textField]),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(height: state.hasError ? 5.0 : 0.0),
                  Text(
                    state.hasError ? state.errorText : '',
                    style: TextStyle(
                        color: Colors.redAccent.shade700,
                        fontSize: state.hasError ? 12.0 : 0.0),
                  ),
                ],
              ),
            );
          },
        );
}
