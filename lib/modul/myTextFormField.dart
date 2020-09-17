import 'package:flutter/material.dart';

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
    final halfMediaWidth = MediaQuery.of(context).size.width / 2.0;
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
