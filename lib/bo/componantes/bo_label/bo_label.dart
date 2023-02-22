// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, camel_case_types

import 'package:flutter/widgets.dart';

// ======================================

FontWeight bold = FontWeight.bold;
FontWeight normal = FontWeight.normal;
FontWeight light = FontWeight.w200;

// ======================================

class $LABEL extends StatefulWidget {
  $LABEL({
    required this.text,
    required this.textColor,
    required this.textSize,
  }) {
    setStyle();
  }

  @override
  State<$LABEL> createState() => _boLabel();

  String text;
  Color textColor;
  double textSize;
  FontWeight weight = normal;
  late TextStyle style;

// ======================================

  setText(String text) => this.text = text;

  setColorText(Color textColor) {
    this.textColor = textColor;
    setStyle(textColor: textColor);
  }

  setFontSize(double textSize) {
    this.textSize = textSize;
    setStyle(textSize: textSize);
  }

  setFontWeight(FontWeight weight) {
    this.weight = weight;
    setStyle(weight: weight);
  }

// ======================================

  void setStyle({Color? textColor, double? textSize, FontWeight? weight}) {
    style = TextStyle(
        color: textColor ?? this.textColor,
        fontSize: textSize ?? this.textSize,
        fontWeight: weight ?? this.weight);
  }
}

class _boLabel extends State<$LABEL> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.text, style: widget.style);
  }
}
