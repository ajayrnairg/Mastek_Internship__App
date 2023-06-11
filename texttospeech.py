
import google.cloud.texttospeech as tts
import os

os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = r"googlecloudkey.json"

male_voice = ['en-IN-Standard-B', 'hi-IN-Standard-B', 'te-IN-Standard-B', 'kn-IN-Standard-B', 'ta-IN-Standard-B', 'ml-IN-Standard-B']
female_voice = ['en-IN-Standard-A', 'hi-IN-Standard-A', 'te-IN-Standard-A', 'kn-IN-Standard-A', 'ta-IN-Standard-A', 'ml-IN-Standard-A']

def textcount(text):
    n = len(text)
    file = open('tts_charactercount.txt','r')
    count = int(file.read())
    count += n 
    print(count)
    file.close()
    file = open('tts_charactercount.txt','w')
    file.write(str(count))
    file.close()

def text_to_wav(voice_name: str, text: str):
    language_code = "-".join(voice_name.split("-")[:2])
    try:
        text_input = tts.SynthesisInput(text=text)
        voice_params = tts.VoiceSelectionParams(
            language_code=language_code, name=voice_name
        )
        audio_config = tts.AudioConfig(audio_encoding=tts.AudioEncoding.LINEAR16)

        client = tts.TextToSpeechClient()
        response = client.synthesize_speech(
            input=text_input,
            voice=voice_params,
            audio_config=audio_config,
        )

        with open("texttospeech.wav", "wb") as out:
            out.write(response.audio_content)
            textcount(text)
        return(1,"Successfully generated speech saved to texttospeech.wav")
    except Exception as e:
        return (0,e)

if __name__=="__main__":
    pass