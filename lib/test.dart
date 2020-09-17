import 'dart:io';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Test_home extends StatefulWidget {
  @override
  _Test_homeState createState() => _Test_homeState();
}

class _Test_homeState extends State<Test_home> {
  static final String uploadEndPoint =
      'http://localhost/flutter_test/upload_image.php';
  Future<File> _file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error Uploading Image';

  chooseImage() {
    tmpFile.readAsBytesSync();
    setState(() {
      _file = ImagePicker.pickImage(source: ImageSource.gallery);
    });
    setStatus('');
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  startUpload() {
    setStatus('Uploading Image...');
    if (null == tmpFile) {
      setStatus(errMessage);
      return;
    }
    String fileName = tmpFile.path.split('/').last;
    upload(fileName);
  }

  upload(String _fileName) async {

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

      final url = 'https://www.badam.af/wp-json/wp/v2/property';
      Map<String, String> _urlHeader = {'Authorization': ''};

      _urlHeader['Authorization'] = 'Bearer $mToken';

      http.post(
        url,
        headers: _urlHeader,
        body: {
          "image": base64Image,
          "name": _fileName,
        },
      ).then((response) {
        print(response.statusCode);
        String jsonsDataString = response.body.toString();
        var _data = jsonDecode(jsonsDataString);
        print("Hi Mahdi V ${_data.toString()}");
        print(
            "Hi Mahdi V ${response.statusCode == 200 ? response.body : errMessage}");
      }).catchError((e) => print("Hi Mahdi E $e"));
    } catch (e) {
      print("Mahdi: $e");
    }
  }

  Widget showImage() {
    return SizedBox(
      height: 200,
      child: FutureBuilder<File>(
        future: _file,
        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              null != snapshot.data) {
            tmpFile = snapshot.data;
            base64Image = base64Encode(snapshot.data.readAsBytesSync());
            return Flexible(
              child: Image.file(
                snapshot.data,
                fit: BoxFit.fitHeight,
              ),
            );
          } else if (null != snapshot.error) {
            return const Text(
              'Error Picking Image',
              textAlign: TextAlign.center,
            );
          } else {
            return const Text(
              'No Image Selected',
              textAlign: TextAlign.center,
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Image Demo"),
      ),
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            OutlineButton(
              onPressed: chooseImage,
              child: Text('Choose Image'),
            ),
            SizedBox(
              height: 20.0,
            ),
            showImage(),
            SizedBox(
              height: 20.0,
            ),
            OutlineButton(
              onPressed: startUpload,
              child: Text('Upload Image'),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              status,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w500,
                fontSize: 20.0,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
