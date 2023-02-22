// ignore_for_file: camel_case_types, must_be_immutable

// ====================================================================
// install >> flutter pub add smooth_page_indicator
// ====================================================================

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class $PAGE extends StatefulWidget {
  $PAGE({
    super.key,
    this.currentIndex = 0,
    this.count = 0,
  });

  int currentIndex;
  int count;

  Color dotColor = Colors.black12;
  Color activeDot = Colors.blue;

  @override
  State<$PAGE> createState() => _bo_pager();
}

class _bo_pager extends State<$PAGE> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSmoothIndicator(
      activeIndex: widget.currentIndex,
      count: widget.count,
      effect: WormEffect(
          dotWidth: 10,
          dotHeight: 10,
          dotColor: widget.dotColor,
          activeDotColor: widget.activeDot),
    );
  }
}
