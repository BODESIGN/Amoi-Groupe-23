> afaka mampiasa :: loading (FACULTATIF)

> utilisation
mainBo(isHaveLoading: false, title: 'AMOI')
      ..initialRoot = 'HOME'
      ..screens = [
        const ScreenHome(rootName: 'HOME'),
        const ScreenProfile(rootName: 'PROFILE')
      ]
      
      
> like 

import 'package:bo/bo/componants/screen.dart';
import 'package:bo/bo/main/bo_main.dart';
import 'package:bo/bruillon/screen.dart';
import 'package:flutter/material.dart';

void main() {
  // ANDROID 
  WidgetsFlutterBinding.ensureInitialized();

  // FIREBASE

  // run APP
  runApp(
    
    $MAIN(title: 'AMOI')
      ..initialRoot = 'SE CONNECT'
      ..screens = [
        screenSeconnect(rootName: 'SE CONNECT'), 
      ]
  );
}
