import 'dart:async';

import 'package:complete_advanced_flutter_app/domain/model/model.dart';
import 'package:complete_advanced_flutter_app/presentation/base/baseviewmodel.dart';
import 'package:easy_localization/easy_localization.dart';

import '../resources/assets_manager.dart';
import '../resources/strings_manager.dart';
class OnBoardingViewModel extends BaseViewModel implements OnBoardingViewModelInputs,OnBoardingViewModelOutputs{

  ///Stream controller(used to send result or data from view model to view)
  final StreamController<SliderViewObject> _streamController = StreamController<SliderViewObject>();


  late final List<SliderObject> _list;
  int _currentIndex = 0;
  ///Inputs
  @override
  void dispose() {
    _streamController.close();
  }


  @override
  void start() {
    _list = _getSliderData();

    ///send this slider data to our view
    _postDataToView();
  }

  @override
  int goNext() {
    // TODO: implement goNext
    int nextIndex = _currentIndex++; // -1
    if(nextIndex >= _list.length ){
      _currentIndex = 0; //infinite loop to go to the first item inside slider
    }
    return _currentIndex;
  }

  @override
  int goPrevious() {
    int previousIndex = _currentIndex--; // -1
    if(previousIndex == -1){
      _currentIndex = _list.length -1; //infinite loop to go to the slider list
    }
    return _currentIndex;
  }

  @override
  void onPageChanged(int index) {
    _currentIndex = index;
    _postDataToView();
  }

  ///input
  @override
  Sink get inputSliderViewObject => _streamController.sink;

  ///output
  @override
  Stream<SliderViewObject> get outputSliderViewObject => _streamController.stream.map((slideViewObject) => slideViewObject);

  ///private function
  List<SliderObject> _getSliderData() => [
      SliderObject(AppStrings.onBoardingTitle1.tr(), AppStrings.onBoardingSubtitle1.tr(),
          ImageAssets.onBoardingLogo1),
      SliderObject(AppStrings.onBoardingTitle2.tr(), AppStrings.onBoardingSubtitle2.tr(),
          ImageAssets.onBoardingLogo2),
      SliderObject(AppStrings.onBoardingTitle3.tr(), AppStrings.onBoardingSubtitle3.tr(),
          ImageAssets.onBoardingLogo3),
      SliderObject(AppStrings.onBoardingTitle4.tr(), AppStrings.onBoardingSubtitle4.tr(),
          ImageAssets.onBoardingLogo4),
    ];

    _postDataToView(){
      inputSliderViewObject.add(SliderViewObject(_list[_currentIndex], _list.length, _currentIndex));
    }


}
/// input mean the order that our view model will receive from view
abstract class OnBoardingViewModelInputs{
  void goNext();///When user click on right arrow or swipe left
  void goPrevious();///When user click on left arrow or swipe right
  void onPageChanged(int index);

  Sink get inputSliderViewObject; /// This is the way to add data to the stream .. stream input
}

///output mean data or result that will be sent from view model to our view
abstract class OnBoardingViewModelOutputs{
  Stream<SliderViewObject> get outputSliderViewObject;
}


class SliderViewObject{
  SliderObject? sliderObject;
  int? numOfSlides;
  int? currentIndex;
  SliderViewObject(this.sliderObject,this.numOfSlides,this.currentIndex);
}