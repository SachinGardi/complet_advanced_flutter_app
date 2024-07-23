
import 'package:flutter/material.dart';

enum LanguageType{
 ENGLISH,
 MARATHI
}

const String ENGLISH = "en";
const String MARATHI = "mr";
const String ASSET_PATH_LOCALISATIONS = 'assets/translation';
const Locale ENGLISH_LOCAL = Locale('en','US');
const Locale MARATHI_LOCAL = Locale('mr','IN');

extension LanguageTypeExtension on LanguageType{
  String getValue(){
    switch(this){
      case LanguageType.ENGLISH:
        return ENGLISH;
      case LanguageType.MARATHI:
        return MARATHI;
    }
  }
}