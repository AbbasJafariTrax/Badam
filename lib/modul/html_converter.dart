import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;

Widget getHtmlFile(dataIn) {
  return Html(
    data: dataIn,
    padding: EdgeInsets.all(5.0),
    linkStyle: const TextStyle(
      color: Colors.redAccent,
      decorationColor: Colors.redAccent,
      decoration: TextDecoration.underline,
    ),
    onLinkTap: (url) {
      print("Opening $url...");
    },
    onImageTap: (src) {
      print(src);
    },
    //Must have useRichText set to false for this to work
    customRender: (node, children) {
      if (node is dom.Element) {
        switch (node.localName) {
          case "custom_tag":
            return Column(children: children);
        }
      }
      return null;
    },
    customTextAlign: (dom.Node node) {
      if (node is dom.Element) {
        switch (node.localName) {
          case "p":
            return TextAlign.right;
        }
      }
      return null;
    },
    customTextStyle: (dom.Node node, TextStyle baseStyle) {
      if (node is dom.Element) {
        switch (node.localName) {
          case "p":
            return baseStyle.merge(TextStyle(height: 1.2, fontSize: 15));
        }
      }
      return baseStyle;
    },
  );
}
