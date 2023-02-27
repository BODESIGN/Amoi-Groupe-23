// ignore_for_file: must_be_immutable, camel_case_types

import 'package:amoi/bo/componantes/custom/bo_modal.dart';
import 'package:amoi/main.dart';
import 'package:amoi/screen/boite.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../bo/componantes/bo_button/bo_button.dart';
import '../bo/componantes/bo_input/bo_input.dart';
import '../bo/componantes/bo_label/bo_label.dart';
import '../bo/componantes/bo_main/bo_main.dart';
import '../bo/componantes/bo_padding/bo_padding.dart';
import '../bo/componantes/custom/bo_container.dart';
import '../bo/componantes/custom/bo_pager.dart';

class screenSearch extends StatefulWidget {
  screenSearch({super.key, required this.rootName});

  String rootName;

  @override
  State<screenSearch> createState() => _screenSearchState();
}

class _screenSearchState extends State<screenSearch> {
  $BUTTON btHelp = $BUTTON(text: 'Aide', type: textButton, color: Colors.black);

  $INPUT inputSearch =
      $INPUT(label: 'Recherche', width: 100, prefixIcon: Icons.person)
        ..isHaveSuffix = true
        ..suffix_icon = Icons.search;

  CarouselController controler = CarouselController();
  int currentIndex = 0;

  late $MODALE modalNewBoiteRejoindre;

  bool isConstruct = true;

  String parentCode = 'vide';
  Map<String, dynamic> boiteParainage = {
    'code': '',
    'dateCreate': getDateNow(),
    'montant': 0.0,
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

  createCompte() {}

  List<Widget> listBoites = [];

  getListBoite() {
    // loading
    loading.show('select Boites');
    listBoites = [];

    // firebaseF
    base.select_Boite(tableBoite, userActif['boites'], (boites) {
      loading.hide();

      setState(() {
        currentIndex = 0;
        for (var boite in boites) {
          BOITE b = BOITE(
              isNew: false,
              boite: boite,
              calculRow: () {
                calculRow();
              });

          listBoites.add(b);
        }
      });
    }, isIamNotIn: true);
  }

  calculRow() {
    getListBoite();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    calculBoite.init();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light));
    toast.init(context);

    inputSearch.width = MediaQuery.of(context).size.width - 100;
    inputSearch.prefixIcon = Icons.drive_folder_upload_sharp;
    // ClipboardData cdata = await Clipboard.getData(Clipboard.kTextPlain);
    // String copiedtext = cdata.text;

    inputSearch.suffixAction = () {
      String codeSearch = inputSearch.getValue();
      List<String> codes = codeSearch.split('-');

      if (codes.length < 2) {
        toast.show('Veuillez verifier la code de parainage');
        return;
      }
      codes[1] = codes[1].replaceAll(' ', '');

      if (codes[0] == userActif['login']) {
        toast.show('Veuillez verifier la code de parainage');
        return;
      }
      loading.show('Recherche de la boite');

      base.select_Boite_Unique(codes[1], (result, value) {
        if (result == 'error') toast.show('Boite introuvable !');
        if (result == 'error') loading.hide();
        if (result == 'error') return;

        Map<String, Object?> boite = value.data() as Map<String, Object?>;

        if (checIamInBoite(userActif['boites'], boite)) {
          toast.show('Vous vous trouver déjà dans cette boite !');
          loading.hide();
          return;
        }

        if (boite['code'] == codes[1]) {
          setState(() {
            boiteParainage = boite;
            parentCode = codes[0];
          });
          // LOADING STOP
          loading.hide();

          modalNewBoiteRejoindre = $MODALE(context, '', '')
            ..type = 'CUSTOM'
            ..child = newBoiteModaleSearch(
                show: () => {modalNewBoiteRejoindre.show()},
                hide: () => {modalNewBoiteRejoindre.hide()},
                calculRow: () {
                  calculRow();
                },
                boite: boiteParainage,
                parent: parentCode);

          modalNewBoiteRejoindre.show();
          // Navigator.pop(context);
        }
      });
    };

    if (isConstruct) {
      calculRow();
      isConstruct = false;
    }

    return WillPopScope(
        onWillPop: () async {
          return changeScreen(context, '/dashboard');
        },
        child: SafeArea(
            child: Scaffold(
                body: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                        children: [
                          SizedBox(
                              width: double.maxFinite,
                              child: $PADDING(all: 20, child: inputSearch)),
                          Container(
                            color: Colors.black12,
                            child: $PADDING(
                                left: 20,
                                right: 20,
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      $LABEL(
                                          text:
                                              'Meilleurs boites actifs actuels',
                                          textColor: Colors.blue,
                                          textSize: 14),
                                      Row(children: [
                                        btHelp,
                                        const Icon(Icons.help,
                                            size: 20,
                                            color: Colors.orangeAccent)
                                      ])
                                    ])),
                          ),
                          SizedBox(
                            height: 350,
                            width: double.maxFinite,
                            child: Center(
                              child: $PADDING(
                                  bottom: 20,
                                  top: 20,
                                  left: 10,
                                  right: 10,
                                  child: listBoites.isEmpty
                                      ? Center(
                                          child: emptyBoite())
                                      : CarouselSlider(
                                          carouselController: controler,
                                          options: CarouselOptions(
                                            enlargeCenterPage: true,
                                            enableInfiniteScroll: true,
                                            viewportFraction: 1,
                                            aspectRatio: 1,
                                            initialPage: currentIndex,
                                            pageSnapping: true,
                                            onPageChanged: (index, reason) {
                                              setState(() {
                                                currentIndex = index;
                                              });
                                            },
                                          ),
                                          items: listBoites.map((i) {
                                            return Builder(
                                              builder: (BuildContext context) {
                                                return SizedBox(
                                                    width: double.maxFinite,
                                                    height: double.maxFinite,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0),
                                                      child: Material(
                                                          elevation: 5,
                                                          borderOnForeground:
                                                              true,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            side: const BorderSide(
                                                                color: Colors
                                                                    .black12,
                                                                width: 1),
                                                          ),
                                                          color: Colors.white,
                                                          shadowColor:
                                                              Colors.black26,
                                                          child: $PADDING(
                                                              all: 10,
                                                              child: i)),
                                                    ));
                                              },
                                            );
                                          }).toList(),
                                        )),
                            ),
                          ),
                          Center(
                              child: listBoites.isEmpty
                                  ? null
                                  : $PAGE(
                                      currentIndex: currentIndex,
                                      count: listBoites.length))
                        ])))));
  }
}

// ============================================================================================================

// ================================================================================

class newBoiteModaleSearch extends StatefulWidget {
  newBoiteModaleSearch(
      {super.key,
      required this.show,
      required this.hide,
      required this.calculRow,
      required this.boite,
      required this.parent});

  Function show;
  Function hide;
  Function calculRow;
  Map<String, dynamic> boite;
  String parent;
  @override
  State<newBoiteModaleSearch> createState() => _newBoiteModaleSearchState();
}

class _newBoiteModaleSearchState extends State<newBoiteModaleSearch> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.blue,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light));
    return Column(children: [
      $LABEL(text: 'Nouvelle boite', textColor: Colors.black54, textSize: 16),
      Container(
          margin: const EdgeInsets.fromLTRB(0, 7, 0, 7),
          height: 1,
          width: double.maxFinite,
          color: Colors.black12),
      BOITE(boite: widget.boite, calculRow: () {}),
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
                      Row(),
                      Row(children: [
                        const SizedBox(width: 10),
                        SizedBox(
                          height: 40,
                          child: $BUTTON(text: 'Rejoindre')
                            ..icon = Icons.check_circle
                            ..bg_color = Colors.green
                            ..action = () async {
                              // chec TOKEN
                              if (userActif['token'].toDouble() <=
                                  widget.boite['montant']) {
                                toast.show("Vous n'avez pas asser de Tk");
                                return;
                              }

                              intoBoite i = intoBoite(userActif['login'],
                                  widget.parent, widget.boite);
                              i.actionAfter = () {
                                widget.calculRow();
                                Navigator.pop(context);
                              };
                              i.run(isHaveParent: true);
                            },
                        ),
                        const SizedBox(width: 2),
                        $BUTTON(text: 'Annuler', type: iconButton)
                          ..icon = Icons.cancel
                          ..bg_color = Colors.redAccent
                          ..action = () {
                            // widget.hide();
                            Navigator.pop(context);
                          }
                      ])
                    ])))
      ])
    ]);
  }
}
