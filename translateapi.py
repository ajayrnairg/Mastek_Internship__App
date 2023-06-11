import os 
from google.cloud import translate_v2 as translate

os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = r"googlecloudkey.json"

lan_ar = ['hi', 'kn', 'ml', 'ta', 'te', 'en']


def textcount(text):
    n = len(text)
    file = open('charactercount.txt','r')
    count = int(file.read())
    count += n 
    print(count)
    file.close()
    file = open('charactercount.txt','w')
    file.write(str(count))
    file.close()

def translate_text(target: str, text: str) -> dict:
    """Translates text into the target language.

    Target must be an ISO 639-1 language code.
    See https://g.co/cloud/translate/v2/translate-reference#supported_languages
    """
    try:
        translate_client = translate.Client()

        if isinstance(text, bytes):
            text = text.decode("utf-8")

        # Text can also be a sequence of strings, in which case this method
        # will return a sequence of results for each text.
        result = translate_client.translate(text, target_language=target)

        print("Text: {}".format(result["input"]))
        print("Translation: {}".format(result["translatedText"]))
        print("Detected source language: {}".format(result["detectedSourceLanguage"]))
        textcount(text)

        return (1,result) 
    except Exception as e:
        return (0,e)

if __name__=="__main__":
    pass










