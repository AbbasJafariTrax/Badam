import 'dart:async';
import 'package:badam_app/style/style.dart';
import 'package:badam_app/util/httpRequest.dart';
import 'package:badam_app/util/sharedPreference.dart';
import 'package:badam_app/util/utiles_functions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfilePage();
  }
}

class _ProfilePage extends State<ProfilePage> {
  String username = "";
  String displayName = "";
  String password = "";
  String displayLast = "";
  String profileUrl = "";
  String temProfileUrl = "";
  String userId = "";
  String imageId = "";
  bool dont = false;

  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

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
        }),
        readPreferenceString("displayName").then((dataName) {
          if (dataName != null) {
            this.displayName = dataName;
          }
        }),
        readPreferenceString("displayLast").then((dataLast) {
          if (dataLast != null) {
            this.displayLast = dataLast;
          }
        }),
        readPreferenceString("profileUrl").then((pro) {
          if (pro != null) {
            this.profileUrl = pro;
          }
        })
      ]);

      return Future.value(responses);
    } catch (e) {
      print("error");
    }
  }

  File _imageFile;
  bool _isUploadingImage = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  
  void _getImage(BuildContext context, ImageSource source) async {
    File image = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = image;
    });

    Navigator.pop(context);

    if (_imageFile != null) {
      _cropImage();
    }

    if (_imageFile != null) {
      setState(() {
        _isUploadingImage = true;
      });
      getToken(getPhoneforuser(this.username), this.password).then((value) {
        Map<String, dynamic> tokens = json.decode(value.body);
        String token = tokens['token'];
        uploadImageMedia(_imageFile, token).then((data) {
          Map<String, dynamic> d = json.decode(data);

          setState(() {
            _isUploadingImage = false;
            this.imageId = d['id'].toString();
            this.temProfileUrl = d['guid']['rendered'];
          });
        });
      });
    }
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _imageFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
              ]
            : [
                CropAspectRatioPreset.square,
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
      setState(() {
        _imageFile = croppedFile;
      });
    }
  }

  void _startUploading() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      var name = displayName;
      var last = displayLast;
      
      print(name);
      if (_isUploadingImage) {
        _scaffoldKey.currentState.showSnackBar(
          new SnackBar(
            backgroundColor: Colors.redAccent,
            content: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(
                  "انترنت تان را چک کنید",
                  style: TextStyle(fontFamily: "Vazir"),
                ),
              ],
            ),
          ),
        );
        return null;
      } else {

        setState(() {
          _isLoading = true;
        });

        updateProfileContent(
          displayLast: last,
          displayName: name,
          imageId: this.imageId,
          userId: this.userId,
        ).then((respon) {
          print("last :" + name);

          savePreferenceString("displayLast", last).then((data) {
            savePreferenceString("displayName", name).then((data) {
              if (temProfileUrl != "") {
                profileUrl = temProfileUrl;

                savePreferenceString("profileUrl", profileUrl).then((data) {
                  setState(() {
                    _isLoading = false;
                    _imageFile = null;
                  });
                });
              } else {
                setState(() {
                  _isLoading = false;
                  _imageFile = null;
                });
              }

              Navigator.pop(context);
              
            });
          });
        });
      }
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

  Widget _ImageProfile() {
    return _imageFile == null
        ? profileUrl == ""
            ? Text(
                displayName.substring(0, 1) + displayLast.substring(1, 2),
                style: TextStyle(fontSize: 30),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: FadeInImage.assetNetwork(
                    placeholder: "",
                    alignment: Alignment.topCenter,
                    fit: BoxFit.cover,
                    height: 150.0,
                    width: 150,
                    image: (profileUrl)))
        : ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.file(
              _imageFile,
              fit: BoxFit.cover,
              height: 150.0,
              alignment: Alignment.topCenter,
              width: MediaQuery.of(context).size.width,
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('تنظیمات پروفایل'),
          actions: <Widget>[
            FlatButton(
                onPressed: () => Navigator.pushNamed(context, "/imagecrop"),
                child: Text("imageCroperr")),
          ],
        ),
        body: FutureBuilder(
          future: getUsername(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0, left: 10.0, right: 10.0),
                              child: GestureDetector(
                                onTap: () => !_isUploadingImage
                                    ? _openImagePickerModal(context)
                                    : null,
                                child: Container(
                                  width: 150,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      _ImageProfile(),
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
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                  textDirection: TextDirection.rtl,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'نام تان را وارد کنید';
                                    }
                                    return null;
                                  },
                                  onSaved: (String value) {
                                    this.displayName = value;
                                  },
                                  initialValue: displayName,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    labelText: 'نام تان را وارد کنید ',
                                  ),
                                  obscureText: false),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                  textDirection: TextDirection.rtl,
                                  initialValue: displayLast,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'تخلص تان را وارد کنید';
                                    }
                                    return null;
                                  },
                                  onSaved: (String value) {
                                    this.displayLast = value;
                                  },
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    labelText: 'تخلص تان را وارد کنید ',
                                  ),
                                  obscureText: false),
                            ),
                            SizedBox(
                              height: 20,
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
                                  onPressed: () {
                                    _startUploading();
                                  },
                                  child: submitButton(),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            )
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
        ));
  }
}
