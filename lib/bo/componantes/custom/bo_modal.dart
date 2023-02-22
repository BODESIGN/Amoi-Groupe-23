// ignore_for_file: prefer_final_fields

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class $MODALE {
  $MODALE(
    this.context,
    this.title,
    this.subTitle,
  );

  BuildContext context;
  String type = 'BUTTONS';
  Widget child = Container();

  bool isShowed = false;

  String title;
  String subTitle;

  String labelButton1 = 'BUTTON 1';
  String labelButton2 = 'BUTTON 2';
  String labelButton3 = 'BUTTON 3';
  Function action1 = () {};
  Function action2 = () {};
  Function action3 = () {};
  IconData? icon1;
  IconData? icon2;
  IconData? icon3;

  void hide() {
    if (!isShowed) return;
    isShowed = false;
    Navigator.pop(context);
  }

  void show() {
    isShowed = true;
    switch (type) {
      case 'BUTTONS':
        showCupertinoModalPopup<void>(
            context: context,
            builder: (BuildContext context) => CupertinoActionSheet(
                    title: Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blue)),
                    message: Text(subTitle,
                        style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: Colors.grey)),
                    actions: <CupertinoActionSheetAction>[
                      CupertinoActionSheetAction(
                        isDefaultAction: true,
                        onPressed: () {
                          action1();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (icon1 != null) Icon(icon1, color: Colors.blue),
                            if (icon1 != null) const SizedBox(width: 10),
                            Text(labelButton1,
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      CupertinoActionSheetAction(
                        onPressed: () {
                          action2();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (icon2 != null) Icon(icon2, color: Colors.blue),
                            if (icon2 != null) const SizedBox(width: 10),
                            Text(labelButton2,
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      CupertinoActionSheetAction(
                          isDestructiveAction: true,
                          onPressed: () {
                            action3();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            if (icon3 != null) Icon(icon3),
                            if (icon3 != null) const SizedBox(width: 5),
                              Text(labelButton3,
                                  style: const TextStyle(
                                      fontSize: 13, fontWeight: FontWeight.bold)),
                            ],
                          ))
                    ]));
        break;
      default:
        // container
        showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.black12,
            builder: (BuildContext context) {
              return SingleChildScrollView(
                  child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: child,
                      )));
            });
    }
  }
}
