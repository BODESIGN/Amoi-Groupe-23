// ignore_for_file: non_constant_identifier_names, must_be_immutable, camel_case_types

import 'package:flutter/material.dart';

class $CONTAINER extends StatefulWidget {
  $CONTAINER({
    super.key,
    required this.context,
    required this.child,
    this.ratio_y = 1,
    this.ratio_x = 1,
  }) {
    max_y = MediaQuery.of(context).size.height;
    max_x = MediaQuery.of(context).size.width;
  }

  double ratio_y;
  double max_y = 1;
  double ratio_x;
  double max_x = 1;

  BuildContext context;
  Widget child;

  @override
  State<$CONTAINER> createState() => _bo_container();
}

class _bo_container extends State<$CONTAINER> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.ratio_y * widget.max_y,
      width: widget.ratio_x * widget.max_x,
      child: widget.child,
    );
  }
}
