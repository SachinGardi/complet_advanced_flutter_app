import 'dart:async';
import 'dart:ffi';
import 'package:complete_advanced_flutter_app/domain/model/model.dart';
import 'package:complete_advanced_flutter_app/domain/usecase/home_usecase.dart';
import 'package:complete_advanced_flutter_app/presentation/base/baseviewmodel.dart';
import 'package:complete_advanced_flutter_app/presentation/common/state_renderer/state_renderer.dart';
import 'package:complete_advanced_flutter_app/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:rxdart/rxdart.dart';

class HomeViewModel extends BaseViewModel implements HomeViewModelInputs,HomeViewModelOutputs{
  final HomeUseCase _homeUseCase;

  final _dataStreamController = BehaviorSubject<HomeViewObject>();

  HomeViewModel(this._homeUseCase);

  @override
  void start() {
    _getHome();
  }

  _getHome()async{
    inputState.add(LoadingState(stateRendererType: StateRendererType.FULL_SCREEN_LOADING_STATE));

    (await _homeUseCase.execute(Void)).fold((failure) {
      inputState.add(ErrorState(StateRendererType.FULL_SCREEN_ERROR_STATE, failure.message));
    },
            (homeObject) {
        inputState.add(ContentState());
        inputHomeData.add(HomeViewObject(homeObject.data.banners, homeObject.data.services, homeObject.data.stores));
    });
  }

  @override
  void dispose() {
    _dataStreamController.close();
    super.dispose();
  }

  @override 
  // TODO: implement inputHomeData
  Sink get inputHomeData => _dataStreamController.sink;

  @override
  // TODO: implement outputHomeData
  Stream<HomeViewObject> get outputHomeData => _dataStreamController.stream.map((data) => data);




}

abstract class HomeViewModelInputs {
  Sink get inputHomeData;

}

abstract class HomeViewModelOutputs {
  Stream<HomeViewObject> get outputHomeData;
}

 class HomeViewObject{
List<Banners> banners;
List<Services> services;
List<Stores> stores;

HomeViewObject(this.banners,this.services,this.stores);
}
