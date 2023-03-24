// a very simple program which opens camera page,capture a image and show the snapshot and video
//no memroy is alocated therefore no alocation/ no saving
//flutter_camera

import 'package:flutter/material.dart';

import 'dart:io';

import 'package:flutter_camera/flutter_camera.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FlutterCamera(
        color: Colors.amber,
        onImageCaptured: (value) {
          final path = value.path;
          print("::::::::::::::::::::::::::::::::: $path");
          if (path.contains('.jpg')) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Image.file(File(path)),
                  );
                });
          }
        },
        onVideoRecorded: (value) {
          final path = value.path;
          print('::::::::::::::::::::::::;; dkdkkd $path');
        },
      ),
    );
    // return Container();
  }
}
