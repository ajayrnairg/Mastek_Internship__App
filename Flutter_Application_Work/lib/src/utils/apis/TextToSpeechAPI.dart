import 'dart:io';
import 'dart:async';
import 'dart:convert' show json, utf8;

import '../helperfunctions/voice.dart';



class TextToSpeechAPI {

  static final TextToSpeechAPI _singleton = TextToSpeechAPI._internal();
  final _httpClient = HttpClient();
  static const _apiKey = "AIzaSyDXuxjXgEDIgmtBdPsUfN-kdHG7mRxKvSk";
  static const _apiURL = "texttospeech.googleapis.com";


  factory TextToSpeechAPI() {
    return _singleton;
  }

  TextToSpeechAPI._internal();

  Future<dynamic> synthesizeText(String text, String name, String languageCode) async {
    try {
      final uri = Uri.https(_apiURL, '/v1beta1/text:synthesize');
      final Map json = {
        'input': {
          'text': text
        },
        'voice': {
          'name': name,
          'languageCode': languageCode
        },
        'audioConfig': {
          'audioEncoding': 'LINEAR16'
        }
      };

      final jsonResponse = await _postJson(uri, json);
      if (jsonResponse == null) return null;
      final String audioContent = await jsonResponse['audioContent'];
      return audioContent;
    } on Exception catch(e) {
      print("$e");
      return null;
    }
  }

  Future<List<Voice?>?> getVoices() async {
    try {
      final uri = Uri.https(_apiURL, '/v1beta1/voices');

      final jsonResponse = await _getJson(uri);

      final List<dynamic> voicesJSON = jsonResponse?['voices'].toList() ?? [];

      final voices = Voice.mapJSONStringToList(voicesJSON);

      // for(var i=0;i< voices!.length; i++){
      //   print("Name: ${voices[i]?.name}, Gender:${voices[i]?.gender}, LanguageCode:${voices[i]?.languageCodes}");
      // }
      // print(voices);
      return voices;
    } on Exception catch(e) {
      print("$e");
    }

  }

  Future<Map<String?, dynamic>?> _postJson(Uri uri, Map jsonMap) async {
    try {
      final httpRequest = await _httpClient.postUrl(uri);
      final jsonData = utf8.encode(json.encode(jsonMap));
      final jsonResponse = await _processRequestIntoJsonResponse(httpRequest, jsonData);
      return jsonResponse;
    } on Exception catch(e) {
      print("$e");
    }
  }

  Future<Map<String?, dynamic>?> _getJson(Uri uri) async {
    try {
      final httpRequest = await _httpClient.getUrl(uri);
      List<int> al = const [];
      final jsonResponse = await _processRequestIntoJsonResponse(httpRequest, al);
      return jsonResponse;
    } on Exception catch(e) {
      print("$e");
    }
  }

  Future<Map<String, dynamic>> _processRequestIntoJsonResponse(HttpClientRequest httpRequest, List<int> data) async {
    try {
      httpRequest.headers.add('X-Goog-Api-Key', _apiKey);
      httpRequest.headers.add(HttpHeaders.contentTypeHeader, 'application/json');
      if (data != null) {
        httpRequest.add(data);
      }
      final httpResponse = await httpRequest.close();
      if (httpResponse.statusCode != HttpStatus.OK) {
        throw Exception('Bad Response');
      }
      final responseBody = await httpResponse.transform(utf8.decoder).join();
      return json.decode(responseBody);
    } on Exception catch(e) {
      print("$e");
      return json.decode("Error");
    }
  }

}
