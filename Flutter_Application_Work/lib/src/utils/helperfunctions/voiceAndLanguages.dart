class VoiceAndLanguages {
  static final languageAndGender = [
    ['English', 'Male'],
    ['English', 'Female'],
    ['Hindi', 'Male'],
    ['Hindi', 'Female'],
    ['Kannada', 'Male'],
    ['Kannada', 'Female'],
    ['Malayalam', 'Male'],
    ['Malayalam', 'Female'],
    ['Marathi', 'Male'],
    ['Marathi', 'Female'],
    ['Tamil', 'Male'],
    ['Tamil', 'Female'],
    ['Telugu', 'Male'],
    ['Telugu', 'Female'],
  ];

  static List<String> getVoiceAndLanguageCode(String language, String gender) {
    switch (language) {
      case 'English':
        if (gender == "MALE") {
          return ["en-US-Standard-A", "en-US"];
        } else {
          return ["en-US-Standard-C", "en-US"];
        }
      case 'Hindi':
        if (gender == "MALE") {
          return ["hi-IN-Standard-B", "hi-IN"];
        } else {
          return ["hi-IN-Standard-D", "hi-IN"];
        }
      case 'Kannada':
        if (gender == "MALE") {
          return ["kn-IN-Standard-B", "kn-IN"];
        } else {
          return ["kn-IN-Standard-A", "kn-IN"];
        }
      case 'Malayalam':
        if (gender == "MALE") {
          return ["ml-IN-Standard-B", "ml-IN"];
        } else {
          return ["ml-IN-Standard-A", "ml-IN"];
        }
      case 'Marathi':
        if (gender == "MALE") {
          return ["mr-IN-Standard-B", "mr-IN"];
        } else {
          return ["mr-IN-Standard-A", "mr-IN"];
        }
      case 'Tamil':
        if (gender == "MALE") {
          return ["ta-IN-Standard-B", "ta-IN"];
        } else {
          return ["ta-IN-Standard-A", "ta-IN"];
        }
      case 'Telugu':
        if (gender == "MALE") {
          return ["te-IN-Standard-B", "te-IN"];
        } else {
          return ["te-IN-Standard-A", "te-IN"];
        }

      default:
        if (gender == "MALE") {
          return ["en-US-Standard-A", "en-US"];
        } else {
          return ["en-US-Standard-C", "en-US"];
        }
       
    }
  }
}
