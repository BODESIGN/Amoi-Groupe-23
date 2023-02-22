> Utilisation
class SeConnect extends SCREEN

> example
import 'package:bo/bo/componantes/bo_screen/screen.dart';
import 'package:flutter/material.dart';

class SeConnect extends SCREEN {
  const SeConnect({super.key, required super.rootName});

  @override
  State<SeConnect> createState() => _SeConnectState();
}

class _SeConnectState extends State<SeConnect> {
  @override
  Widget build(BuildContext context) {
    return Text("HELLO WORLD");
  }
}
