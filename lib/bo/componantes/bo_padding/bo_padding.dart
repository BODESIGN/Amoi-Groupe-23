// ignore_for_file: non_constant_identifier_names, no_leading_underscores_for_local_identifiers, camel_case_types, must_be_immutable

import 'package:flutter/material.dart';

class $PADDING extends StatefulWidget {
  $PADDING({
    super.key,
    this.left = 0,
    this.top = 0,
    this.right = 0,
    this.bottom = 0,
    this.all = 0,
    required this.child,
  });

  double left;
  double top;
  double right;
  double bottom;
  double all;
  Widget child;

  @override
  State<$PADDING> createState() => _boPadding();
}

class _boPadding extends State<$PADDING> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: widget.all > 0
            ? EdgeInsets.all(widget.all)
            : EdgeInsets.fromLTRB(
                widget.left,
                widget.top,
                widget.right,
                widget.bottom,
              ),
        child: widget.child);
  }
}
