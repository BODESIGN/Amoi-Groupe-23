// ignore_for_file: camel_case_types, must_be_immutable

import 'package:amoi/bo/componantes/custom/bo_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../main.dart';

class screenAdministrator extends StatefulWidget {
  screenAdministrator({super.key, required this.rootName});

  String rootName;
  @override
  State<screenAdministrator> createState() => _screenAdministratorState();
}

class _screenAdministratorState extends State<screenAdministrator> {
  List columns = ['Login', 'Date de demande', 'Num. Telephone', 'Montant'];
  late List datas = [];
  String type = 'Depot';
  late $MODALE modale;

  List<DataColumn> generateColumn() {
    List<DataColumn> res = [];
    for (var element in columns) {
      res.add(DataColumn(
          label: Expanded(
        child: Text(
          element,
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
      )));
    }
    return res;
  }

  List<DataRow> generateRow() {
    List<DataRow> res = [];
    for (var element in datas) {
      res.add(DataRow(
        onSelectChanged: (value) {
          setState(() {
            modale.child = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Date de demande : ${element['dateDemande']}'),
                Text('Login : ${element['login']}'),
                Text('Téléphone : ${element['numero']}'),
                Text('Montant : ${element['montant']} Ar'),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white),
                        onPressed: () {
                          traiter('Traiter', element);
                        },
                        child: Text('Traiter')),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white),
                        onPressed: () {
                          traiter('Supprimer', element);
                        },
                        child: Text('Supprimer')),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            );
            modale.show();
          });
        },
        cells: <DataCell>[
          DataCell(Text(element['login'].toString())),
          DataCell(Text(element['dateDemande'].toString())),
          DataCell(Text(element['numero'].toString())),
          DataCell(Text('${element['montant']} Ar')),
        ],
      ));
    }
    return res;
  }

  calculeRow() {
    loading.show('Selection des données');

    // base
    base.select(tableDemande, type, (result, value) {
      if (result == 'error') toast.show('Aucune demande trouver !');
      if (result == 'error') loading.hide();
      if (result == 'error') return;

      Map<String, Object?> res = value.data() as Map<String, Object?>;
      setState(() => {datas = []});
      res.forEach((key, value) {
        setState(() {
          datas.add(value);
        });
      });

      datas.removeWhere((element) {
        return element['dateDemande'] == null;
      });

      setState(() {});
      loading.hide();
    });
  }

  void traiter(String s, Map element) {
    loading.show('Traitement en cours');

    String login = element['login'].toString();
    int mont = int.parse(element['montant'].toString());

    if (s == 'Traiter') {
      base.updateAriary(login, mont, (value) {
        toast.show('Solde de la fiche mis a jour');
      });
      // Notification
      base.insertNotification(login, 'Sold mis a jour !',
          'Votre solde est mis a jour suit a votre dernière demande', (value) {
        toast.show('Notification envoyé');
      });
    }

    base.updateDemande(tableDemande, type, {element['login'].toString(): {}},
        (result, value) {
      // LOADING STOP
      loading.hide();
      Navigator.pop(context);

      // pass
      toast.show('Traitement éffectuée');
      calculeRow();
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.blue,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light));
    toast.init(context);
    modale = $MODALE(context, '', '')..type = 'CUSTOM';

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text('List des demandes de $type',
              style: const TextStyle(color: Colors.white, fontSize: 13)),
          leading: IconButton(
            icon: const Icon(Icons.power_settings_new, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: <Widget>[
            PopupMenuButton<String>(
              icon: const Icon(Icons.menu, color: Colors.white),
              color: Colors.blueGrey,
              onSelected: (String result) {
                switch (result) {
                  case 'Depot':
                    // toast.show('Depot');
                    break;
                  case 'Retrait':
                    // toast.show('Retrait');
                    break;
                  default:
                }
                setState(() {
                  type = result;
                });
                calculeRow();
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'Depot',
                  child: Text('Demande Dépôt',
                      style: TextStyle(color: Colors.white)),
                ),
                const PopupMenuItem<String>(
                  value: 'Retrait',
                  child: Text('Demande de Retait',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {
                calculeRow();
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: DataTable(
                showCheckboxColumn: false,
                columns: generateColumn(),
                rows: generateRow()),
          ),
        ));
  }
}
