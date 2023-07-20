import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_speech/config/recognition_config.dart';
import 'package:google_speech/config/recognition_config_v1.dart';
import 'package:google_speech/speech_client_authenticator.dart';
import 'package:google_speech/speech_to_text.dart';
import 'package:wav/wav.dart';

import 'dart:io';

class STT {


  Future<Wav> getWavData(String filePath) async {
    final wav = await Wav.readFile(filePath);
    // Look at its metadata.
    // print(wav.format);
    // print(wav.samplesPerSecond);
    return wav;
  }


  Future<String> transcribe(String filePath, String languageCode) async {
    String content = '';
    final serviceAccount = ServiceAccount.fromString(
        '${(await rootBundle.loadString('assets/api/googlecloudkey.json'))}');
    final speechToText = SpeechToText.viaServiceAccount(serviceAccount);
    final wav = await getWavData(filePath);

    final config = RecognitionConfig(
        encoding: AudioEncoding.LINEAR16,
        model: RecognitionModel.basic,
        enableAutomaticPunctuation: true,
        audioChannelCount: wav.channels.length,
        sampleRateHertz: wav.samplesPerSecond,
        languageCode: languageCode);

    final audio = await _getAudioContent(filePath);
    await speechToText.recognize(config, audio).then((value) {
      content =
          value.results.map((e) => e.alternatives.first.transcript).join('\n');
    });

    return content;
  }

  Future<List<int>> _getAudioContent(String filePath) async {
    //final directory = await getApplicationDocumentsDirectory();
    //final path = directory.path + '/$name';
    // final path = '/sdcard/Download/$name';
    return File(filePath).readAsBytesSync().toList();
  }


}


