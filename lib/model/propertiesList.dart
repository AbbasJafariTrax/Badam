import 'dart:convert';
import 'package:badam_app/model/property.dart';
import 'package:http/http.dart' as http;

class PropertiesListModel {
 
  List<Property> properties;
  int statusCode;
  String errorMessage;
  int total;
  int nItems;

  PropertiesListModel.fromResponse(http.Response response) {
    this.statusCode = response.statusCode;
    List jsonData = json.decode(response.body);

    print(jsonData);

  }

  PropertiesListModel.withError(String errorMessage) {
    this.errorMessage = errorMessage;
  }
}
