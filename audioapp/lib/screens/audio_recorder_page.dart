import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'dart:io';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //-----------------------------------
  late FlutterSoundRecorder myRecorder;
  final audioplayer = AssetsAudioPlayer();
  // bool play = false;
  String filePath = '';
  String recordedText = '00:00:00';

  //-----------------------------------

  @override
  void initState() {
    super.initState();
    startIt();
  }

  void startIt() async {
    filePath = 'Internal/Sounds';
    myRecorder = FlutterSoundRecorder();

    await myRecorder.openRecorder();
    await myRecorder.setSubscriptionDuration(Duration(milliseconds: 10));
    await initializeDateFormatting(); // pre built external function

    await Permission.microphone.request();
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
  }

  Future<void> record() async {
    Directory? dir = Directory(path.dirname(filePath));
    print("-------------------------------------------");
    print(dir);
    print(filePath);
    if (!dir.existsSync()) {
      //print("dir exists");
      dir.createSync();
    }
    myRecorder.openRecorder();
    await myRecorder.startRecorder(
      toFile: filePath,
      codec: Codec.pcm16WAV,
    );

    StreamSubscription recorderSubscription =
        myRecorder.onProgress!.listen((e) {
      var date = DateTime.fromMillisecondsSinceEpoch(e.duration.inMilliseconds,
          isUtc: true);
      var txt = DateFormat('mm:ss:SS', 'en_GB').format(date);
      print("-------------------------------------------");
      print(txt);

      setState(() {
        recordedText = txt.substring(0, 8);
        print("-------------------------------------------");
        print(recordedText);
      });
    });
    recorderSubscription.cancel();
  }

  Future<void> stopRecord() async {
    myRecorder.closeRecorder();
    return await myRecorder.closeRecorder();
  }

  Future<void> startPlaying() async {
    audioplayer.open(
      Audio.file(filePath),
      autoStart: true,
      showNotification: true,
    );
  }

  Future<void> stopPlaying() async {
    audioplayer.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Record screen"),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 20.h,
          ),
          Center(
            child: Text(
              recordedText,
              style: TextStyle(fontSize: 70.h),
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          SizedBox(
            height: 250.h,
          ),
          Padding(
            padding: EdgeInsets.all(8.0.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    record();
                    // Add your onPressed code here!
                  },
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.mic),
                ),
                // SizedBox(
                //   width: 50.h,
                // ),
                FloatingActionButton(
                  onPressed: () {
                    stopRecord();
                    // Add your onPressed code here!
                  },
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.stop),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          Padding(
            padding: EdgeInsets.all(8.0.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    startPlaying();

                    // Add your onPressed code here!
                  },
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.play_arrow),
                ),
                // SizedBox(
                //   width: 50.h,
                // ),
                FloatingActionButton(
                  onPressed: () {
                    stopPlaying();
                    // Add your onPressed code here!
                  },
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.stop),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
