
String getUpperCaseLetter(String letter){

  if(letter.isEmpty){
    return "";
  }
  else{

    if(letter == 'i'){
      return 'İ';
    }
    else if(letter == 'ı'){
      return 'I';
    }
    else{
      return letter.toUpperCase();
    }
  }
}

String getUpperCaseText(String text){

  String upperText = "";

  for (int i = 0; i < text.length; i++) {
    upperText = "$upperText${getUpperCaseLetter(text[i])}";
  }

  return upperText;
}