from django.shortcuts import render, redirect
from django.views.generic import View
from django.http import FileResponse
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.decorators import api_view, renderer_classes
from googleapi import speechtotext
from googleapi import translateapi
from googleapi import texttospeech

# from speechtotext import recordaudio, speech_to_text, lan
# from translateapi import textcount ,translate_text 
# from texttospeech import text_to_wav, male_voice, female_voice
from google.cloud import speech
import json
import os
os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = r"./googlecloudkey.json"

# Create your views here.

@api_view(('POST','GET',))
def stttrans(request):
    if request.method == 'POST':
        print("Speech To Text starts!!!")
        stt = json.loads(request.body) 
        flac_data = stt['flac_data'] # provide flac data in the correct format as input
        source_lan = stt['source_lan']
        dest_lan = stt['dest_lan']

        config = speech.RecognitionConfig(
            language_code=source_lan,
            enable_automatic_punctuation=True
        )
        audio = speech.RecognitionAudio(
            content=flac_data,
        )

        ans = speechtotext.speech_to_text(config, audio)
        if(ans[0] == 1):
            translated_txt=translateapi.translate_text(dest_lan, ans[1]['transcript'])
            if (translated_txt[0]==1):
                return Response(translated_txt[1])
            else:
                return Response(f"Error encountered in translation: {translated_txt[1]}")
        else:
            return Response(f"Error encountered {ans[1]}")
        
@api_view(('POST','GET',))
def tts(request):
    if request.method == 'POST':
        ttspeech = json.loads(request.body)
        text = ttspeech['text']
        dest_lan = ttspeech['dest_lan']
        gender = ttspeech['gender'] # give gender also in input for voice
        final_result=texttospeech.text_to_wav(voice_name=f'{dest_lan}-IN-Standard-{gender}', text=text)
        if final_result[0]==1:
            return Response(final_result[1]) # catch response correctly as it is a wav file
        else:
            return Response(f"Error encountered in tts: {final_result[1]}")
        

@api_view(('POST','GET',))
def texttrans(request):
    if request.method == 'POST':
        
        text_trans = json.loads(request.body)
        text = text_trans['text']
        dest_lan = text_trans['dest_lan']

        translated_txt=translateapi.translate_text(dest_lan, text)
        if (translated_txt[0]==1):
            return Response(translated_txt[1])
        else:
            return Response(f"Error encountered in translation: {translated_txt[1]}")