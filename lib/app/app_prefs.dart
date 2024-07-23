import 'package:complete_advanced_flutter_app/presentation/resources/language_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String PREFS_KEY_LANG = "PREFS_KEY_LANG";
const String PREFS_KEY_ONBOARDING_SCREEN = "PREFS_KEY_ONBOARDING_SCREEN";
const String PREFS_KEY_IS_USER_LOGGED_IN = "PREFS_KEY_IS_USER_LOGGED_IN";
const String PREFS_KEY_TOKEN= "PREFS_KEY_TOKEN";

class AppPreferences{
final SharedPreferences _sharedPreferences;
AppPreferences(this._sharedPreferences);

Future<String> getAppLanguage()async{
  String? language = _sharedPreferences.getString(PREFS_KEY_LANG);
  if(language != null && language.isNotEmpty){
    return language;
  }
  else{
    return LanguageType.ENGLISH.getValue();
  }
}

Future<void> setLanguageChanged()async{
  String currentLanguage = await getAppLanguage();
  if(currentLanguage == LanguageType.MARATHI.getValue()){
    ///save prefs with english lang
    _sharedPreferences.setString(PREFS_KEY_LANG, LanguageType.ENGLISH.getValue());
  }
  else{
    ///Save prefs with marathi lang
    _sharedPreferences.setString(PREFS_KEY_LANG, LanguageType.MARATHI.getValue());
  }
}

Future<Locale> getLocal()async{
  String currentLanguage = await getAppLanguage();
  if(currentLanguage == LanguageType.MARATHI.getValue()){
    ///return marathi local
    return ENGLISH_LOCAL;
  }
  else{
    ///return english local
    return MARATHI_LOCAL;
  }
}

Future<void> setOnBoardingScreenViewed()async{
  _sharedPreferences.setBool(PREFS_KEY_ONBOARDING_SCREEN, true);
}

Future<bool> isOnBoardingScreenViewed()async{
  return _sharedPreferences.getBool(PREFS_KEY_ONBOARDING_SCREEN)??false;
}

Future<void> setToken(String token)async{
  _sharedPreferences.setString(PREFS_KEY_TOKEN, token);
}

Future<String> getToken()async{
  return _sharedPreferences.getString(PREFS_KEY_TOKEN)??"NO TOKEN SAVED";
}

Future<void> setIsUserLoggedIn()async{
  _sharedPreferences.setBool(PREFS_KEY_IS_USER_LOGGED_IN, true);
}

Future<bool> isUserLoggedIn()async{
  return _sharedPreferences.getBool(PREFS_KEY_IS_USER_LOGGED_IN)??false;
}

Future<void> logout()async{
   _sharedPreferences.remove(PREFS_KEY_IS_USER_LOGGED_IN);
}

}