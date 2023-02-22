// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class $PANE {
  $PANE({required this.contenue});
  int currentePage = 0;
  List<Widget> contenue;

  build() {
    return Container(child: contenue[currentePage]);
  }
}
