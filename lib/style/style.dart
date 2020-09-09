import 'package:flutter/material.dart';

Widget welcomeText(String title,BuildContext context){

  return Text(title,style: TextStyle(fontSize: 30,color: Theme.of(context).primaryColor),);
}

Widget textMedim(String title, BuildContext context){

  return Text(title,style: TextStyle(fontSize: 16,color: Theme.of(context).primaryColor),);
}

TextStyle titleMedum(BuildContext context){

  return TextStyle(fontSize: 20,color: Theme.of(context).primaryColor);
}
TextStyle style_title_appbar(BuildContext context){

  return TextStyle(fontSize: 20,);
}

TextStyle feature_style(BuildContext context){

  return TextStyle(fontSize: 20,color: Theme.of(context).primaryColor);
}
