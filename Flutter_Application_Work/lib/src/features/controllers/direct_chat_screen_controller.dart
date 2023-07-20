import 'dart:convert';
import 'dart:io';
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

class DirectChatScreenController extends GetxController {
  static DirectChatScreenController get find => Get.find();

  bool switchValue = true;

  List<Map<String, String>> combinedMessages = [];

  TextEditingController messageTextEditingController = TextEditingController();

  goToDirectMainChatFunc(selectedLang1, selectedLang2) {
    Get.to(() => DirectChatMainScreen(
        selectedLang1: selectedLang1, selectedLang2: selectedLang2));
  }

  String getSideValue() {
    if (!switchValue) {
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
      String? filePath = '$tempPath/${combinedMessages.length}.wav';
      String message = messageTextEditingController.text;

      if (isAudioMessage) {
        message = await getSpeechToTextResults(filePath, fromLanguage);
      }

      String translatedText = await translateText(message, toLanguage);
      Map<String, String> newMessageData = {
        "message_id": "${combinedMessages.length}",
        "message_original_language": fromLanguage,
        "message_original_text": message,
        "message_language_side": side,
        "message_original_audio_content": filePath ?? "",
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

  Future<String> getOrCreateTranslationAudioPath(String messageId) async {
    if (combinedMessages[int.parse(messageId)]
            ["message_translation_audio_content"] !=
        "") {
      return combinedMessages[int.parse(messageId)]
              ["message_translation_audio_content"]!
          .trim();
    } else {
      final tempPath = await _localPath;
      String filepath = await textToSpeechPath(
          combinedMessages[int.parse(messageId)]["message_translation_text"]!,
          "$tempPath/$messageId-translated",
          combinedMessages[int.parse(messageId)]
              ["message_translation_language"]!);
      combinedMessages[int.parse(messageId)]
          ["message_translation_audio_content"] = filepath.trim();
      return filepath.trim();
    }
  }

  addMessage() {
    if (messageTextEditingController.text != "") {
      String message = messageTextEditingController.text;
      debugPrint(message);
      Map<String, String> mapInstance = {
        "who": "b",
        "what": "${message}",
        "time":
            "${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}"
      };
      combinedMessages.add(mapInstance);
      debugPrint(mapInstance.toString());
      debugPrint(combinedMessages.toString());
    }
    messageTextEditingController.text = "";
  }
}
