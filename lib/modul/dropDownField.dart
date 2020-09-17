import 'package:flutter/material.dart';

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
                      fontSize: state.hasError ? 12.0 : 0.0,
                    ),
                  ),
                ],
              ),
            );
          },
        );
}
