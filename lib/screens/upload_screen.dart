import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/auth.dart';

class UploadImage extends StatelessWidget {
  final AuthService _auth = new AuthService();
  late File _image;

  @override
  Widget build(BuildContext context) {
    final SignOut = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          await _auth.signOut();
          Navigator.pushNamed(context, 'category');
        },
        child: Text(
          "Logout",
          style: TextStyle(color: Theme.of(context).primaryColorLight),
          textAlign: TextAlign.center,
        ),
      ),
    );

    return Scaffold(
      body: Column(
        children: [
          IconButton(
              onPressed: () async {
                ImagePicker imagePicker = ImagePicker();
                XFile? file = await imagePicker.pickImage(source: ImageSource.camera);
                if(file == null) return;
                _auth.uploadImageFromCamera(file.path, file.name);
              },
              icon: Icon(Icons.camera_alt)),
          Center(
            child: ElevatedButton(
              child: Text('Upload File'),
              onPressed: () async {
                final result = await FilePicker.platform.pickFiles(
                  allowMultiple: false,
                  type: FileType.custom,
                  allowedExtensions: ['png', 'jpg'],
                );

                if (result == null) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('No file selected'),
                  ));
                  return null;
                }
                final path = result.files.single.path!;
                final fileName = result.files.single.name;

                _auth.uploadFile(path, fileName).then((value) => print('Done'));
              },
            ),
          ),
          Center(child: SignOut,),
        ],
      ),
    );
  }
}
