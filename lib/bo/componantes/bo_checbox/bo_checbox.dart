// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, camel_case_types, non_constant_identifier_names

import 'package:flutter/material.dart';
import '../bo_label/bo_label.dart';

// ======================================

class $CHECBOX extends StatefulWidget {
  $CHECBOX({required String text}) {
    setText($LABEL(text: text, textColor: color, textSize: 14));
  }

  Color color = Colors.blue;
  late $LABEL label;
  Function action = () {};

  bool isChecked = false;
  bool isRound = true;

  chec() {
    isChecked = !isChecked;
  }

  setText($LABEL label) {
    this.label = label;
  }

  setAction(Function action) {
    this.action = () {
      action();
    };
  }

  bool getValue() {
    return isChecked;
  }

  @override
  State<$CHECBOX> createState() => _boChecbox();
}

class _boChecbox extends State<$CHECBOX> {
  bool isChecked = false;
  chec() {
    setState(() {
      isChecked = !isChecked;
    });
  }

  // => BUILD
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Checkbox(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          activeColor: widget.color,
          shape: widget.isRound ? const CircleBorder() : null,
          value: widget.isChecked,
          onChanged: ((value) {
            chec();
            widget.chec();
            widget.action();
          })),
      TextButton(
          onPressed: () {
            chec();
            widget.chec();
            widget.action();
          },
          child: widget.label)
    ]);
  }
}
