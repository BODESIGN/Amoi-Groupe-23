// ignore_for_file: must_be_immutable, camel_case_types

import 'dart:io';
import 'package:flutter/services.dart';

import 'package:amoi/bo/componantes/custom/bo_modal.dart';
import 'package:amoi/main.dart';
import 'package:amoi/screen/boite.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../bo/componantes/bo_button/bo_button.dart';
import '../bo/componantes/bo_label/bo_label.dart';
import '../bo/componantes/bo_main/bo_main.dart';
import '../bo/componantes/bo_padding/bo_padding.dart';
import '../bo/componantes/custom/bo_container.dart';
import '../bo/componantes/custom/bo_pager.dart';
import '../bo/componantes/custom/bo_pdp.dart';

import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class screenDashboard extends StatefulWidget {
  screenDashboard({super.key, required this.rootName});

  String rootName;

  @override
  State<screenDashboard> createState() => _screenDashboardState();
}

class _screenDashboardState extends State<screenDashboard> {
  int curPane = 0;
  bool isOnLoad = false;
  final double shadow = 10;
  final double pdpSize = 45;
  bool isHaveNotyfNonVu = false;

  $BUTTON btHelp = $BUTTON(text: 'Aide', type: textButton, color: Colors.black);
  $BUTTON btMenu = $BUTTON(text: 'menu', type: iconButtonNoBordur)
    ..color = Colors.black
    ..bg_color = Colors.white
    ..radius = 100
    ..elevation = 0
    ..icon = Icons.menu
    ..border_width = 0
    ..border_color = Colors.white;
  $BUTTON btNewBoite = $BUTTON(text: 'new boite', type: iconButton)
    ..elevation = 0
    ..radius = 10
    ..icon = Icons.add;
  $BUTTON btSearchBoite = $BUTTON(text: 'search boite', type: iconButton)
    ..color = Colors.blue
    ..bg_color = Colors.white
    ..elevation = 0
    ..radius = 10
    ..icon = Icons.search;
  $BUTTON btDeconnect = $BUTTON(text: 'Deconnect', type: iconButton)
    ..color = Colors.blue
    ..bg_color = Colors.white
    ..elevation = 0
    ..radius = 10
    ..icon = Icons.power_settings_new;

  $LABEL nameUser =
      $LABEL(text: 'Rayan RAVELONIRINA', textColor: Colors.grey, textSize: 14);
  $LABEL lbVersion =
      $LABEL(text: 'v212121', textColor: Colors.black26, textSize: 12);
  $LABEL lbActorApp =
      $LABEL(text: 'by BO Studio Mg', textColor: Colors.black26, textSize: 12);

  late $CONTAINER appBar;

  // $CAROUSEL carouselBoite = $CAROUSEL(listItems: [], actionOnChangePage: () {});
  CarouselController controler = CarouselController();
  int currentIndex = 0;

  late $MODALE modalChandePdp;
  late $MODALE modalNewBoite;
  late $MODALE modalOkMessage;

  String urlPdp = '';
  bool isConstruct = true;

  TextEditingController controllerConversion = TextEditingController();
  TextEditingController controllerDepotRetrait = TextEditingController();
  TextEditingController controllerNumeroDemande = TextEditingController();
  $BUTTON bt_to_tk = $BUTTON(text: 'En Token')
    ..radius = 50
    ..elevation = 5;
  $BUTTON bt_to_ariary = $BUTTON(text: 'En Ariary')
    ..radius = 50
    ..elevation = 5;
  $BUTTON bt_depot = $BUTTON(
    text: 'Dépot',
  )
    ..radius = 50
    ..elevation = 5;
  $BUTTON bt_retrait = $BUTTON(text: 'Retrait')
    ..radius = 50
    ..elevation = 5;

  clickOnpdp() {
    modalChandePdp.show();
  }

  List<Widget> listBoites = [];

  List<DataRow> listNotification = [];

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
    });
  }

  calculRow() {
    getListBoite();

    setState(() {
      nameUser.text = userActif['fullname'];
      urlPdp = userActif['urlPdp'];
    });

    loadNotif();
  }

  // ===========================================================
  late File imgFile;
  final imgPicker = ImagePicker();
  FirebaseStorage _storage = FirebaseStorage.instance;

  void openCamera() async {
    var imgCamera = await imgPicker.getImage(source: ImageSource.camera);
    setState(() {
      imgFile = File(imgCamera!.path);
    });
    uploadProfileImage();
  }

  void openGallery() async {
    var imgGallery = await imgPicker.getImage(source: ImageSource.gallery);
    setState(() {
      imgFile = File(imgGallery!.path);
    });
    uploadProfileImage();
  }

  uploadProfileImage() async {
    loading.show('Téléversement de la photo');

    Reference reference =
        FirebaseStorage.instance.ref().child('Pdp/${userActif['login']}');
    UploadTask uploadTask = reference.putFile(imgFile);
    TaskSnapshot snapshot = await uploadTask;
    userActif['urlPdp'] = await snapshot.ref.getDownloadURL();

    // firebase
    base.insert(tableUser, userActif['login'], userActif, (result, value) {
      // LOADING STOP
      loading.hide();

      // pass
      toast.show('Mise a jour éffectuée !');
      calculRow();
    });
  }

  // ===========================================================

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

    nameUser.setFontWeight(FontWeight.w300);
    // carouselBoite.actionOnChangePage = (index) => {setState(() => {})};

    modalChandePdp = $MODALE(
        context, "Modifier profile", "Mise a jour de la photo de profile")
      ..labelButton1 = 'Camera'
      ..icon1 = Icons.camera_alt
      ..action1 = () {
        modalChandePdp.hide();
        openCamera();
      }
      ..labelButton2 = 'Galerie'
      ..icon2 = Icons.folder_open
      ..action2 = () {
        modalChandePdp.hide();
        openGallery();
      }
      ..labelButton3 = 'Annuler'
      ..action3 = () {
        modalChandePdp.hide();
      };

    modalOkMessage = $MODALE(context, 'Succes', 'Coagulation')
      ..type = 'OK MESSAGE'
      ..labelButton3 = 'Ok'
      ..action3 = () {
        // modalOkMessage.hide();
        Navigator.pop(context);
      };

    btSearchBoite.action = () {
      changeScreen(context, '/searchScreen');
    };

    btDeconnect.action = () {
      changeScreen(context, '/seconnect');
    };

    modalNewBoite = $MODALE(context, '', '')
      ..type = 'CUSTOM'
      ..child = newBoiteModale(
          show: () => {modalNewBoite.show()},
          hide: () => {modalNewBoite.hide()},
          calculRow: () {
            calculRow();
          });

    btNewBoite.action = () {
      modalNewBoite.show();
    };

    if (isConstruct) {
      calculRow();
      isConstruct = false;
    }

    appBar = $CONTAINER(
        context: context,
        ratio_y: .15,
        child: $PADDING(
            all: 15,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 1,
                      color: Colors.black12,
                    )),
                child: $PADDING(
                    left: 0,
                    right: 0,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Stack(
                            children: [
                              btMenu,
                              if (isHaveNotyfNonVu)
                                const Positioned(
                                  top: 10,
                                  right: 5,
                                  child: Icon(Icons.fiber_manual_record,
                                      color: Colors.red, size: 15),
                                )
                            ],
                          ),
                          Row(children: [
                            $PADDING(
                                right: 10,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      nameUser,
                                      Row(
                                        children: [
                                          Text(
                                              '${f.format(userActif['ariary'])} Ariary / ',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold, fontSize: 13)),
                                          Text(
                                              '${f.format(userActif['token'])} Tk',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold, fontSize: 13)),
                                        ],
                                      )
                                    ])),
                            SizedBox(
                                width: pdpSize,
                                height: pdpSize,
                                child: pdp(urlPdp, clickOnpdp)),
                            const SizedBox(width: 10)
                          ])
                        ])))));

    bt_to_tk.setAction(() {
      convertion('en token');
    });
    bt_to_ariary.setAction(() {
      convertion('en ariary');
    });

    bt_depot.setAction(() {
      actionVola('depot');
    });
    bt_retrait.setAction(() {
      actionVola('retrait');
    });

    return WillPopScope(
      onWillPop: () async {
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else if (Platform.isIOS) {
          exit(0);
        }
        return false;
      },
      child: SimpleHiddenDrawer(
        menu: Menu(isHaveNotyfNonVu: isHaveNotyfNonVu),
        screenSelectedBuilder: (position, controller) {
          Widget screenCurrent = screen1(context);
          // setState(() {
          curPane = position;

          // });

          switch (position) {
            case 0:
              screenCurrent = screen1(context);
              break;
            case 1:
              screenCurrent = screen2(context);
              break;
            case 2:
              screenCurrent = screen3(context);
              break;
          }

          btMenu.action = () {
            controller.toggle();
          };

          return Scaffold(
            body: screenCurrent,
          );
        },
      ),
    );
  }

  screen1(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Center(
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
          appBar,
          $CONTAINER(
              ratio_y: .1,
              context: context,
              child: Container(
                color: Colors.grey[200],
                child: $PADDING(
                    left: 20,
                    right: 20,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          $LABEL(
                              text: 'Mes boites',
                              textColor: Colors.blue,
                              textSize: 14),
                          Row(children: [
                            btHelp,
                            const Icon(Icons.help,
                                size: 20, color: Colors.orangeAccent)
                          ])
                        ])),
              )),
          $CONTAINER(
              ratio_y: .55,
              context: context,
              child: $PADDING(
                  bottom: 20,
                  left: 10,
                  right: 10,
                  child: userActif['boites'].length == 0
                      ? Center(
                          child: $LABEL(
                              text: 'Aucune boite',
                              textColor: Colors.black26,
                              textSize: 16))
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
                                      padding: const EdgeInsets.all(5),
                                      child: Material(
                                          elevation: 5,
                                          borderOnForeground: true,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            side: const BorderSide(
                                                color: Colors.black12,
                                                width: 1),
                                          ),
                                          color: Colors.white,
                                          shadowColor: Colors.black26,
                                          child: $PADDING(all: 10, child: i)),
                                    ));
                              },
                            );
                          }).toList(),
                        ))),
          $CONTAINER(
              context: context,
              ratio_y: .01,
              child: Center(
                  child: userActif['boites'].length == 0
                      ? null
                      : $PAGE(
                          currentIndex: currentIndex,
                          count: listBoites.length))),
          $CONTAINER(
              ratio_y: .15,
              context: context,
              child: $PADDING(
                  all: 15,
                  child: SizedBox(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                        Row(children: [btNewBoite, btSearchBoite]),
                        Row(
                          children: [
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [lbVersion, lbActorApp]),
                            const SizedBox(width: 10),
                            btDeconnect
                          ],
                        )
                      ]))))
        ]))));
  }

  convertion(String type) {
    int val = 0;
    double unite = calculationToken['valeur'].toDouble();
    try {
      val = int.parse(controllerConversion.text.toString());
    } catch (e) {
      toast.show('Veuillez verifier le montant');
      return;
    }

    double myTk = userActif['token'].toDouble();
    double myAr = userActif['ariary'].toDouble();

    if (type == 'en token') {
      if (myAr < val) toast.show('Montant trop élevé $myAr');
      if (myAr < val) return;

      myTk = myTk + (val / unite);
      myAr = myAr - val;
    } else {
      // en ariary
      if (myTk < val) toast.show('Montant trop élevé $myTk');
      if (myTk < val) return;

      myAr = myAr + (val * unite);
      myTk = myTk - val;
    }

    // action
    setState(() {
      userActif['token'] = myTk;
      userActif['ariary'] = myAr;
    });

    loading.show('Mise a jour ...');

    // firebase
    base.insert(tableUser, userActif['login'], userActif, (result, value) {
      // LOADING STOP
      loading.hide();

      // pass
      toast.show('Conversion de $val $type éffectuée !');
      calculRow();
    });
  }

  actionVola(String type) {
    if (controllerNumeroDemande.text.isEmpty) toast.show('Numéro obligatoire');
    if (controllerNumeroDemande.text.isEmpty) return;

    int val = 0;
    try {
      val = int.parse(controllerDepotRetrait.text.toString());
    } catch (e) {
      toast.show('Veuillez verifier le montant');
      return;
    }

    double myAr = userActif['ariary'].toDouble();
    String table = 'Retrait';

    if (val < 2000) toast.show('Montant minimum : 2000 Ariary');
    if (val < 2000) return;

    if (type == 'depot') {
      table = 'Depot';
    } else {
      // demande de retrait
      if (val > myAr) toast.show('Montant trop élevé');
      if (val > myAr) return;
    }

    // action
    loading.show('Mise a jour ...');

    // firebase
    base.updateDemande(tableDemande, table, {
      userActif['login']: {
        'login': userActif['login'],
        'isEncour': true,
        'dateDemande': getDateNow(),
        'montant': val,
        'numero': controllerNumeroDemande.text
      }
    }, (result, value) {
      // LOADING STOP
      loading.hide();

      // pass
      toast.show('Demande de retrait envoyée ($val ariary)');
      setState(() {
        modalOkMessage.subTitle =
            'Votre demande a été bien envoyer et en attente de traitement';
        modalOkMessage.show();
      });
      calculRow();
    });
  }

  screen2(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      appBar,
                      Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                $LABEL(
                                    text: 'Mon porte feuille',
                                    textColor: Colors.black38,
                                    textSize: 14),
                                Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    height: 1,
                                    width: double.maxFinite,
                                    color: Colors.black12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Mon token : '),
                                    Row(
                                      children: [
                                        Text(f.format(userActif['token']),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        const Text(' Tk'),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Mon ariary : '),
                                    Row(
                                      children: [
                                        Text(
                                          f.format(userActif['ariary']),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Text(' Ariary'),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 35),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    $LABEL(
                                        text: 'Convertion Token/Ariary',
                                        textColor: Colors.black38,
                                        textSize: 14),
                                    $LABEL(
                                        text:
                                            '1 Token = ${calculationToken['valeur']} Ariary',
                                        textColor: Colors.black38,
                                        textSize: 13),
                                  ],
                                ),
                                Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    height: 1,
                                    width: double.maxFinite,
                                    color: Colors.black12),
                                const SizedBox(height: 10),
                                SizedBox(
                                  height: 40,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      bt_to_tk,
                                      SizedBox(
                                        width: 80,
                                        child: TextFormField(
                                            controller: controllerConversion,
                                            keyboardType: TextInputType.number,
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                            decoration: InputDecoration(
                                                isDense: true,
                                                labelText: 'Montant',
                                                labelStyle: const TextStyle(
                                                    color: Colors.black38,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.normal),
                                                alignLabelWithHint: false,
                                                contentPadding:
                                                    const EdgeInsets.all(15),
                                                enabledBorder: OutlineInputBorder(
                                                    borderSide: const BorderSide(
                                                        color: Colors.black26),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            1)),
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Colors.black26),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0)))),
                                      ),
                                      bt_to_ariary,
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 35),
                                $LABEL(
                                    text: 'Dépôt / Retrait',
                                    textColor: Colors.black38,
                                    textSize: 14),
                                Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    height: 1,
                                    width: double.maxFinite,
                                    color: Colors.black12),
                                const SizedBox(height: 10),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 130,
                                            height: 40,
                                            child: StreamBuilder<Object>(
                                                stream: null,
                                                builder: (context, snapshot) {
                                                  return TextFormField(
                                                      controller:
                                                          controllerNumeroDemande,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      decoration: InputDecoration(
                                                          isDense: true,
                                                          labelText:
                                                              'Numéro téléphone',
                                                          labelStyle: const TextStyle(
                                                              color: Colors
                                                                  .black38,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                          alignLabelWithHint:
                                                              false,
                                                          contentPadding:
                                                              const EdgeInsets.all(
                                                                  15),
                                                          enabledBorder: OutlineInputBorder(
                                                              borderSide: const BorderSide(
                                                                  color: Colors
                                                                      .black26),
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      1)),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                                  borderSide: const BorderSide(color: Colors.black26),
                                                                  borderRadius: BorderRadius.circular(0))));
                                                }),
                                          ),
                                          const SizedBox(width: 5),
                                          SizedBox(
                                            width: 40,
                                            child: SvgPicture.asset(
                                                'assets/money/telma.svg',
                                                semanticsLabel: 'telma'),
                                          ),
                                          const SizedBox(width: 5),
                                          SizedBox(
                                            width: 40,
                                            child: SvgPicture.asset(
                                                'assets/money/orange.svg',
                                                semanticsLabel: 'orange'),
                                          ),
                                          const SizedBox(width: 5),
                                          SizedBox(
                                            width: 40,
                                            child: SvgPicture.asset(
                                                'assets/money/airtel.svg',
                                                semanticsLabel: 'airtel'),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      SizedBox(
                                          height: 40,
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: 80,
                                                  child: TextFormField(
                                                      controller:
                                                          controllerDepotRetrait,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      decoration: InputDecoration(
                                                          isDense: true,
                                                          labelText: 'Ariary',
                                                          labelStyle: const TextStyle(
                                                              color: Colors
                                                                  .black38,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                          alignLabelWithHint:
                                                              false,
                                                          contentPadding:
                                                              const EdgeInsets.all(
                                                                  15),
                                                          enabledBorder: OutlineInputBorder(
                                                              borderSide: const BorderSide(
                                                                  color: Colors
                                                                      .black26),
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      1)),
                                                          focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.black26), borderRadius: BorderRadius.circular(0)))),
                                                ),
                                                Row(children: [
                                                  bt_depot,
                                                  const SizedBox(width: 10),
                                                  bt_retrait
                                                ])
                                              ]))
                                    ])
                              ]))
                    ]))));
  }

  loadNotif() {
    if (isOnLoad) return;
    isOnLoad = true;

    base.selectNotifications(
        '$tableUser/${userActif['login']}/$tableNotification', (notyf) {
      setState(() {
        isOnLoad = false;
        listNotification = [];

        isHaveNotyfNonVu = false;

        for (var notif in notyf) {
          bool b = true;
          try {
            b = notif['vu'];
          } catch (e) {}
          if (isHaveNotyfNonVu == false && b == false) {
            isHaveNotyfNonVu = true;
          }

          listNotification.add(DataRow(
            onSelectChanged: (value) {
              loading.show('Traitement');

              base.updateDemande(
                  '$tableUser/${userActif['login']}/$tableNotification',
                  notif['date'],
                  {'vu': true}, (result, value) {
                // LOADING STOP
                loading.hide();

                // pass
                loadNotif();
              });
            },
            cells: <DataCell>[
              DataCell(Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Text(notif['title'],
                      style: TextStyle(
                          fontWeight:
                              notif['vu'] ? FontWeight.normal : FontWeight.bold,
                          fontSize: 15)),
                  Text(notif['description'],
                      style: TextStyle(
                          fontWeight:
                              notif['vu'] ? FontWeight.normal : FontWeight.bold,
                          fontSize: 13)),
                  Row(
                    children: [
                      Icon(
                          notif['vu']
                              ? Icons.check
                              : Icons.radio_button_checked,
                          color: notif['vu'] ? Colors.grey : Colors.green,
                          size: 15),
                      const SizedBox(width: 5),
                      Text(notif['date'],
                          style: const TextStyle(
                              fontStyle: FontStyle.italic, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 5),
                ],
              )),
            ],
          ));
        }
      });
    });
  }

  screen3(BuildContext context) {
    loadNotif();
    // Future.delayed(Duration(seconds: 30), () {
    //   isOnLoad = false;
    // });

    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      appBar,
                      Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                          child: Column(children: [
                            $CONTAINER(
                                ratio_y: 0.03,
                                context: context,
                                child: const Text('Liste des notifications')),
                            $CONTAINER(
                                ratio_y: 0.02,
                                context: context,
                                child: const SizedBox(height: 10)),
                            $CONTAINER(
                                ratio_y: 0.73,
                                context: context,
                                child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: DataTable(
                                        headingRowHeight: 0,
                                        showCheckboxColumn: false,
                                        dataRowHeight: 75,
                                        horizontalMargin: 0,
                                        columns: const <DataColumn>[
                                          DataColumn(
                                            label: Expanded(
                                              child: Text(''),
                                            ),
                                          ),
                                        ],
                                        rows: listNotification)))
                          ]))
                    ]))));
  }
}

class Menu extends StatefulWidget {
  Menu({super.key, required this.isHaveNotyfNonVu});

  bool isHaveNotyfNonVu;
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> with SingleTickerProviderStateMixin {
  late SimpleHiddenDrawerController controller;

  late AnimationController _animationController;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    super.initState();
  }

  void _runAnimation() async {
    for (int i = 0; i < 3; i++) {
      await _animationController.forward();
      await _animationController.reverse();
    }
  }

  @override
  void didChangeDependencies() {
    controller = SimpleHiddenDrawerController.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light));

    // Future.delayed(const Duration(seconds: 2), () {
    _runAnimation();
    // });
    return Container(
      width: MediaQuery.of(context).size.width - 100,
      height: double.maxFinite,
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: [
                const SizedBox(height: 50),
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
                const SizedBox(height: 30),
                Ink(
                  color: Colors.blueGrey[50],
                  child: InkWell(
                      onTap: () {
                        controller.setSelectedMenuPosition(0);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.dashboard),
                                SizedBox(width: 5),
                                Text('Dashboard'),
                              ],
                            ),
                            const Icon(Icons.arrow_right_rounded)
                          ],
                        ),
                      )),
                ),
                const SizedBox(height: 10),
                Ink(
                  color: Colors.blueGrey[50],
                  child: InkWell(
                      onTap: () {
                        controller.setSelectedMenuPosition(1);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.wallet),
                                SizedBox(width: 5),
                                Text('Porte feuille'),
                              ],
                            ),
                            const Icon(Icons.arrow_right_rounded)
                          ],
                        ),
                      )),
                ),
                const SizedBox(height: 10),
                Ink(
                  color: Colors.blueGrey[50],
                  child: InkWell(
                      onTap: () {
                        controller.setSelectedMenuPosition(2);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.mail),
                                SizedBox(width: 5),
                                Text('Notification'),
                              ],
                            ),
                            Row(
                              children: [
                                if (widget.isHaveNotyfNonVu)
                                  RotationTransition(
                                      turns: Tween(begin: 0.0, end: -.1)
                                          .chain(CurveTween(
                                              curve: Curves.elasticIn))
                                          .animate(_animationController),
                                      child: const Icon(
                                          Icons.notifications_active,
                                          color: Colors.green,
                                          size: 17)),
                                const Icon(Icons.arrow_right_rounded),
                              ],
                            )
                          ],
                        ),
                      )),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Ink(
                color: Colors.blueGrey[50],
                child: InkWell(
                    onTap: () {
                      changeScreen(context, '/seconnect');
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.person),
                              SizedBox(width: 5),
                              Text('Se deconnecter'),
                            ],
                          ),
                          const Icon(Icons.power_settings_new)
                        ],
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
