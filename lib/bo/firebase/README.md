# all firebase 
- db 
- storage 
- etc ...

> install
flutter pub add firebase_core

run on cmd ext (not in vscode)
dart pub global activate flutterfire_cli  // from firebase db source
copie file ('flutterfire.bat') to project 
flutterfire configure --project=amoi-1998  // from firebase db source


> install firestore
flutter pub add cloud_firestore

> config obligatoire 
android/app/build.gradle
change that
     minSdkVersion 20

// ==================================================================
>> UTILISATION

> delcare
$FIREBASE base = $FIREBASE();

> insert data 
base.insert(
     'table',
     'id',
     {'full_name': "Rayan BO", 'age': 24},
     (result, value) {
          print('de > $result');
     },
);

> select data 
base.select('table', 'id', (result, value) {
     late Map<String, dynamic> user;
     user = value.data() as Map<String, Object?>;
     loading(false);
});

TODO : update

TODO : delete 