import 'package:complete_advanced_flutter_app/app/app_prefs.dart';
import 'package:complete_advanced_flutter_app/presentation/onboarding/onboarding_viewmodel.dart';
import 'package:complete_advanced_flutter_app/presentation/resources/assets_manager.dart';
import 'package:complete_advanced_flutter_app/presentation/resources/routes_manager.dart';
import 'package:complete_advanced_flutter_app/presentation/resources/strings_manager.dart';
import 'package:complete_advanced_flutter_app/presentation/resources/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../../app/di.dart';
import '../../domain/model/model.dart';
import '../resources/color_manager.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {

  final PageController _pageController = PageController(initialPage: 0);
  final OnBoardingViewModel _viewModel = OnBoardingViewModel();
  final AppPreferences _appPreferences = instance<AppPreferences>();

  _bind(){
    _appPreferences.setOnBoardingScreenViewed();
    _viewModel.start();
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }


  Widget _getContentWidget(SliderViewObject? slideViewObject){
    if(slideViewObject == null){
      return Container();
    }
    else {
      return Scaffold(
        backgroundColor: ColorManager.white,
        appBar: AppBar(
          backgroundColor: ColorManager.white,
          elevation: AppSize.s0,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: ColorManager.white,
              statusBarBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.dark
          ),
        ),
        body: PageView.builder(
          controller: _pageController,
          itemCount: slideViewObject.numOfSlides,
          onPageChanged: (index) {
            _viewModel.onPageChanged(index);
          },
          itemBuilder: (context, index) {
            ///Return onBoarding Screen
            return OnBoardingPage(slideViewObject.sliderObject);
          },
        ),
        bottomSheet: Container(
          color: ColorManager.white,
          height: AppSize.s100,
          child: Column(
            children: [

              Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(onPressed: () {
                    Navigator.pushReplacementNamed(context, Routes.loginRoute);
                  },
                      child:  Text(
                        AppStrings.skip,
                        textAlign: TextAlign.end,
                        style: Theme.of(context).textTheme.titleSmall,
                      ).tr())),

              ///add layout for indicator and arrows
              _getBottomSheetWidget(slideViewObject),
            ],
          ),
        ),
      );
    }
  }

  Widget _getBottomSheetWidget(SliderViewObject slideViewObject) {
    return Container(
      color: ColorManager.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          ///Left Arrow
          Padding(padding: const EdgeInsets.all(AppPadding.p14),
            child: GestureDetector(
              child: SizedBox(
                height: AppSize.s20,
                width: AppSize.s20,
                child: SvgPicture.asset(ImageAssets.leftArrowIc),
              ),
              onTap: () {
                ///Go to the previous slide
                _pageController.animateToPage(_viewModel.goPrevious(), duration: const Duration(milliseconds: DurationConstant.d300), curve: Curves.bounceInOut);
              },
            ),
          ),

          ///Circle indicator
          Row(
            children: [
              for(int i = 0; i < slideViewObject.numOfSlides!.toInt(); i++)
                Padding(padding: const EdgeInsets.all(AppPadding.p8),
                  child: _getProperCircle(i,slideViewObject.currentIndex),)
            ],
          ),

          ///Right arrow
          Padding(padding: const EdgeInsets.all(AppPadding.p14),
            child: GestureDetector(
              child: SizedBox(
                height: AppSize.s20,
                width: AppSize.s20,
                child: SvgPicture.asset(ImageAssets.rightArrowIc),
              ),
              onTap: () {
                ///Go to the next slide
                _pageController.animateToPage(_viewModel.goNext(), duration: const Duration(milliseconds: DurationConstant.d300), curve: Curves.bounceInOut);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _getProperCircle(int index, int? currentIndex){
    if(index == currentIndex){
      return SvgPicture.asset(ImageAssets.hollowCircleIc); //selected slider
    }
    else{
      return SvgPicture.asset(ImageAssets.solidCircleIc); //unselected slider
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _viewModel.outputSliderViewObject,
        builder: (context, snapshot) =>_getContentWidget(snapshot.data),
    );
  }


}

class OnBoardingPage extends StatelessWidget {
    final SliderObject? _sliderObject;
    const OnBoardingPage(this._sliderObject,{super.key,});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
          const SizedBox(height: AppSize.s40,),
          Padding(
            padding: const EdgeInsets.all(AppPadding.p8),
            child: Text(_sliderObject!.title!,textAlign: TextAlign.center,style: Theme.of(context).textTheme.displayLarge,),
          ),
        Padding(
          padding: const EdgeInsets.all(AppPadding.p8),
          child: Text(_sliderObject!.subTitle!,textAlign: TextAlign.center,style: Theme.of(context).textTheme.titleMedium,),
        ),
        const SizedBox(height: AppSize.s60,),

        ///Image Widgets
        SvgPicture.asset(_sliderObject!.image!)
      ],
    );
  }
}



