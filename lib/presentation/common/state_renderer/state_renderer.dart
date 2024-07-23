import 'package:complete_advanced_flutter_app/data/network/failure.dart';
import 'package:complete_advanced_flutter_app/presentation/resources/assets_manager.dart';
import 'package:complete_advanced_flutter_app/presentation/resources/color_manager.dart';
import 'package:complete_advanced_flutter_app/presentation/resources/font_manager.dart';
import 'package:complete_advanced_flutter_app/presentation/resources/strings_manager.dart';
import 'package:complete_advanced_flutter_app/presentation/resources/styles_manager.dart';
import 'package:complete_advanced_flutter_app/presentation/resources/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../data/mapper/mapper.dart';

enum StateRendererType{

  ///Popup states
  POPUP_LOADING_STATE,
  POPUP_ERROR_STATE,
  POPUP_SUCCESS,

  ///Full Screen States
  FULL_SCREEN_LOADING_STATE,
  CONTENT_SCREEN_STATE, // THE UI OF THE SCREEN
  EMPTY_SCREEN_STATE, //EMPTY VIEW WHEN WE RECEIVE NO DATA FROM API SIDE FOR LIST SCREEN
  FULL_SCREEN_ERROR_STATE,

}

class StateRenderer extends StatelessWidget {

  StateRendererType stateRendererType;
  String message;
  String title;
  Function? retryActionFunction;


   StateRenderer({super.key,required this.stateRendererType,
     String? message,
     String? title,
     required this. retryActionFunction
   }):message = message??AppStrings.loading.tr(), title = title??EMPTY;



  @override
  Widget build(BuildContext context) {
    return _getStateWidget(context);
  }

  Widget _getStateWidget(BuildContext context){
    switch(stateRendererType){

      case StateRendererType.POPUP_LOADING_STATE:
        return _getPopUpDialog(context,[_getAnimatedImage(JsonAssets.loading)]);

      case StateRendererType.POPUP_ERROR_STATE:
        return _getPopUpDialog(context,[
          _getAnimatedImage(JsonAssets.error),_getMessage(message),_getRetryButton(AppStrings.ok.tr(),context)
        ]);

      case StateRendererType.POPUP_SUCCESS:
        return _getPopUpDialog(context, [
          _getAnimatedImage(JsonAssets.success),
          _getMessage(title),
          _getMessage(message),
          _getRetryButton(AppStrings.ok.tr(), context)
        ]);

      case StateRendererType.FULL_SCREEN_LOADING_STATE:
      return _getItemInColumn([_getAnimatedImage(JsonAssets.loading),_getMessage(message)]);

      case StateRendererType.FULL_SCREEN_ERROR_STATE:
        return _getItemInColumn([_getAnimatedImage(JsonAssets.error),_getMessage(message),_getRetryButton(AppStrings.retryAgain.tr(),context)]);

      case StateRendererType.CONTENT_SCREEN_STATE:
        return Container();

      case StateRendererType.EMPTY_SCREEN_STATE:
      return _getItemInColumn([_getAnimatedImage(JsonAssets.empty),_getMessage(message)]);

      default:
        return Container();
    }
  }

  Widget _getPopUpDialog(BuildContext context,List<Widget>children){
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.s14)
      ),
      elevation: AppSize.s1_5,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: ColorManager.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(AppSize.s14),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: AppSize.s12,
              offset: Offset(AppSize.s0, AppSize.s12)
            )
          ]
        ),
        child: _getDialogContent(context,children),
      ),
    );
  }

  Widget _getDialogContent(BuildContext context,List<Widget>children){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: children
    );
  }

  Widget _getAnimatedImage(String animationName){
    return  SizedBox(
      height: AppSize.s100,
      width: AppSize.s100,
      child: Lottie.asset(animationName),//json image
    );
  }
  
  Widget _getMessage(String message){
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p18),
        child: Text(message,style: getMediumStyle(color: ColorManager.black,fontSize: FontSize.s16),),
      ),
    );
  }


  Widget _getRetryButton(String buttonTitle,BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p18),
        child: SizedBox(
          width: AppSize.s180,
          child: ElevatedButton(onPressed: () {
            if(stateRendererType == StateRendererType.FULL_SCREEN_ERROR_STATE){
            retryActionFunction?.call(); // t call the api function again to retry
            }else{
              Navigator.of(context).pop(); //popup state error so we need to dismiss the dailog
            }
          }, child: Text(buttonTitle),),
        ),
      ),
    );
  }

  Widget  _getItemInColumn(List<Widget> children){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children
      ),
    );
  }
}
