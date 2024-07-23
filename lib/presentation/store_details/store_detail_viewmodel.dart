import 'dart:async';
import 'dart:ffi';

import 'package:complete_advanced_flutter_app/domain/model/model.dart';
import 'package:complete_advanced_flutter_app/domain/usecase/store_detail_usecase.dart';
import 'package:complete_advanced_flutter_app/presentation/base/baseviewmodel.dart';
import 'package:rxdart/rxdart.dart';

import '../common/state_renderer/state_renderer.dart';
import '../common/state_renderer/state_renderer_impl.dart';

class StoreDetailViewModel extends BaseViewModel implements StoreDetailViewModelInputs,StoreDetailViewModelOutputs{


  final StreamController _storeDetailsStreamController = BehaviorSubject<StoreDetails>();
  final StoreDetailUseCase _storeDetailUseCase;
  
  StoreDetailViewModel(this._storeDetailUseCase);

  @override
  void start() async{
    _getStoreDetails();
  }

  _getStoreDetails()async{
    inputState.add(LoadingState(stateRendererType: StateRendererType.FULL_SCREEN_LOADING_STATE));

    (await _storeDetailUseCase.execute(Void)).fold((failure) {
      inputState.add(ErrorState(StateRendererType.FULL_SCREEN_ERROR_STATE, failure.message));
    },
            (storeDetailObject) async{
          inputState.add(ContentState());
          inputStoreDetailsData.add(storeDetailObject);
        });
  }

  @override
  void dispose() {
    _storeDetailsStreamController.close();
  }

  @override
  // TODO: implement inputStoreDetailsData
  Sink get inputStoreDetailsData => _storeDetailsStreamController.sink;

  @override
  // TODO: implement outputStoreDetailsData
  Stream<StoreDetails> get outputStoreDetailsData => _storeDetailsStreamController.stream.map((data) => data);

}

abstract class StoreDetailViewModelInputs{
Sink get inputStoreDetailsData;
}

abstract class StoreDetailViewModelOutputs{
  Stream<StoreDetails> get outputStoreDetailsData;
}

