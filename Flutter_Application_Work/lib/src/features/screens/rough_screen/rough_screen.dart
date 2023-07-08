import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';


class RoughScreen extends StatefulWidget {
  const RoughScreen({super.key, required this.title});

  final String title;

  @override
  State<RoughScreen> createState() => _RoughScreenState();
}

class _RoughScreenState extends State<RoughScreen> {
  final recorder = FlutterSoundRecorder();
  bool isRecorderReady = false;

  @override
  void initState() {
    super.initState();
    initRecorder();
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    super.dispose();
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }

    await recorder.openRecorder();
    isRecorderReady = true;
    recorder.setSubscriptionDuration(
      const Duration(milliseconds: 500),
    );
  }

  Future record() async {
    if (!isRecorderReady) return;

    await recorder.startRecorder(toFile: 'audio.mp4');
  }

  Future stop() async {
    if (!isRecorderReady) return;
    final path = await recorder.stopRecorder();
    final audioFile = File(path!);
    debugPrint("Recorded audio: $audioFile");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<RecordingDisposition>(
                stream: recorder.onProgress,
                builder: (context, snapshot) {
                  final duration = snapshot.hasData
                      ? snapshot.data!.duration
                      : Duration.zero;

                  String twoDigits(int n) => n.toString().padLeft(2, '0');
                  final twoDigitMinutes =
                  twoDigits(duration.inMinutes.remainder(60));
                  final twoDigitSeconds =
                  twoDigits(duration.inSeconds.remainder(60));

                  return Text(
                    '$twoDigitMinutes:$twoDigitSeconds',
                    style: const TextStyle(
                        fontSize: 80, fontWeight: FontWeight.bold),
                  );
                }),
            const SizedBox(height: 40),
            // Icon(recorder.isRecording ? Icons.stop : Icons.mic,size:100),

            ElevatedButton(
                onPressed: () async {
                  if (recorder.isRecording) {
                    // debugPrint("was running");
                    await stop();
                    // debugPrint("now stopped");
                  } else {
                    // debugPrint("was not running");
                    await record();
                    // debugPrint("now started");
                  }

                  setState(() {});
                },
                child: Icon(
                  recorder.isRecording ? Icons.stop : Icons.mic,
                  size: 80,
                )),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
