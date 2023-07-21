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

class TranslateScreenController extends GetxController{

  List<String> combinedMessagesTrans = [];
  String textgenratedstt = "";

  Future<String> getSpeechToTextResults(
      String audioPath, String language) async {
    return await STT()
        .transcribe(audioPath, Languages.getLanguageCode(language));
  }
}