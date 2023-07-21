import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rough_app/src/constants/text_strings.dart';
import 'package:rough_app/src/features/controllers/home_screen_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:rough_app/src/features/controllers/translate_screen_controller.dart';
import '../../../utils/helperfunctions/languages.dart';
import '../../../utils/apis/speechToText.dart';
import '../../../utils/apis/translation_api.dart';
//for COdec
import 'package:flutter_sound/flutter_sound.dart';

class TranslateScreen extends StatelessWidget {
  const TranslateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TranslateAppSample(title: 'Translate'),
    );
  }
}

class TranslateAppSample extends StatefulWidget {
  const TranslateAppSample({super.key, required this.title});

  final String title;

  @override
  State<TranslateAppSample> createState() => _TranslateAppSampleState();
}

class _TranslateAppSampleState extends State<TranslateAppSample> {
  final translateScreenController = Get.put(TranslateScreenController());
  final recordertrans = FlutterSoundRecorder();
  bool isRecorderTransReady = false;
  bool recordTransStatus = false;
  bool vertical = false;
  final inputcontroller = TextEditingController();
  final inputconverted = TextEditingController();
  static const List<String> listlan = <String>[
    'English',
    'Hindi',
    'Malayalam',
    'Tamil',
    'Kannada',
    'Telugu'
  ];
  String dropdownValue1 = listlan.first;
  String dropdownValue2 = listlan.first;
  String _containerbox1 = "";
  String _containerbox2 = "";
  _TranslateAppSampleState() {
    dropdownValue1 = listlan.firstOrNull!;
    dropdownValue2 = listlan.firstOrNull!;
    _containerbox1 = "";
    _containerbox2 = "";
  }
  void initState() {
    super.initState();
    initRecorder();
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }

    await recordertrans.openRecorder();
    isRecorderTransReady = true;
    recordertrans.setSubscriptionDuration(
      const Duration(milliseconds: 500),
    );
  }

  Future<String> get _localPath async {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }

  Future record(String messageIdAsName) async {
    if (!isRecorderTransReady) return;
    final tempPath = await _localPath;
    recordTransStatus = true;
    print("temporary path: $tempPath");
    // await recorder.startRecorder(toFile: '$messageIdAsName.mp4');
    // recordTransStatus = true;
    await recordertrans.startRecorder(
        toFile: '$tempPath/translationPageAudio.wav', codec: Codec.pcm16WAV);
  }

  Future stop() async {
    if (!isRecorderTransReady) return;
    recordTransStatus = false;
    final path = await recordertrans.stopRecorder();
    final audioFile = File(path!);
    debugPrint("Recorded audio: $audioFile");
  }

  Future<String> getSpeechToTextResults(String audioPath, String language) async {
    print(audioPath);
    return await STT()
        .transcribe(audioPath, Languages.getLanguageCode(language));
  }

  Future<String> translateText(String message, String language) async {
    print(message);
    return await TranslationApi.translate(
        message, Languages.getLanguageCode(language));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_back_ios),
          ), actions: [
            IconButton(
              onPressed: () {
                setState(() {

                });
              },
              icon: Icon(Icons.abc),
            )
        ],
        ),
        body: Column(
          children: [
            Container(
                height: 300,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 245,
                          decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                          child: DropdownButtonFormField(
                            isExpanded: true,
                            value: dropdownValue1,
                            items: listlan
                                .map(
                                  (e) => DropdownMenuItem(
                                    child: Text(
                                      e,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                    value: e,
                                  ),
                                )
                                .toList(),
                            onChanged: (val) async {
                              print(inputcontroller.text);
                              final String containerbox1 = await translateText(inputcontroller.text, val!);
                              inputcontroller.text = containerbox1;
                              final String containerbox2 = await translateText(inputcontroller.text, dropdownValue2);
                              inputconverted.text = containerbox2;
                              setState(() {
                                dropdownValue1 = val!;
                              });
                            },
                            icon: Icon(
                              Icons.arrow_drop_down_circle,
                              color: Colors.blue,
                            ),
                            decoration: InputDecoration(
                                labelText: gChooseFirstLang,
                                prefixIcon: Icon(Icons.sort_by_alpha_rounded),
                                border: OutlineInputBorder()),
                          ),
                        ),
                        IconButton(
                          color: Colors.blue,
                          iconSize: 50,
                          onPressed: () async {
                            if (recordertrans.isRecording) {
                              // debugPrint("was running");
                              print("stop");
                              await stop();
                              print("getting audiocontent");
                              print(dropdownValue1);
                              final tempPath = await _localPath;
                              final String containerbox1 = await getSpeechToTextResults("$tempPath/translationPageAudio.wav", dropdownValue1);
                              print(containerbox1);

                              final String containerbox2 = await translateText(containerbox1, dropdownValue2);
                              print("Message is: "+containerbox2);
                              inputcontroller.text = containerbox1;
                              inputconverted.text = containerbox2;
                              setState(() {

                              });

                              // if (widget.directChatScreenController.switchValue) {
                              //   await widget.directChatScreenController.buildAndAddMessage(
                              //       widget.directChatScreenController.getSideValue(),
                              //       widget.selectedLang1,
                              //       widget.selectedLang2,
                              //       isAudioMessage: true);
                              // } else {
                              //   await widget.directChatScreenController.buildAndAddMessage(
                              //       widget.directChatScreenController.getSideValue(),
                              //       widget.selectedLang2,
                              //       widget.selectedLang1,
                              //       isAudioMessage: true);
                              // }
                            } else {
                              // debugPrint("was not running");
                              await record(
                                  "translationPageAudio");
                              debugPrint("now started");
                            }
                          },
                          icon: recordTransStatus ? Icon(Icons.pause) : Icon(Icons.mic),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 320,
                      height: 150,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        // border: Border(top: BorderSide(color: Colors.lightBlue, width: 3.0), bottom: BorderSide(color: Colors.lightBlue,  width: 3.0), left: BorderSide(color: Colors.lightBlue,  width: 3.0), right: BorderSide(color: Colors.lightBlue,  width: 3.0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white,
                            offset: Offset(0.0, 0.0),
                            blurRadius: 1.0,
                            spreadRadius: 2.0,
                          ), //BoxShadow
                        ],
                      ),
                      child: TextField(
                        controller: inputcontroller,
                        style: TextStyle(color: Colors.lightBlue, fontSize: 20),
                      ),
                    )
                  ],
                )),
            const SizedBox(
              height: 10,
            ),
            Container(
                color: Colors.lightBlue,
                height: 352.5,
                padding:
                    const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 300,
                          decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                          child: DropdownButtonFormField(
                            isExpanded: true,
                            value: dropdownValue2,
                            items: listlan
                                .map(
                                  (e) => DropdownMenuItem(
                                    child: Text(
                                      e,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                    value: e,
                                  ),
                                )
                                .toList(),
                            onChanged: (val) async {
                              print(inputconverted.text);
                              final String containerbox1 = await translateText(inputconverted.text, val!);
                              inputconverted.text = containerbox1;
                              final String containerbox2 = await translateText(inputconverted.text, dropdownValue1);
                              inputcontroller.text = containerbox2;
                              setState(() {
                                dropdownValue2 = val!;
                              });
                            },
                            icon: Icon(
                              Icons.arrow_drop_down_circle,
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                                labelText: gChooseSecondLang,
                                prefixIcon: Icon(Icons.sort_by_alpha_rounded),
                                border: OutlineInputBorder()),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 320,
                      height: 110,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        // border: Border(top: BorderSide(color: Colors.lightBlue, width: 3.0), bottom: BorderSide(color: Colors.lightBlue,  width: 3.0), left: BorderSide(color: Colors.lightBlue,  width: 3.0), right: BorderSide(color: Colors.lightBlue,  width: 3.0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white,
                            offset: Offset(0.0, 0.0),
                            blurRadius: 1.0,
                            spreadRadius: 2.0,
                          ), //BoxShadow
                        ],
                      ),
                      child: TextField(
                        controller: inputconverted,
                        style: TextStyle(color: Colors.lightBlue, fontSize: 20),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          color: Colors.white,
                          iconSize: 50,
                          onPressed: () {},
                          icon: const Icon(Icons.volume_up_sharp),
                        ),
                        IconButton(
                          color: Colors.white,
                          iconSize: 50,
                          onPressed: () {},
                          icon: const Icon(Icons.copy_rounded),
                        ),
                      ],
                    ),
                  ],
                ))
          ],
        ));
  }
}
