import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rough_app/src/features/screens/direct_chat_screen/direct_chat_main_screen.dart';

import '../../utils/apis/TextToSpeechAPI.dart';
import '../../utils/apis/speechToText.dart';
import '../../utils/apis/translation_api.dart';
import '../../utils/helperfunctions/languages.dart';
import '../../utils/helperfunctions/voiceAndLanguages.dart';

class TranslateScreenController extends GetxController{
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;

  Future<String> get _localPath async {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }

  Future<String> getSpeechToTextResults(
      String audioPath, String language) async {
    print(audioPath);
    return await STT()
        .transcribe(audioPath, Languages.getLanguageCode(language));
  }

  Future<String> translateText(String message, String language) async {
    print(message);
    return await TranslationApi.translate(
        message, Languages.getLanguageCode(language));
  }

  Future<String> textToSpeechPath(
      String text, String filename, String toLanguage) async {
    final nameLangCode =
    VoiceAndLanguages.getVoiceAndLanguageCode(toLanguage, "FEMALE");

    final String audioContent = await TextToSpeechAPI()
        .synthesizeText(text, nameLangCode[0], nameLangCode[1]);
    print("audiocontent is $audioContent");
    final bytes =
    const Base64Decoder().convert(audioContent, 0, audioContent.length);

    final file = File('$filename.wav');
    await file.writeAsBytes(bytes);
    print(file.path);

    return file.path;
  }

  Future<void> playSelectedMessageAsAudio(String textSource, String textLanguage) async{
    final tempPath = await _localPath;
    String filepath = await textToSpeechPath(textSource, "$tempPath/translationPageTranslationSpeechAudio", textLanguage);
    await audioPlayer
        .play(DeviceFileSource(filepath));
  }

  void goToHomePageFunc(){
    Get.back();
  }




}
