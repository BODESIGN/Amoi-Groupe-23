// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, camel_case_types, non_constant_identifier_names

import 'package:flutter/material.dart';
import '../bo_label/bo_label.dart';

// ======================================

String simpleButton = 'SIMPLE';
String textButton = 'TEXT';
String iconButton = 'ICON';
String iconButtonNoBordur = 'ICON-NO-BORDURE';

// ======================================

class $BUTTON extends StatefulWidget {
  $BUTTON({
    this.height = 55,
    this.radius = 10,
    required String text,
    this.type = 'SIMPLE',
    Color color = Colors.white,
  }) {
    setText($LABEL(text: text, textColor: color, textSize: 14));
  }

  @override
  State<$BUTTON> createState() => _boButton();

  String type;

  double height;
  double radius;
  double elevation = 10;

  late $LABEL label;
  Color bg_color = Colors.blue;
  Color splash_color = Colors.blueAccent;
  Color color = Colors.white;
  Color shadow_color = Colors.grey;

  IconData icon = Icons.accessibility_rounded;

  double border_width = 0;
  Color border_color = Colors.transparent;

  Function action = () {};

  setText($LABEL label) {
    this.label = label;
  }

  setAction(Function action) {
    this.action = () {
      action();
    };
  }
}

class _boButton extends State<$BUTTON> {
  // SIMPLE >> DEFAULT
  Widget simpleButton(BuildContext context) {
    // = 'SIMPLE'
    return SizedBox(
        height: widget.height,
        child: Ink(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(widget.radius),
            ),
            child: Material(
                elevation: widget.elevation,
                shadowColor: widget.shadow_color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  // borderRadius: BorderRadius.circular(widget.radius),
                  // side: BorderSide(
                  //     color: widget.shadow_color, width: widget.border_width),
                ),
                color: widget.bg_color,
                child: InkWell(
                    splashColor: widget.splash_color,
                    // borderRadius: BorderRadius.circular(widget.radius),

                    onTap: (() => {widget.action()}),
                    child: Center(
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: widget.label))))));
  }

  // SIMPLE >> DEFAULT
  Widget textButton(BuildContext context) {
    // = 'TEXT'
    return TextButton(
        onPressed: () {
          widget.action();
        },
        child: widget.label);
  }

  // SIMPLE >> DEFAULT
  Widget iconButton(BuildContext context) {
    // = 'ICON'
    return SizedBox(
        height: widget.height,
        width: widget.height,
        child: Card(
            elevation: 0,
            color: Colors.transparent,
            child: Material(
                color: widget.bg_color,
                elevation: widget.elevation,
                shadowColor: widget.shadow_color,
                // borderRadius: BorderRadius.circular(widget.radius),
                shape: RoundedRectangleBorder(
                  // borderRadius: BorderRadius.circular(10),
                  borderRadius: BorderRadius.circular(widget.radius),
                  side: BorderSide(
                      color: widget.shadow_color, width: widget.border_width),
                ),
                child: InkWell(
                    splashColor: Colors.blue,
                    borderRadius: BorderRadius.circular(widget.radius),
                    onTap: (() => {widget.action()}),
                    child: Center(
                        child: Icon(widget.icon, color: widget.color))))));
  }

  Widget iconButtonNoBordur(BuildContext context) {
    // = 'ICON'
    return SizedBox(
        height: widget.height,
        width: widget.height,
        child: Card(
            elevation: 0,
            color: Colors.transparent,
            child: Material(
                color: widget.bg_color,
                elevation: widget.elevation,
                shadowColor: widget.shadow_color,
                // borderRadius: BorderRadius.circular(widget.radius),
                shape: RoundedRectangleBorder(
                  // borderRadius: BorderRadius.circular(10),
                  borderRadius: BorderRadius.circular(widget.radius),
                ),
                child: InkWell(
                    splashColor: Colors.blue,
                    borderRadius: BorderRadius.circular(widget.radius),
                    onTap: (() => {widget.action()}),
                    child: Center(
                        child: Icon(widget.icon, color: widget.color))))));
  }

  // => BUILD
  @override
  Widget build(BuildContext context) {
    return widget.type == 'TEXT'
        ? textButton(context)
        : widget.type == 'ICON'
            ? iconButton(context)
            : widget.type == 'ICON-NO-BORDURE'
                ? iconButtonNoBordur(context)
                : simpleButton(context);
  }
}
