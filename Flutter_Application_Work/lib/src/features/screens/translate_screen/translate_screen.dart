import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rough_app/src/constants/text_strings.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:rough_app/src/features/controllers/translate_screen_controller.dart';

//for COdec
import 'package:flutter_sound/flutter_sound.dart';
import 'package:rough_app/src/features/screens/translate_screen/translate_split_screen_bottom_widget.dart';
import 'package:rough_app/src/features/screens/translate_screen/translate_split_screen_top_widget.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';

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
  final recorder = FlutterSoundRecorder();
  bool isRecorderReady = false;
  bool recordStatus = false;
  bool vertical = false;

  final originalTextController = TextEditingController();
  final translatedTextController = TextEditingController();

  static const List<String> languageList = <String>[
    gLanguage1,
    gLanguage2,
    gLanguage3,
    gLanguage4,
    gLanguage5,
    gLanguage6,
    gLanguage7,
  ];

  String dropdownValue1 = languageList.first;
  String dropdownValue2 = languageList.first;

  _TranslateAppSampleState() {
    dropdownValue1 = languageList.firstOrNull!;
    dropdownValue2 = languageList.firstOrNull!;
  }

  Future<String> get _localPath async {
    final directory = await getTemporaryDirectory();
    return directory.path;
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

  Future record(String messageIdAsName) async {
    if (!isRecorderReady) return;
    final tempPath = await _localPath;
    recordStatus = true;
    // print("temporary path: $tempPath");
    await recorder.startRecorder(
        toFile: '$tempPath/translationPageInputSpeechAudio.wav',
        codec: Codec.pcm16WAV);
  }

  Future stop() async {
    if (!isRecorderReady) return;
    recordStatus = false;
    final path = await recorder.stopRecorder();
    final audioFile = File(path!);
    debugPrint("Recorded audio: $audioFile");
  }

  void dropDownFunction1(val) async {
    // print(originalTextController.text);
    if (originalTextController.text != "") {
      final String originalText = await translateScreenController.translateText(
          originalTextController.text, val!);
      originalTextController.text = originalText;
      final String translatedText = await translateScreenController
          .translateText(originalTextController.text, dropdownValue2);
      translatedTextController.text = translatedText;
    }
    setState(() {
      dropdownValue1 = val!;
    });
  }

  void dropDownFunction2(val) async {
    // print(translatedTextController.text);
    if (originalTextController.text != "") {
      final String translatedText = await translateScreenController
          .translateText(originalTextController.text, val!);
      translatedTextController.text = translatedText;
    }
    setState(() {
      dropdownValue2 = val!;
    });
  }

  void micRecordingFunction() async {
    if (recorder.isRecording) {
      // debugPrint("was running");
      // print("stop");
      await stop();
      // print("getting audiocontent");
      // print(dropdownValue1);
      final tempPath = await _localPath;
      final String originalText =
          await translateScreenController.getSpeechToTextResults(
              "$tempPath/translationPageInputSpeechAudio.wav", dropdownValue1);
      // print(originalText);

      final String translatedText = await translateScreenController
          .translateText(originalText, dropdownValue2);
      // print("Message is: " + translatedText);
      originalTextController.text = originalText;
      translatedTextController.text = translatedText;
      setState(() {});
    } else {
      // debugPrint("was not running");
      await record("translationPageAudio");
      debugPrint("now started");
    }

    setState(() {});
  }

  void speakButtonFunction() {
    translateScreenController.playSelectedMessageAsAudio(
        translatedTextController.text, dropdownValue2);
  }

  void copyClipboardButtonFunction() async {
    if (translatedTextController.text != "") {
      await Clipboard.setData(
          ClipboardData(text: translatedTextController.text));
    }
  }

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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: isDarkMode ? gDarkPurple : gDarkPurple,
        leading: IconButton(
          onPressed: () {
            translateScreenController.goToHomePageFunc();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TranslateSplitScreenTopWidget(
                  dropdownValue1: dropdownValue1,
                  languageList: languageList,
                  recordStatus: recordStatus,
                  originalTextController: originalTextController,
                  dropDownFunction1: dropDownFunction1,
                  micRecordingFunction: micRecordingFunction,
              ),
              const SizedBox(
                height: gSmallSpace,
              ),
              TranslateSplitScreenBottomWidget(
                dropdownValue2: dropdownValue2,
                  languageList: languageList,
                  translatedTextController: translatedTextController,
                  dropDownFunction2: dropDownFunction2,
                  speakButtonFunction: speakButtonFunction,
                  copyClipboardButtonFunction: copyClipboardButtonFunction
              ),
            ],
          ),
        ),
      ),
    );
  }
}

