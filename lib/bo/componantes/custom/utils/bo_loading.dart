import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class $LOADING {
  setConfig() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.blue
      ..backgroundColor = Colors.amber
      ..indicatorColor = Colors.red
      ..textColor = Colors.black
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = false
      ..dismissOnTap = false;
  }

  show(String message) async {
    await EasyLoading.show(
        status: message, maskType: EasyLoadingMaskType.black);
  }

  hide() async {
    await EasyLoading.dismiss();
  }
}
