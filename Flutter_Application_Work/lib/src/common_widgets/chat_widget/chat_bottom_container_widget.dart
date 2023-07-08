import 'package:flutter/material.dart';
import 'package:rough_app/src/features/controllers/direct_chat_screen_controller.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatBottomContainerWidget extends StatefulWidget {
  const ChatBottomContainerWidget({
    super.key,
    required this.directChatScreenController,
    required this.callback,
  });

  final Function callback;

  final DirectChatScreenController directChatScreenController;

  @override
  State<ChatBottomContainerWidget> createState() =>
      _ChatBottomContainerWidgetState();
}

class _ChatBottomContainerWidgetState extends State<ChatBottomContainerWidget> {
  final recorder = FlutterSoundRecorder();
  bool isRecorderReady = false;
  bool recordStatus = false;

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
    recordStatus = true;
    await recorder.startRecorder(toFile: 'audio.mp4');
  }

  Future stop() async {
    if (!isRecorderReady) return;
    recordStatus = false;
    final path = await recorder.stopRecorder();
    final audioFile = File(path!);
    debugPrint("Recorded audio: $audioFile");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.black.withOpacity(0.8)),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: !recordStatus
                  ? TextField(
                      controller: widget.directChatScreenController
                          .messageTextEditingController,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: "type a message ....",
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                        ),
                      ),
                    )
                  : StreamBuilder<RecordingDisposition>(
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
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                            ),
                        );
                      },
                    ),
            ),
            IconButton(
              color: Colors.blue,
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
              icon: Icon(Icons.mic_outlined),
            ),
            IconButton(
              color: Colors.blue,
              onPressed: () {},
              icon: Icon(Icons.volume_up_outlined),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                widget.callback();

                // setState(() {
                //   directChatScreenController.addMessage();
                // });
              },
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
