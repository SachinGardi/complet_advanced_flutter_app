
import '../resources/font_manager.dart';
import 'package:flutter/material.dart';

TextStyle _getTextStyle(double fontSize, String fontFamily, FontWeight fontWeight ,Color color){
  return TextStyle(fontSize: fontSize,fontFamily: fontFamily,color: color,fontWeight: fontWeight);
}

///Regular Style
TextStyle getRegularStyle({double fontSize = FontSize.s12,required Color color}){
return _getTextStyle(fontSize,FontConstants.fontFamily,FontWeightManager.regular,color);
}

///Light Style
TextStyle getLightStyle({double fontSize = FontSize.s12,required Color color}){
  return _getTextStyle(fontSize,FontConstants.fontFamily,FontWeightManager.light,color);
}

///Bold Style
TextStyle getBoldStyle({double fontSize = FontSize.s12,required Color color}){
  return _getTextStyle(fontSize,FontConstants.fontFamily,FontWeightManager.bold,color);
}

///Semi Bold Style
TextStyle getSemiBoldStyle({double fontSize = FontSize.s12,required Color color}){
  return _getTextStyle(fontSize,FontConstants.fontFamily,FontWeightManager.semiBold,color);
}

///Medium Style
TextStyle getMediumStyle({double fontSize = FontSize.s12,required Color color}){
  return _getTextStyle(fontSize,FontConstants.fontFamily,FontWeightManager.medium,color);
}