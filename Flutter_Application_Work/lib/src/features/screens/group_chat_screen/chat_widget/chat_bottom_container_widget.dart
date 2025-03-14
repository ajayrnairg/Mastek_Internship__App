import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rough_app/src/features/controllers/direct_chat_screen_controller.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';

//for COdec
import 'package:flutter_sound/flutter_sound.dart';
import 'package:rough_app/src/features/controllers/group_chat_screen_controller.dart';

import '../../../controllers/chat_screen_controller.dart';

class ChatBottomContainerWidget extends StatefulWidget {
  const ChatBottomContainerWidget(
      {super.key,
      required this.selectedLanguage,
      required this.groupChatScreenController});

  final String selectedLanguage;
  final GroupChatScreenController groupChatScreenController;

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

  Future<String> get _localPath async {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }

  Future record(String messageIdAsName) async {
    if (!isRecorderReady) return;
    final tempPath = await _localPath;
    print("temporary path: $tempPath");
    // await recorder.startRecorder(toFile: '$messageIdAsName.mp4');
    recordStatus = true;
    await recorder.startRecorder(
        toFile: '$tempPath/$messageIdAsName-Original.wav',
        codec: Codec.pcm16WAV);
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
        // height: double.infinity,
        decoration: BoxDecoration(
            // borderRadius: BorderRadius.circular(10.0),
            color: Colors.black.withOpacity(0.8)),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: !recordStatus
                  ? TextField(
                      textInputAction: TextInputAction.newline,
                      maxLines: 4,
                      minLines: 1,
                      // expands: true,
                      controller: widget
                          .groupChatScreenController.messageTextEditingController,
                      style: const TextStyle(
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
                          style: const TextStyle(
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
                  widget.groupChatScreenController
                      .addMessage(widget.selectedLanguage, true);
                  // widget.groupChatScreenController
                  //     .addMessage(widget.selectedLanguage, true);

                  // widget.updateParentUI();
                } else {
                  // debugPrint("was not running");
                  await record("ChatScreen");
                  // debugPrint("now started");
                }

                setState(() {});
              },
              icon: recordStatus ? Icon(Icons.stop) : Icon(Icons.mic_outlined),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                widget.groupChatScreenController
                    .addMessage(widget.selectedLanguage, false);
                // widget.callback();


              },
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
