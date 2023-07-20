class Languages {
  static final languages = <String>[
    'Akan',
    'Albanian',
    'Amharic',
    'Arabic',
    'Armenian',
    'Assamese',
    'Aymara',
    'Azerbaijani',
    'Bambara',
    'Basque',
    'Belarusian',
    'Bengali',
    'Bhojpuri',
    'Bosnian',
    'Bulgarian',
    'Catalan',
    'Cebuano',
    'Chichewa',
    'Chinese (Traditional)',
    'Corsican',
    'Croatian',
    'Czech',
    'Danish',
    'Divehi',
    'Dogri',
    'Dutch',
    'English',
    'Esperanto',
    'Estonian',
    'Ewe',
    'Filipino',
    'Finnish',
    'French',
    'Frisian',
    'Galician',
    'Ganda',
    'Georgian',
    'German',
    'Goan Konkani',
    'Greek',
    'Guarani',
    'Gujarati',
    'Haitian Creole',
    'Hausa',
    'Hawaiian',
    'Hindi',
    'Hmong',
    'Hungarian',
    'Icelandic',
    'Igbo',
    'Iloko',
    'Indonesian',
    'Irish',
    'Italian',
    'Japanese',
    'Kannada',
    'Kazakh',
    'Khmer',
    'Kinyarwanda',
    'Korean',
    'Krio',
    'Kurdish (Kurmanji)',
    'Kurdish (Sorani)',
    'Kyrgyz',
    'Lao',
    'Latin',
    'Latvian',
    'Lingala',
    'Lithuanian',
    'Luxembourgish',
    'Macedonian',
    'Maithili',
    'Malagasy',
    'Malay',
    'Malayalam',
    'Maltese',
    'Manipuri (Meitei Mayek)',
    'Maori',
    'Marathi',
    'Mizo',
    'Mongolian',
    'Myanmar (Burmese)',
    'Nepali',
    'Northern Sotho',
    'Norwegian',
    'Odia',
    'Oromo',
    'Pashto',
    'Persian',
    'Polish',
    'Portuguese',
    'Punjabi',
    'Quechua',
    'Romanian',
    'Russian',
    'Samoan',
    'Sanskrit',
    'Scots Gaelic',
    'Serbian',
    'Sesotho',
    'Shona',
    'Sindhi',
    'Sinhala',
    'Slovak',
    'Slovenian',
    'Somali',
    'Spanish',
    'Sundanese',
    'Swahili',
    'Swedish',
    'Tajik',
    'Tamil',
    'Tatar',
    'Telugu',
    'Thai',
    'Tigrinya',
    'Tsonga',
    'Turkish',
    'Turkmen',
    'Ukrainian',
    'Urdu',
    'Uyghur',
    'Uzbek',
    'Vietnamese',
    'Welsh',
    'Xhosa',
    'Yiddish',
    'Yoruba',
    'Zulu',
    'Hebrew',
    'Javanese',
    'Chinese (Simplified)',
  ];

  static String getLanguageCode(String language) {
    switch (language) {
      case 'Afrikaans':
        return 'af';
      case 'Akan':
        return 'ak';
      case 'Albanian':
        return 'sq';
      case 'Amharic':
        return 'am';
      case 'Arabic':
        return 'ar';
      case 'Armenian':
        return 'hy';
      case 'Assamese':
        return 'as';
      case 'Aymara':
        return 'ay';
      case 'Azerbaijani':
        return 'az';
      case 'Bambara':
        return 'bm';
      case 'Basque':
        return 'eu';
      case 'Belarusian':
        return 'be';
      case 'Bengali':
        return 'bn';
      case 'Bhojpuri':
        return 'bho';
      case 'Bosnian':
        return 'bs';
      case 'Bulgarian':
        return 'bg';
      case 'Catalan':
        return 'ca';
      case 'Cebuano':
        return 'ceb';
      case 'Chichewa':
        return 'ny';
      case 'Chinese (Traditional)':
        return 'zh-TW';
      case 'Corsican':
        return 'co';
      case 'Croatian':
        return 'hr';
      case 'Czech':
        return 'cs';
      case 'Danish':
        return 'da';
      case 'Divehi':
        return 'dv';
      case 'Dogri':
        return 'doi';
      case 'Dutch':
        return 'nl';
      case 'English':
        return 'en';
      case 'Esperanto':
        return 'eo';
      case 'Estonian':
        return 'et';
      case 'Ewe':
        return 'ee';
      case 'Filipino':
        return 'tl';
      case 'Finnish':
        return 'fi';
      case 'French':
        return 'fr';
      case 'Frisian':
        return 'fy';
      case 'Galician':
        return 'gl';
      case 'Ganda':
        return 'lg';
      case 'Georgian':
        return 'ka';
      case 'German':
        return 'de';
      case 'Goan Konkani':
        return 'gom';
      case 'Greek':
        return 'el';
      case 'Guarani':
        return 'gn';
      case 'Gujarati':
        return 'gu';
      case 'Haitian Creole':
        return 'ht';
      case 'Hausa':
        return 'ha';
      case 'Hawaiian':
        return 'haw';
      case 'Hindi':
        return 'hi';
      case 'Hmong':
        return 'hmn';
      case 'Hungarian':
        return 'hu';
      case 'Icelandic':
        return 'is';
      case 'Igbo':
        return 'ig';
      case 'Iloko':
        return 'ilo';
      case 'Indonesian':
        return 'id';
      case 'Irish':
        return 'ga';
      case 'Italian':
        return 'it';
      case 'Japanese':
        return 'ja';
      case 'Kannada':
        return 'kn';
      case 'Kazakh':
        return 'kk';
      case 'Khmer':
        return 'km';
      case 'Kinyarwanda':
        return 'rw';
      case 'Korean':
        return 'ko';
      case 'Krio':
        return 'kri';
      case 'Kurdish (Kurmanji)':
        return 'ku';
      case 'Kurdish (Sorani)':
        return 'ckb';
      case 'Kyrgyz':
        return 'ky';
      case 'Lao':
        return 'lo';
      case 'Latin':
        return 'la';
      case 'Latvian':
        return 'lv';
      case 'Lingala':
        return 'ln';
      case 'Lithuanian':
        return 'lt';
      case 'Luxembourgish':
        return 'lb';
      case 'Macedonian':
        return 'mk';
      case 'Maithili':
        return 'mai';
      case 'Malagasy':
        return 'mg';
      case 'Malay':
        return 'ms';
      case 'Malayalam':
        return 'ml';
      case 'Maltese':
        return 'mt';
      case 'Manipuri (Meitei Mayek)':
        return 'mni-Mtei';
      case 'Maori':
        return 'mi';
      case 'Marathi':
        return 'mr';
      case 'Mizo':
        return 'lus';
      case 'Mongolian':
        return 'mn';
      case 'Myanmar (Burmese)':
        return 'my';
      case 'Nepali':
        return 'ne';
      case 'Northern Sotho':
        return 'nso';
      case 'Norwegian':
        return 'no';
      case 'Odia':
        return 'Oriya';
      case 'Oromo':
        return 'om';
      case 'Pashto':
        return 'ps';
      case 'Persian':
        return 'fa';
      case 'Polish':
        return 'pl';
      case 'Portuguese':
        return 'pt';
      case 'Punjabi':
        return 'pa';
      case 'Quechua':
        return 'qu';
      case 'Romanian':
        return 'ro';
      case 'Russian':
        return 'ru';
      case 'Samoan':
        return 'sm';
      case 'Sanskrit':
        return 'sa';
      case 'Scots Gaelic':
        return 'gd';
      case 'Serbian':
        return 'sr';
      case 'Sesotho':
        return 'st';
      case 'Shona':
        return 'sn';
      case 'Sindhi':
        return 'sd';
      case 'Sinhala':
        return 'si';
      case 'Slovak':
        return 'sk';
      case 'Slovenian':
        return 'sl';
      case 'Somali':
        return 'so';
      case 'Spanish':
        return 'es';
      case 'Sundanese':
        return 'su';
      case 'Swahili':
        return 'sw';
      case 'Swedish':
        return 'sv';
      case 'Tajik':
        return 'tg';
      case 'Tamil':
        return 'ta';
      case 'Tatar':
        return 'tt';
      case 'Telugu':
        return 'te';
      case 'Thai':
        return 'th';
      case 'Tigrinya':
        return 'ti';
      case 'Tsonga':
        return 'ts';
      case 'Turkish':
        return 'tr';
      case 'Turkmen':
        return 'tk';
      case 'Ukrainian':
        return 'uk';
      case 'Urdu':
        return 'ur';
      case 'Uyghur':
        return 'ug';
      case 'Uzbek':
        return 'uz';
      case 'Vietnamese':
        return 'vi';
      case 'Welsh':
        return 'cy';
      case 'Xhosa':
        return 'xh';
      case 'Yiddish':
        return 'yi';
      case 'Yoruba':
        return 'yo';
      case 'Zulu':
        return 'zu';
      case 'Hebrew':
        return 'he';
      case 'Javanese':
        return 'jv';
      case 'Chinese (Simplified)':
        return 'zh-CN';

      default:
        return 'en';
    }
  }
}
