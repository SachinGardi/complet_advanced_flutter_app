import 'dart:async';

import 'package:complete_advanced_flutter_app/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:rxdart/rxdart.dart';

abstract class BaseViewModel extends BaseViewModelInputs implements BaseViewModelOutputs{

  ///shared variable and functions that will be used through any view model.

  final StreamController _inputStateStreamController = BehaviorSubject<FlowState>();

  @override
  Sink get inputState => _inputStateStreamController.sink;

  @override
  Stream<FlowState> get outputState => _inputStateStreamController.stream.map((flowState) => flowState);

  @override
  void dispose() {
    _inputStateStreamController.close();
  }
}
abstract class BaseViewModelInputs  {
void start(); /// will be called while initialization of view model.
void dispose();/// will be called when view model dies.
Sink get inputState;
}

abstract class BaseViewModelOutputs{
Stream<FlowState> get outputState;
}