import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class $TOAST {
  init(BuildContext context) {
    ToastContext().init(context);
  }

  show(String msg, {int? duration = 3, int? gravity = Toast.top}) {
    Toast.show(msg, duration: duration, gravity: gravity);
  }
}
