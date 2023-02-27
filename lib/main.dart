import 'package:amoi/bo/componantes/bo_main/bo_main.dart';
import 'package:amoi/bo/componantes/bo_padding/bo_padding.dart';
import 'package:amoi/bo/componantes/custom/utils/bo_connectivite.dart';
import 'package:amoi/bo/componantes/custom/utils/bo_loading.dart';
import 'package:amoi/screen/admin.dart';
import 'package:amoi/screen/boite.dart';
import 'package:amoi/screen/dashboard.dart';
import 'package:amoi/screen/searchscreen.dart';
import 'package:amoi/screen/seconnect.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'bo/componantes/custom/utils/bo_toast.dart';
import 'bo/firebase/bo_firebase.dart';

String tableUser = 'Users';
String tableBoite = 'Boites';
String tableSetting = 'Settings';
String tableDemande = 'Demande';
String tableNotification = 'Notification';
$LOADING loading = $LOADING();
$TOAST toast = $TOAST();
$MAIN mainApp = $MAIN(title: 'AMOI');
$CONNECTIVITE connectivite = $CONNECTIVITE();
var f = NumberFormat("###.0#", "en_US");

$FIREBASE base = $FIREBASE();
CALCULATION calculBoite = CALCULATION();

late Map<String, dynamic> userActif;

String getDateNow() {
  return DateFormat('dd-MM-yyyy H:m:s')
      .format(DateTime.now().toUtc().add(const Duration(hours: 3)))
      .toString();
}

void main() async {
  // ANDROID
  WidgetsFlutterBinding.ensureInitialized();

  // FIREBASE
  await initFirebase();

  // main
  mainApp.initialRoot = '/seconnect';
  mainApp.screens = [
    screenSeconnect(rootName: '/seconnect'),
    screenDashboard(rootName: '/dashboard'),
    screenSearch(rootName: '/searchScreen'),
    screenAdministrator(rootName: '/admin'),
  ];

  // run APP
  runApp(mainApp);

  loading.setConfig();
}

Widget emptyBoite() {
  return $PADDING(
      all: 50,
      child: Column(children: const [
        Icon(
          Icons.new_releases,
          color: Colors.black12,
          size: 20,
        ),
        Text('Aucunne boite', style: TextStyle(color: Colors.black12))
      ]));
}
