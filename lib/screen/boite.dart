// ignore_for_file: camel_case_types, must_be_immutable, non_constant_identifier_names, no_leading_underscores_for_local_identifiers

import 'dart:math';

import 'package:amoi/bo/componantes/bo_button/bo_button.dart';
import 'package:amoi/bo/componantes/bo_padding/bo_padding.dart';
import 'package:amoi/bo/firebase/bo_firebase.dart';
import 'package:amoi/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../bo/componantes/bo_label/bo_label.dart';
import '../bo/componantes/custom/bo_modal.dart';

// ===============================================================================

late Map<String, dynamic> calculationBoite;
late Map<String, dynamic> calculationToken;

class CALCULATION {
  init() {
    loading.show('Chargement des calcules');
    // base
    base.select(tableSetting, 'CalculationBoite', (result, value) {
      if (result == 'error') toast.show('Erreur dans get calculation !');
      if (result == 'error') loading.hide();
      if (result == 'error') return;

      calculationBoite = value.data() as Map<String, Object?>;
      // LOADING STOP
      base.select(tableSetting, 'Token', (result, value) {
        if (result == 'error') toast.show('Erreur dans get calculation !');
        if (result == 'error') loading.hide();
        if (result == 'error') return;

        calculationToken = value.data() as Map<String, Object?>;
        // LOADING STOP
        loading.hide();
      });
    });
  }

  double getBut(
      double fond, int nbChildAttend) // nbChildAttend = 2 ou 3 ou plus
  {
    double but = 0;
    // etage
    but = but + (calculationBoite['parEtageEnPercent'] * 2);
    // child
    but = but + (calculationBoite['parChildsEnPercent'] * nbChildAttend);
    // bonus - etage sortant
    but = but + calculationBoite['bonusSortant'];
    // bonus - child debut in 2
    if (nbChildAttend > 1) {
      for (var i = 2; i < nbChildAttend; i++) {
        but = but + calculationBoite['bonusPerChild'];
      }
    }
    // to Tk

    return fond * but / 100;
  }

  double getMyProgreesion(Map<String, dynamic> mesInfos) {
    double res = 0;
    // etage
    res = res + (calculationBoite['parEtageEnPercent'] * mesInfos['etage']);
    // child
    res = res + (calculationBoite['parChildsEnPercent'] * mesInfos['childNbr']);
    // bonus - etage sortant
    res = res + calculationBoite['bonusSortant'];
    // bonus - child debut in 2
    if (mesInfos['childNbr'] > 1) {
      for (var i = 2; i < mesInfos['childNbr']; i++) {
        res = res + calculationBoite['bonusPerChild'];
      }
    }
    return res;
  }

  double getMyBonus(
      Map<String, dynamic> mesInfos) // nbChildAttend = 2 ou 3 ou plus
  {
    double res = 0;
    // bonus - etage sortant
    if (mesInfos['etage'] > 1) {
      res = res + calculationBoite['bonusSortant'];
    }
    // bonus - child debut in 2
    if (mesInfos['childNbr'] > 1) {
      for (var i = 1; i < mesInfos['childNbr']; i++) {
        res = res + calculationBoite['bonusPerChild'];
      }
    }
    return res;
  }
}
// ===============================================================================

String boiteCodeGenerator() {
  int len = 7;
  var r = Random();
  const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
  return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
}

bool checIamInBoite(List mesBoites, Map<String, dynamic> boite) {
  bool iamIn = false;
  mesBoites.forEach((element) {
    if (element.toString() == boite['code'].toString()) iamIn = true;
  });
  return iamIn;
}

// ===============================================================================

class BOITE extends StatelessWidget {
  BOITE(
      {super.key,
      required this.boite,
      this.isNew = true,
      required this.calculRow});

  bool isNew;
  Map<String, dynamic> boite;
  late $MODALE modale;

  $LABEL title =
      $LABEL(text: 'Nouvelle boite', textColor: Colors.black26, textSize: 12);
  $LABEL title2 =
      $LABEL(text: 'Legende', textColor: Colors.black26, textSize: 12);
  $LABEL title3 =
      $LABEL(text: 'Progression', textColor: Colors.black26, textSize: 12);

  $BUTTON bt_quitter = $BUTTON(text: 'Quitter la boite');

  bool containe(List liste, String keys) {
    for (var element in liste) {
      if (element.toString() == keys) return true;
    }
    return false;
  }

  Function calculRow;

  String getType(int etage, int place) {
    if (checIamInBoite(userActif['boites'], boite)) {
      return boite['etage']['$etage'][place].toString() == userActif['login']
          ? 'me'
          : boite['etage']['$etage'][place].toString() == 'vide'
              ? 'vide'
              // : containe(boite['informations'][userActif['login']]['childs'],
              //         boite['etage']['$etage'][place].toString())
              //     ? 'child'
              : 'other';
    } else {
      return boite['etage']['$etage'][place].toString() == 'vide'
          ? 'vide'
          : 'other';
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light));
    bool isHereMe = checIamInBoite(userActif['boites'], boite);

    bt_quitter.bg_color = isHereMe ? Colors.red : Colors.green;
    bt_quitter.setText($LABEL(
        text: isHereMe ? 'Quitter la boite' : 'Rejoindre',
        textColor: Colors.white,
        textSize: 13));

    bt_quitter.setAction(() async {
      Navigator.pop(context);
      loading.show('Traitement en cours');
      if (isHereMe) {
        double montant = calculBoite
                .getMyProgreesion(boite['informations'][userActif['login']]) *
            boite['montant'] /
            100;
        base.quitBoite(userActif['login'], boite['code'], montant, (result) {
          loading.hide();
          userActif['boites'].remove(boite['code']);
          userActif['token'] += montant;
          calculRow();
        });
      } else {
        // chec TOKEN
        if (userActif['token'].toDouble() < boite['montant']) {
          toast.show("Vous n'avez pas asser de Tk");
          return;
        }
        //

        intoBoite i = intoBoite(userActif['login'], '', boite);
        i.actionAfter = () {
          loading.hide();
          userActif['boites'].add(boite['code']);
          userActif['token'] -= boite['montant'];
          calculRow();
        };
        i.run(isHaveParent: false);
      }
    });

    modale = $MODALE(context, '', '')
      ..type = 'CUSTOM'
      ..child = Column(children: [
        BOITE(boite: boite, calculRow: () {}),
        $PADDING(
            all: 10,
            child: SizedBox(
                height: 40,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (isHereMe)
                        TextButton.icon(
                            onPressed: () async {
                              toast.show(
                                  'Code parainage copier dans le papier presse');
                              await Clipboard.setData(ClipboardData(
                                  text:
                                      '${userActif['login']}-${boite['code']}'));
                            },
                            icon: const Icon(Icons.copy),
                            label: const Text('Copier mon code',
                                style: TextStyle(fontSize: 12))),
                      bt_quitter
                    ])))
      ]);

    title.text = boite['code'] == null
        ? 'Nouvell boite'
        : 'code : AMOI-B${boite['code']}';

    return InkWell(
        onTap: isNew
            ? null
            : () {
                modale.show();
              },
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              title,
              Container(
                  margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  height: 1,
                  width: double.maxFinite,
                  color: Colors.black12),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(children: [
                      iconAvatar(o: getType(0, 0)),
                      iconAvatar(o: getType(0, 1))
                    ]),
                    const SizedBox(height: 10),
                    Row(children: [
                      iconAvatar(o: getType(1, 0)),
                      iconAvatar(o: getType(1, 1)),
                      iconAvatar(o: getType(1, 2)),
                      iconAvatar(o: getType(1, 3)),
                    ]),
                    const SizedBox(height: 10),
                    Row(children: [
                      iconAvatar(o: getType(2, 0)),
                      iconAvatar(o: getType(2, 1)),
                      iconAvatar(o: getType(2, 2)),
                      iconAvatar(o: getType(2, 3)),
                      iconAvatar(o: getType(2, 4)),
                      iconAvatar(o: getType(2, 5)),
                      iconAvatar(o: getType(2, 6)),
                      iconAvatar(o: getType(2, 7)),
                    ]),
                  ]),
              Container(
                  margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  height: 1,
                  width: double.maxFinite,
                  color: Colors.black12),
              title2,
              const SizedBox(height: 10),
              Column(
                children: [
                  Row(children: [
                    iconAvatar(o: 'me'),
                    const SizedBox(width: 5),
                    const Text('Moi'),
                    const SizedBox(width: 20),
                    // iconAvatar(o: 'child'),
                    // const SizedBox(width: 5),
                    // const Text('Mon child')
                    iconAvatar(o: 'other'),
                    const SizedBox(width: 5),
                    const Text('Place déjà pris'),
                  ]),
                  Row(children: [
                    // iconAvatar(o: 'other'),
                    // const SizedBox(width: 5),
                    // const Text('Place déjà pris'),
                    // const SizedBox(width: 20),
                    iconAvatar(o: 'vide'),
                    const SizedBox(width: 5),
                    const Text('Place encore vide')
                  ]),
                ],
              ),
              Container(
                  margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  height: 1,
                  width: double.maxFinite,
                  color: Colors.black12),
              title3,
              const SizedBox(height: 10),
              SizedBox(
                  width: double.maxFinite,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                Text(
                                    'But : ${calculBoite.getBut(boite['montant'].toDouble(), 2)}'),
                                Text(' Tk (avec 2 childs)')
                              ]),
                              // if (isHereMe)
                              //   Text(
                              //       '${f.format(calculBoite.getMyProgreesion(boite['informations'][userActif['login']]))}%')
                            ],
                          ),
                          if (isHereMe) const SizedBox(height: 3),
                          if (isHereMe)
                            SizedBox(
                                height: 2,
                                child: LinearProgressIndicator(
                                    value: calculBoite.getMyProgreesion(
                                            boite['informations']
                                                [userActif['login']]) /
                                        100,
                                    backgroundColor: Colors.blue[100],
                                    color: Colors.blue[400]))
                        ]),
                        const SizedBox(height: 10),
                        Text('Fond : ${boite['montant']} Tk'),
                        if (isHereMe)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  'Revenue : ${f.format(calculBoite.getMyProgreesion(boite['informations'][userActif['login']]))}%'),
                            ],
                          ),
                        if (isHereMe)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  'Nombre de child : ${boite['informations'][userActif['login']]['childNbr']} '),
                            ],
                          ),
                        if (isHereMe)
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    'Bonus : +${calculBoite.getMyBonus(boite['informations'][userActif['login']])}%'),
                                Text(
                                    'Valeur Totale : ${f.format(calculBoite.getMyProgreesion(boite['informations'][userActif['login']]) * boite['montant'] / 100)} Tk'),
                              ]),
                        if (isHereMe)
                          Row(
                            children: [
                              const Text('Mon code parainage : ',
                                  style: TextStyle(color: Colors.blue)),
                              Text('${userActif['login']}-${boite['code']}'),
                            ],
                          )
                      ]))
            ])));
  }
}

// ============================================================================================================

class iconAvatar extends StatelessWidget {
  iconAvatar({super.key, required this.o});

  String o = 'vide'; // 'me' // 'child' // 'other'

  @override
  Widget build(BuildContext context) {
    Widget child = const Icon(
      Icons.radio_button_unchecked,
      size: 20,
      color: Colors.black38,
    ); // vide
    if (o == 'other') {
      child = const Icon(
        Icons.radio_button_checked,
        size: 20,
        color: Colors.black38,
      );
    }
    if (o == 'child') {
      child = Icon(
        Icons.radio_button_checked,
        size: 20,
        color: Colors.green.withOpacity(.6),
      );
    }
    if (o == 'me') {
      child = const Icon(
        Icons.radio_button_checked,
        size: 20,
        color: Colors.green,
      );
    }
    return child;
  }
}

// ============================================================================================================

class newBoiteModale extends StatefulWidget {
  newBoiteModale(
      {super.key,
      required this.show,
      required this.hide,
      required this.calculRow});

  Function show;
  Function hide;
  Function calculRow;
  @override
  State<newBoiteModale> createState() => _newBoiteModaleState();
}

class _newBoiteModaleState extends State<newBoiteModale> {
  double montant_a_investi = 15.0;

  @override
  Widget build(BuildContext context) {
    String codeNewBoite = boiteCodeGenerator();
    Map<String, dynamic> newBoite = {
      'code': codeNewBoite,
      'dateCreate': getDateNow(),
      'montant': montant_a_investi,
      'isNew': true,
      'etage': {
        '0': ['vide', 'vide'],
        '1': ['vide', 'vide', 'vide', 'vide'],
        '2': [
          'vide',
          'vide',
          'vide',
          'vide',
          'vide',
          'vide',
          'vide',
          '${userActif['login']}'
        ],
      },
      'informations': {
        '${userActif['login']}': {
          'childNbr': 0,
          'childs': [],
          'etage': 0,
          'dateDebut': getDateNow()
        }
      }
    };

    actionNewBoite(bool isIncriment) {
      if (!isIncriment && montant_a_investi == 5) return;
      setState(() {
        isIncriment ? montant_a_investi += 5 : montant_a_investi -= 5;
      });
    }

    return Column(children: [
      $LABEL(text: 'Nouvelle boite', textColor: Colors.black54, textSize: 16),
      Container(
          margin: const EdgeInsets.fromLTRB(0, 7, 0, 7),
          height: 1,
          width: double.maxFinite,
          color: Colors.black12),
      BOITE(boite: newBoite, calculRow: () {}),
      Column(children: [
        Container(
            margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            height: 1,
            width: double.maxFinite,
            color: Colors.black12),
        $PADDING(
            all: 5,
            child: SizedBox(
                height: 50,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          $BUTTON(text: '-', type: iconButton)
                            ..icon = Icons.arrow_drop_down
                            ..color = Colors.blue
                            ..bg_color = Colors.white
                            ..action = () {
                              actionNewBoite(false);
                            },
                          const SizedBox(width: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              $LABEL(
                                  text: 'Investissement',
                                  textSize: 10,
                                  textColor: Colors.grey),
                              Text('$montant_a_investi Tks'),
                            ],
                          ),
                          const SizedBox(width: 10),
                          $BUTTON(text: '+', type: iconButton)
                            ..icon = Icons.arrow_drop_up
                            ..color = Colors.blue
                            ..bg_color = Colors.white
                            ..action = () {
                              actionNewBoite(true);
                            },
                        ],
                      ),
                      Row(children: [
                        const SizedBox(width: 10),
                        $BUTTON(text: 'Valider', type: iconButton)
                          ..icon = Icons.check_circle
                          ..bg_color = Colors.green
                          ..action = () {
                            // chec TOKEN
                            if (userActif['token'].toDouble() <
                                montant_a_investi) {
                              toast.show("Vous n'avez pas asser de Tk");
                              return;
                            }
                            //
                            loading.show("Créeation d'une boite");

                            // to firebas
                            base.insert(tableBoite, codeNewBoite, newBoite,
                                (result, value) {
                              toast.show(result == 'succes'
                                  ? 'Nouveau boite créé !'
                                  : 'Une problème est survenue !');

                              if (result != 'succes') return;

                              // update fiche
                              setState(() {
                                userActif['boites'].add(codeNewBoite);
                                userActif['token'] -= montant_a_investi;
                              });
                              base.insert(
                                  tableUser, userActif['login'], userActif,
                                  (result, value) {
                                // LOADING STOP
                                loading.hide();

                                // pass
                                widget.hide();
                                widget.calculRow();
                              });
                            });

                            // loading
                          },
                        const SizedBox(width: 2),
                        $BUTTON(text: 'Annuler', type: iconButton)
                          ..icon = Icons.cancel
                          ..bg_color = Colors.redAccent
                          ..action = () {
                            widget.hide();
                          }
                      ])
                    ])))
      ])
    ]);
  }
}

// ============================================================================================================

class intoBoite {
  String login;
  String parent;
  Map<String, dynamic> boite;
  Function actionAfter = () {};

  intoBoite(this.login, this.parent, this.boite) {
    String codeNewBoite = boiteCodeGenerator();
  }

  int getPlaceNumPrent() {
    if (boite['etage']['0'][0] == parent) return 2;
    if (boite['etage']['0'][1] == parent) return 2;
    if (boite['etage']['1'][0] == parent) return 1;
    if (boite['etage']['1'][1] == parent) return 1;
    if (boite['etage']['1'][2] == parent) return 1;
    if (boite['etage']['1'][3] == parent) return 1;
    if (boite['etage']['2'][0] == parent) return 0;
    if (boite['etage']['2'][1] == parent) return 0;
    if (boite['etage']['2'][2] == parent) return 0;
    if (boite['etage']['2'][3] == parent) return 0;
    if (boite['etage']['2'][4] == parent) return 0;
    if (boite['etage']['2'][5] == parent) return 0;
    if (boite['etage']['2'][6] == parent) return 0;
    if (boite['etage']['2'][7] == parent) return 0;
    return 0;
  }

  Map<String, dynamic> updatePlace(Map<String, dynamic> b) {
    if (b['etage']['2'][0].toString() != 'vide') {
      boite['informations'][b['etage']['2'][0].toString()]['etage'] = 0;
    }
    if (b['etage']['2'][1].toString() != 'vide') {
      boite['informations'][b['etage']['2'][1].toString()]['etage'] = 0;
    }
    if (b['etage']['2'][2].toString() != 'vide') {
      boite['informations'][b['etage']['2'][2].toString()]['etage'] = 0;
    }
    if (b['etage']['2'][3].toString() != 'vide') {
      boite['informations'][b['etage']['2'][3].toString()]['etage'] = 0;
    }
    if (b['etage']['2'][4].toString() != 'vide') {
      boite['informations'][b['etage']['2'][4].toString()]['etage'] = 0;
    }
    if (b['etage']['2'][5].toString() != 'vide') {
      boite['informations'][b['etage']['2'][5].toString()]['etage'] = 0;
    }
    if (b['etage']['2'][6].toString() != 'vide') {
      boite['informations'][b['etage']['2'][6].toString()]['etage'] = 0;
    }
    if (b['etage']['2'][7].toString() != 'vide') {
      boite['informations'][b['etage']['2'][7].toString()]['etage'] = 0;
    }

    if (b['etage']['1'][0].toString() != 'vide') {
      boite['informations'][b['etage']['1'][0].toString()]['etage'] = 1;
    }
    if (b['etage']['1'][1].toString() != 'vide') {
      boite['informations'][b['etage']['1'][1].toString()]['etage'] = 1;
    }
    if (b['etage']['1'][2].toString() != 'vide') {
      boite['informations'][b['etage']['1'][2].toString()]['etage'] = 1;
    }
    if (b['etage']['1'][3].toString() != 'vide') {
      boite['informations'][b['etage']['1'][3].toString()]['etage'] = 1;
    }

    if (b['etage']['0'][0].toString() != 'vide') {
      boite['informations'][b['etage']['0'][0].toString()]['etage'] = 2;
    }
    if (b['etage']['0'][1].toString() != 'vide') {
      boite['informations'][b['etage']['0'][1].toString()]['etage'] = 2;
    }

    return b;
  }

  run({bool isHaveParent = true}) {
    if (boite['isNew'] == true) {
      boite['etage']['0'][0] = boite['etage']['0'][1];
      boite['etage']['0'][1] = boite['etage']['1'][0];
      boite['etage']['1'][0] = boite['etage']['1'][1];
      boite['etage']['1'][1] = boite['etage']['1'][2];
      boite['etage']['1'][2] = boite['etage']['1'][3];
      boite['etage']['1'][3] = boite['etage']['2'][0];
      boite['etage']['2'][0] = boite['etage']['2'][1];
      boite['etage']['2'][1] = boite['etage']['2'][2];
      boite['etage']['2'][2] = boite['etage']['2'][3];
      boite['etage']['2'][3] = boite['etage']['2'][4];
      boite['etage']['2'][4] = boite['etage']['2'][5];
      boite['etage']['2'][5] = boite['etage']['2'][6];
      boite['etage']['2'][6] = boite['etage']['2'][7];
      boite['etage']['2'][7] = login;
    } else {
      if (boite['etage']['2'][0] == 'vide') {
        boite['etage']['2'][0] = login;
      } else if (boite['etage']['2'][1] == 'vide') {
        boite['etage']['2'][1] = login;
      } else if (boite['etage']['2'][2] == 'vide') {
        boite['etage']['2'][2] = login;
      } else if (boite['etage']['2'][3] == 'vide') {
        boite['etage']['2'][3] = login;
      } else if (boite['etage']['2'][4] == 'vide') {
        boite['etage']['2'][4] = login;
      } else if (boite['etage']['2'][5] == 'vide') {
        boite['etage']['2'][5] = login;
      } else if (boite['etage']['2'][6] == 'vide') {
        boite['etage']['2'][6] = login;
      } else {
        boite['etage']['2'][7] = login;
      }
    }

    // step 2
    if (boite['etage']['0'][0].toString() != 'vide' &&
        boite['etage']['0'][1].toString() != 'vide' &&
        boite['etage']['2'][7].toString() != 'vide') {
      //
      userActif['token'] -= boite['montant'];
      userActif['boites'].add(boite['code']);
      //
      toast.show("Votre demande va etre traité ");
      // loading
      loading.hide();

      return;
    }
    // step 3
    boite['informations'][login] = {
      'childNbr': 0,
      'childs': [],
      'etage': 0,
      'dateDebut': getDateNow()
    };

    if (isHaveParent == true) {
      if (boite['informations'][parent]['childNbr'] == 0) {
        boite['informations'][parent]['childs'] = [login];
      } else {
        List<dynamic> bts = [];
        int size = boite['informations'][parent]['childNbr'];
        for (var i = 0; i < size; i++) {
          bts.add(boite['informations'][parent]['childs'][i]);
        }
        bts.add(login);
        boite['informations'][parent]['childs'] = bts;
      }

      boite['informations'][parent]['childNbr'] =
          boite['informations'][parent]['childNbr'] + 1;
      boite['informations'][parent]['etage'] = getPlaceNumPrent();
    }

    boite = updatePlace(boite);
    boite['montant'] = boite['montant'].toInt();

    // step 5
    base.insert(tableBoite, boite['code'], boite, (result, value) {
      toast.show(result == 'succes'
          ? 'Nouveau boite créé !'
          : 'Une problème est survenue !');


      if (result != 'succes') loading.hide();
      if (result != 'succes') return;

      base.rejoindreBoite(userActif['login'], boite['code'], boite['montant'],
          (res) {
        actionAfter();
        if (isHaveParent == true) {
          base.insertNotification(
              parent,
              'Nouveau child ! boite : AMOI-B${boite['code']}',
              'Vous avez un nouveau child .. login : ${userActif['login']}',
              (result, value) {
            // loading
            loading.hide();
          });
        } else {
          // loading
          loading.hide();
        }
      });
    });
  }
}
