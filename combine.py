from speechtotext import recordaudio, callspeech, lan
from translateapi import textcount ,translate_text 
from texttospeech import text_to_wav, male_voice, female_voice

if __name__=="__main__":
    print("Speech To Text starts!!!")
    for i in range(len(lan)):
        print(f"{i+1}: {lan[i]}")
    src_lang=int(input("Please enter the src language code's number in which you will be speaking: "))-1
    recordaudio()
    src_text_data=callspeech(lan[src_lang])
    print("Translation starts!!!")
    for i in range(len(lan)):
        print(f"{i+1}: {lan[i]}")
    dest_lang=int(input("Please enter the destination language code's number in which you want the text to be translated to: "))-1
    translated_txt=translate_text(lan[dest_lang], src_text_data[1].transcript)
    print("Text to Speech starts!!!")
    if (translated_txt[0]==1):
        gender=input("Enter B for male voice and A for female voice: ")
        final_result=text_to_wav(voice_name=f'{lan[dest_lang]}-IN-Standard-{gender}', text=translated_txt[1]["translatedText"])
        if final_result[0]==1:
            print(final_result[1])
        else:
            print(f"Exiting TTS because: {final_result[1]}")
    else:
        print(translated_txt[1])
        print("Exiting Translation")
        exit()
    





