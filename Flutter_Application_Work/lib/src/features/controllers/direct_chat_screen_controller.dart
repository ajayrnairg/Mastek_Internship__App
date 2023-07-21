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
import 'package:flutter/services.dart';

class DirectChatScreenController extends GetxController {
  static DirectChatScreenController get find => Get.find();

  // bool switchValue = true;

  List<Map<String, String>> combinedMessages = [];

  TextEditingController messageTextEditingController = TextEditingController();

  bool isAnyMessageSelected = false;
  int? selectedMessageIndex;
  String selectedMessageDesiredLanguage = "";

  List<Widget> languages = <Widget>[];
  final List<bool> selectedLanguages = <bool>[true, false];

  final audioPlayer = AudioPlayer();
  bool isPlaying = false;

  void initializeTogglerData(selectedLang1, selectedLang2){
    languages.add(Text("$selectedLang1"));
    languages.add(Text("$selectedLang2"));
  }

  void addSelectedMessageToClipboard() async{
    String messageText = (combinedMessages[selectedMessageIndex!][selectedMessageDesiredLanguage])!;
    await Clipboard.setData(ClipboardData(text: messageText));
  }


  goToDirectMainChatFunc(selectedLang1, selectedLang2) {
    Get.to(() => DirectChatMainScreen(
        selectedLang1: selectedLang1, selectedLang2: selectedLang2));
  }

  String getSideValue() {
    if (selectedLanguages[0]) {
      return "Left";
    } else {
      return "Right";
    }
  }

  Future<String> get _localPath async {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }

  Future<String> translateText(String message, String language) async {
    return await TranslationApi.translate(
        message, Languages.getLanguageCode(language));
  }

  Future<String> getSpeechToTextResults(
      String audioPath, String language) async {
    return await STT()
        .transcribe(audioPath, Languages.getLanguageCode(language));
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

  Future<void> buildAndAddMessage(String side, String fromLanguage, String toLanguage,
      {bool isAudioMessage = false}) async {
    if (messageTextEditingController.text.trim() != "" || isAudioMessage) {
      final tempPath = await _localPath;
      String? filePath = '$tempPath/${combinedMessages.length}-Original.wav';
      String message = messageTextEditingController.text;

      if (isAudioMessage) {
        message = await getSpeechToTextResults(filePath, fromLanguage);
      }

      String translatedText = await translateText(message, toLanguage);
      if(isAudioMessage && translatedText == ""){
        return;
      }

      Map<String, String> newMessageData = {
        "message_id": "${combinedMessages.length}",
        "message_original_language": fromLanguage,
        "message_original_text": message,
        "message_language_side": side,
        "message_original_audio_content": filePath ?? "",
        "message_original_TTS_audio_content": "",
        "message_translation_language": toLanguage,
        "message_translation_text": translatedText,
        "message_translation_audio_content": "",
        "message_timestamp":
            "${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}:${DateTime.now().millisecond}"
      };
      combinedMessages.add(newMessageData);
    }
    messageTextEditingController.text = "";
  }

  Future<String> getOrCreateTranslationAudioPath(String messageId, String textSource) async {
    String audioPath;
    if(textSource == "message_original_text"){
      audioPath = "message_original_TTS_audio_content";
    }else{
      audioPath = "message_translation_audio_content";
    }


    if (combinedMessages[int.parse(messageId)]
            [audioPath] !=
        "") {
      return combinedMessages[int.parse(messageId)]
              [audioPath]!
          .trim();
    } else {
      final tempPath = await _localPath;
      String filepath = await textToSpeechPath(
          combinedMessages[int.parse(messageId)][textSource]!,
          (textSource == "message_original_text")?"$tempPath/$messageId-TTS":"$tempPath/$messageId-Translated",
          (textSource == "message_original_text")? combinedMessages[int.parse(messageId)]
          ["message_original_language"]!:combinedMessages[int.parse(messageId)]
          ["message_translation_language"]!);
      combinedMessages[int.parse(messageId)]
      [audioPath] = filepath.trim();

      return filepath.trim();
    }
  }

  Future<void> playSelectedMessageAsAudio() async{
    String filepath = await getOrCreateTranslationAudioPath("$selectedMessageIndex", selectedMessageDesiredLanguage);
    await audioPlayer
        .play(DeviceFileSource(filepath));
  }

  void printData() {
    print("--------Combined Messages----------");
    print(combinedMessages);
  }

  void clearData() {
    combinedMessages = [];

  }


}
