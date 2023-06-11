import speech_recognition as sr
from google.cloud import speech

r=sr.Recognizer()

lan = ['en', 'hi', 'kn', 'ml', 'ta', 'te']


def recordaudio():
    with sr.Microphone() as source:
        r.adjust_for_ambient_noise(source,duration=3)
        print("say anything : ")
        global aud
        aud= r.listen(source, 5, 50)

    with open("microphone-results.flac", "wb") as f:
        f.write(aud.get_flac_data())



def billcount(num):
    file = open('totalbilledtime.txt','r')
    count = int(file.read())
    count += num 
    print(count)
    file.close()
    file = open('totalbilledtime.txt','w')
    file.write(str(count))
    file.close()


def speech_to_text(
    config: speech.RecognitionConfig,
    audio: speech.RecognitionAudio,
) -> speech.RecognizeResponse:
    try:
        client = speech.SpeechClient.from_service_account_file('googlecloudkey.json')

        # Synchronous speech recognition request
        response = client.recognize(config=config, audio=audio)
        return (1, print_response(response))
    except Exception as e:
        return (0, e)



def print_response(response: speech.RecognizeResponse):
    billcount(response.total_billed_time.seconds)
    print(response)
    print()
    print()
    # print(type(response.results))
    return print_result(response.results[0])


def print_result(result: speech.SpeechRecognitionResult):
    best_alternative = result.alternatives[0]
    print("-" * 80)
    print(f"language_code: {result.language_code}")
    print(f"transcript:    {best_alternative.transcript}")
    print(f"confidence:    {best_alternative.confidence:.0%}")
    data = {"language_code": result.language_code, "transcript": best_alternative.transcript}
    return data

def callspeech(lang_code):
    with open('microphone-results.flac', 'rb') as f:
        flac_data = f.read()

    config = speech.RecognitionConfig(
        language_code=lang_code,
        enable_automatic_punctuation=True
    )
    audio = speech.RecognitionAudio(
        content=flac_data,
    )

    ans = speech_to_text(config, audio)
    if(ans[0] == 1):
        return ans 
    else:
        print(ans[1])
        print("Exiting STT")
        exit()
        

if __name__=="__main__":
    pass
