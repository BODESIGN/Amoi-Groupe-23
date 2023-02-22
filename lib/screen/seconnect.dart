// ignore_for_file: camel_case_types, must_be_immutable

import 'package:amoi/bo/componantes/bo_label/bo_label.dart';
import 'package:amoi/main.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../bo/componantes/bo_main/bo_main.dart';
import '../bo/componantes/bo_button/bo_button.dart';
import '../bo/componantes/bo_checbox/bo_checbox.dart';
import '../bo/componantes/bo_input/bo_input.dart';
import '../bo/componantes/bo_padding/bo_padding.dart';
import '../bo/componantes/bo_pane/bo_pane.dart';

import 'dart:io';
import 'package:flutter/services.dart';

class screenSeconnect extends StatefulWidget {
  screenSeconnect({super.key, required this.rootName});

  String rootName;

  @override
  State<screenSeconnect> createState() => _screenSeconnectState();
}

class _screenSeconnectState extends State<screenSeconnect> {
  $INPUT inputLogin =
      $INPUT(label: 'Login', width: 100, prefixIcon: Icons.person);
  $INPUT inputMotdepasse = $INPUT(
      label: 'Mot de passe',
      width: 100,
      isMotDePasse: true,
      prefixIcon: Icons.lock);
  $BUTTON btSeconnect = $BUTTON(text: 'Se connecter')
    ..radius = 50
    ..elevation = 5;
  $BUTTON btNewcompte =
      $BUTTON(text: 'Créer un compte', type: textButton, color: Colors.black);
  $BUTTON btRetourtoseconnect =
      $BUTTON(text: 'Retour', type: textButton, color: Colors.black);
  $CHECBOX checRemember = $CHECBOX(text: 'Memoriser');
  $PANE panel = $PANE(contenue: []);

  $INPUT inputLoginNew =
      $INPUT(label: 'Nouveau Login', width: 100, prefixIcon: Icons.person);
  $INPUT inputFullname = $INPUT(label: 'Nom complet', width: 100);
  $INPUT inputMdpNew =
      $INPUT(label: 'Nouveau mot de passe', width: 100, isMotDePasse: true);
  $INPUT inputMdpNew2 =
      $INPUT(label: 'Nouveau mot de passe', width: 100, isMotDePasse: true);

  $BUTTON btNouveauCompte = $BUTTON(text: 'Créer compte')
    ..radius = 50
    ..elevation = 5;

  // TODO : confirm new mot de passe
  $INPUT inputMotdepasseNew = $INPUT(
      label: 'Nouveau mot de passe',
      width: 100,
      isMotDePasse: true,
      prefixIcon: Icons.lock);
  $INPUT inputMotdepasseNewConfirm = $INPUT(
      label: 'Nouveau mot de passe',
      width: 100,
      isMotDePasse: true,
      prefixIcon: Icons.lock);

  //

  seConnect(BuildContext context) async {
    String login = inputLogin.getValue();
    if (login == '') toast.show('Login obligatoire');
    if (login == '') return;

    String mdp = inputMotdepasse.getValue();
    if (mdp == '') toast.show('Mot de passe obligatoire');
    if (mdp == '') return;

    // chec connexion
    if (!await connectivite.checkData(toast.show)) return;

    // LOADIN START
    loading.show('chargement ...');

    // base
    base.select(tableUser, login, (result, value) {
      if (result == 'error') toast.show('Compte inconnue !');
      if (result == 'error') loading.hide();
      if (result == 'error') return;

      userActif = value.data() as Map<String, Object?>;

      if (userActif['login'] == login) {
        if (userActif['motdepasse'] == mdp) {
          base.select(tableSetting, 'Administrator', (result, value) {
            if (result == 'error') toast.show('Erreur dans get calculation !');
            if (result == 'error') loading.hide();
            if (result == 'error') return;

            Map<String, Object?> admins = value.data() as Map<String, Object?>;
            // LOADING STOP
            loading.hide();

            for (var code in admins['listAdmin'] as List) {
              if (code.toString() == userActif['login']) {
                changeScreen(context, '/admin');
                return;
              }
            }
            // PASS
            changeScreen(context, '/dashboard');
          });
        } else {
          // compte déjat pris
          toast.show('Mot de passe incorrect !');
          // LOADING STOP
          loading.hide();
        }
      }
    });
  }

  createNewCompte() async {
    String newLogin = inputLoginNew.getValue();
    if (newLogin == '') toast.show('Login obligatoire');
    if (newLogin == '') return;

    if (newLogin == 'vide') toast.show('Login déjà pris !');
    ;
    if (newLogin == 'vide') return;

    if (newLogin == 'AMOI') toast.show('Login déjà pris !');
    ;
    if (newLogin == 'AMOI') return;

    // chec connexion
    if (!await connectivite.checkData(toast.show)) return;

    // LOADIN START
    loading.show('chargement ...');

    // chec user : EXIST
    if (panel.currentePage == 1) createNewCompte_checUser(newLogin);
    if (panel.currentePage == 2) createNewCompte_inserNew(newLogin);
  }

  createNewCompte_checUser(String userLoginNew) {
    base.select(tableUser, userLoginNew, (result, value) {
      if (result == 'error') setState(() => {panel.currentePage = 2});
      if (result == 'error') loading.hide();
      if (result == 'error') return;

      late Map<String, dynamic> user;
      user = value.data() as Map<String, Object?>;
      if (user['login'] == userLoginNew) {
        // compte déjat pris
        toast.show('Login déjà pris !');
        // LOADING STOP
        loading.hide();
      }
    });
  }

  createNewCompte_inserNew(String userLoginNew) {
    if (inputMdpNew.getValue() != inputMdpNew2.getValue()) {
      toast.show('Les Mot de passes ne correspond pas');
      loading.hide();
      return;
    }

    if (inputFullname.getValue() == '' ||
        inputMdpNew.getValue() == '' ||
        inputMdpNew2.getValue() == '') {
      toast.show('Tout les champs son obligatoire');
      loading.hide();
      return;
    }

    userActif = {
      'fullname': inputFullname.getValue(),
      'motdepasse': inputMdpNew.getValue(),
      'login': userLoginNew,
      'token': 0.0,
      'ariary': 0.0,
      'urlPdp': '',
      'dateCreate': getDateNow(),
      'boites': []
    };

    base.insert(tableUser, userLoginNew, userActif, (result, value) {
      // compte déjat pris
      toast.show(result == 'succes'
          ? 'Insertion avec succes !'
          : 'Une problème est survenue !');

      // LOADING STOP
      loading.hide();

      // pass
      changeScreen(context, '/dashboard');
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light
    ));
    
    toast.init(context);

    inputLogin.width = inputMotdepasse.width = inputMotdepasseNew.width =
        inputMotdepasseNewConfirm.width = inputFullname.width =
            inputMdpNew.width = inputMdpNew2.width =
                inputLoginNew.width = MediaQuery.of(context).size.width;
    btSeconnect.setAction(() {
      seConnect(context);
    });
    btNewcompte.setAction(() => setState(() => {panel.currentePage = 1}));
    btRetourtoseconnect
        .setAction(() => setState(() => {panel.currentePage = 0}));
    btNouveauCompte.setAction(() => {createNewCompte()});

    panel.contenue = [
      // PAGE 1
      SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                // container Logo
                const SizedBox(height: 80),
                Center(
                    child: Column(children: [
                  SizedBox(
                      width: 60,
                      height: 60,
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                              child: Image.asset("assets/logo/logowhite.png",
                                  width: 40, height: 40)))),
                  const SizedBox(height: 10),
                  $LABEL(
                      text: 'AMOI Groupe',
                      textColor: Colors.black,
                      textSize: 17)
                ])),

                // Container Inputs
                $PADDING(
                    top: 80,
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: inputLogin),
                $PADDING(
                    top: 0,
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: inputMotdepasse),

                // container Button
                $PADDING(left: 20, right: 20, child: btSeconnect),

                // container Button 2
                $PADDING(
                    top: 10,
                    left: 30,
                    right: 30,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          btNewcompte,
                          // checRemember,
                        ])),
              ])),

      // PAGE 2 > new COMPTE - chec login
      SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                // container Logo
                const SizedBox(height: 80),
                Center(
                    child: Column(children: [
                  SizedBox(
                      width: 60,
                      height: 60,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: Image.asset("assets/logo/logowhite.png",
                                width: 40, height: 40)),
                      )),
                  const SizedBox(height: 10),
                  const Text('AMOI Groupe',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 17))
                ])),
                const SizedBox(height: 80),

                $LABEL(
                    text: 'Nouveau compte',
                    textColor: Colors.grey,
                    textSize: 12),
                $LABEL(text: '---', textColor: Colors.grey, textSize: 15),

                // Container Inputs
                $PADDING(
                    top: 10,
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: inputLoginNew),

                // container Button
                $PADDING(left: 20, right: 20, child: btNouveauCompte),

                // container Button 2
                $PADDING(
                    left: 30,
                    right: 30,
                    top: 10,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [btRetourtoseconnect]))
              ])),

      // PAGE 3 > new COMPTE - info
      SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                // container Logo
                const SizedBox(height: 40),
                Center(
                    child: Column(children: [
                  SizedBox(
                      width: 60,
                      height: 60,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: Image.asset("assets/logo/logowhite.png",
                                width: 40, height: 40)),
                      )),
                  const SizedBox(height: 10),
                  const Text('AMOI Groupe',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 17))
                ])),
                const SizedBox(height: 40),

                $LABEL(
                    text: 'Nouveau compte',
                    textColor: Colors.grey,
                    textSize: 12),
                $LABEL(text: '---', textColor: Colors.grey, textSize: 15),

                // Container Inputs
                $PADDING(
                    top: 10,
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: inputFullname),
                $PADDING(
                    top: 10,
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: inputMdpNew),
                $PADDING(
                    top: 10,
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: inputMdpNew2),

                // container Button
                $PADDING(left: 20, right: 20, child: btNouveauCompte),

                // container Button 2
                $PADDING(
                    left: 30,
                    right: 30,
                    top: 10,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [btRetourtoseconnect]))
              ]))
    ];

    return WillPopScope(
      onWillPop: () async {
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else if (Platform.isIOS) {
          exit(0);
        }
        return false;
      },
      child: SafeArea(
        child: Scaffold(body: panel.build()),
      ),
    );
  }
}
