// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

// ====================================================================

changeScreen(BuildContext context, String rootName) {
  Navigator.of(context).pushNamed(rootName);
}

// ====================================================================

class $MAIN extends StatelessWidget {
  $MAIN({super.key, required this.title});

  String title;
  bool isDebug = false;
  bool isDark = false;
  String initialRoot = 'testScreen';
  List screens = [
    const ScreenTest(rootName: 'testScreen'),
  ];

  Function actionOnBuilder = () {};

  setActionBuilder(Function action) {
    actionOnBuilder = () {
      action();
    };
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarIconBrightness:
          isDark ? Brightness.dark : Brightness.light,
      statusBarIconBrightness: isDark ? Brightness.dark : Brightness.light,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
    ));

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(
          useMaterial3: true,
            pageTransitionsTheme: const PageTransitionsTheme(builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder()
            }),
            primaryColor: Colors.black),
        // builder: actionOnBuilder(),
        builder: EasyLoading.init(),
        initialRoute: initialRoot,
        routes: {
          for (var n = 0; n < screens.length; n++)
            screens[n].rootName.toString(): (context) => screens[n]
        });
  }
}

// --------------------------------------------------------------------------
class ScreenTest extends StatefulWidget {
  const ScreenTest({super.key, required this.rootName});

  final String rootName;

  @override
  State<ScreenTest> createState() => _ScreenTestState();
}

class _ScreenTestState extends State<ScreenTest> {
  @override
  Widget build(BuildContext context) {
    return const Text('Hello');
  }
}
