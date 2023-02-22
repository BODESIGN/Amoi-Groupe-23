// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class MyPickImageScreen extends StatefulWidget {
//   MyPickImageScreen({super.key, required this.title});

//   final String title;

//   @override
//   _MyPickImageScreenState createState() => _MyPickImageScreenState();
// }

// class _MyPickImageScreenState extends State<MyPickImageScreen> {
//   late File imgFile;
//   final imgPicker = ImagePicker();
//   bool isLoad = true;

//   FirebaseStorage _storage = FirebaseStorage.instance;

//   Future<void> showOptionsDialog(BuildContext context) {
//     return showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text("Options"),
//             content: SingleChildScrollView(
//               child: ListBody(
//                 children: [
//                   GestureDetector(
//                     child: Text("Capture Image From Camera"),
//                     onTap: () {
//                       openCamera();
//                     },
//                   ),
//                   Padding(padding: EdgeInsets.all(10)),
//                   GestureDetector(
//                     child: Text("Take Image From Gallery"),
//                     onTap: () {
//                       openGallery();
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//   }

//   void openCamera() async {
//     var imgCamera = await imgPicker.getImage(source: ImageSource.camera);
//     setState(() {
//       imgFile = File(imgCamera!.path);
//       isLoad = false;
//     });
//     Navigator.of(context).pop();
//   }

//   void openGallery() async {
//     var imgGallery = await imgPicker.getImage(source: ImageSource.gallery);
//     setState(() {
//       imgFile = File(imgGallery!.path);
//       isLoad = false;
//     });
//     Navigator.of(context).pop();
//   }

//   uploadProfileImage() async {
//     Reference reference = FirebaseStorage.instance.ref().child('Pdp/bo');
//     UploadTask uploadTask = reference.putFile(imgFile);
//     TaskSnapshot snapshot = await uploadTask;
//     String imageUrl = await snapshot.ref.getDownloadURL();
//     print(imageUrl);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             !isLoad
//                 ? Image.file(imgFile, width: 350, height: 350)
//                 : Text('upload requis'),
//             SizedBox(height: 30),
//             ElevatedButton(
//               onPressed: () {
//                 showOptionsDialog(context);
//               },
//               child: Text("Select Image"),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 if (!isLoad) {
//                   print(imgFile.uri);
//                   await uploadProfileImage();
//                 }
//               },
//               child: Text("to firebase"),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
