// ignore_for_file: camel_case_types, must_be_immutable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

// ==============================================================

// install > flutter pub add carousel_slider

// ==============================================================

class $CAROUSEL extends StatefulWidget {
  $CAROUSEL({
    super.key,
    required this.actionOnChangePage,
    required this.listItems,
  });

  CarouselController controler = CarouselController();
  List<Widget> listItems;
  Function actionOnChangePage;
  int currentIndex = 0;

  double elevation = 10;
  Color shadowColor = Colors.black38;
  Color color = Colors.white;

  double radius = 10;
  double paddingAll = 8;

  setIndex(int index) => currentIndex = index;

  @override
  State<$CAROUSEL> createState() => _bo_carousel();
}

class _bo_carousel extends State<$CAROUSEL> {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      carouselController: widget.controler,
      options: CarouselOptions(
        enlargeCenterPage: true,
        enableInfiniteScroll: true,
        viewportFraction: 1,
        aspectRatio: 1,
        initialPage: widget.currentIndex,
        pageSnapping: true,
        onPageChanged: (index, reason) {
          widget.setIndex(index);
          widget.actionOnChangePage(index);
        },
      ),
      items: widget.listItems.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return SizedBox(
                width: double.maxFinite,
                height: double.maxFinite,
                child: Padding(
                  padding: EdgeInsets.all(widget.paddingAll),
                  child: Material(
                      elevation: widget.elevation,
                      color: widget.color,
                      shadowColor: widget.shadowColor,
                      borderRadius: BorderRadius.circular(widget.radius),
                      child: i),
                ));
          },
        );
      }).toList(),
    );
  }
}
