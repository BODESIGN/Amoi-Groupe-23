// ignore_for_file: non_constant_identifier_names

import 'package:amoi/main.dart';
import 'package:amoi/screen/boite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../../firebase_options.dart';

// ===============================================================================

initFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

// ===============================================================================

class $FIREBASE {
  $FIREBASE();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // > SELECT
  select(
    String table,
    String id,
    Function actionAfter,
  ) {
    firestore.collection(table).doc(id).get().then(
      (DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) actionAfter('succes', documentSnapshot);
        if (!documentSnapshot.exists) actionAfter('error', 'Not exist');
      },
    ).catchError((error) {
      actionAfter('error', error);
    });
  }

  // > INSERT
  insert(
    String table,
    String id,
    Map<String, dynamic> donner,
    Function actionAfter,
  ) {
    firestore
        .collection(table)
        .doc(id)
        .set(donner)
        .then((value) => {actionAfter('succes', value)})
        .catchError((error) => {actionAfter('error', error)});
  }

  void insertNotification(
      String login, String title, String description, Function actionAfter) {
    String now = getDateNow();
    firestore
        .collection('$tableUser//$login//$tableNotification')
        .doc(now)
        .set({
          'date': now,
          'description': description,
          'title': title,
          'vu': false
        })
        .then((value) => {actionAfter('succes', value)})
        .catchError((error) => {actionAfter('error', error)});
  }

  void updateAriary(
    String login,
    int montant,
    Function actionAfter,
  ) {
    firestore
        .collection(tableUser)
        .doc(login)
        .update(
          {"ariary": FieldValue.increment(montant)},
        )
        .then((value) => {actionAfter('succes', value)})
        .catchError((error) => {actionAfter('error', error)});
  }

  void updateDemande(
    String tableDemande,
    String type,
    Map<String, dynamic> donner,
    Function actionAfter,
  ) {
    firestore
        .collection(tableDemande)
        .doc(type)
        .set(donner)
        .then((value) => {actionAfter('succes', value)})
        .catchError((error) => {actionAfter('error', error)});
  }

// BOITES
// =================================

  void select_Boite_Unique(
    String code,
    Function actionAfter,
  ) {
    firestore.collection(tableBoite).doc(code).get().then(
      (DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) actionAfter('succes', documentSnapshot);
        if (!documentSnapshot.exists) actionAfter('error', 'Not exist');
      },
    ).catchError((error) {
      actionAfter('error', error);
    });
  }

  void select_Boite(String tableBoite, List mesBoites, Function actionAfter,
      {bool isIamNotIn = false}) {
    firestore.collection(tableBoite).get().then((querySnapshot) {
      List<Map> boites = [];
      List<Map> boitesImNotIn = [];
      querySnapshot.docs.forEach((result) {
        if (checIamInBoite(mesBoites, result.data())) {
          boites.add(result.data());
        } else {
          boitesImNotIn.add(result.data());
        }
      });
      actionAfter(isIamNotIn ? boitesImNotIn : boites);
    }).onError((error, stackTrace) => actionAfter([]));
  }

  void selectNotifications(
    String table,
    Function actionAfter,
  ) {
    firestore.collection(tableBoite).get().then((querySnapshot) {
      List<Map> notifications = [];
      querySnapshot.docs.forEach((result) {
        notifications.add(result.data());
      });
      actionAfter(notifications);
    }).onError((error, stackTrace) => actionAfter([]));
  }

  void rejoindreBoite(
    String login,
    String boiteCode,
    int montant,
    Function actionAfter,
  ) {
    firestore
        .collection(tableUser)
        .doc(login)
        .update(
          {
            "token": FieldValue.increment(-montant),
            "boites": FieldValue.arrayUnion([boiteCode])
          },
        )
        .then((value) => {actionAfter('succes')})
        .catchError((error) => {actionAfter('error')});
  }

  void quitBoite(
    String login,
    String boiteCode,
    double montant,
    Function actionAfter,
  ) {
    firestore
        .collection(tableUser)
        .doc(login)
        .update(
          {
            "token": FieldValue.increment(montant),
            "boites": FieldValue.arrayRemove([boiteCode])
          },
        )
        .then((value) => {actionAfter('succes')})
        .catchError((error) => {actionAfter('error')});
  }
}
