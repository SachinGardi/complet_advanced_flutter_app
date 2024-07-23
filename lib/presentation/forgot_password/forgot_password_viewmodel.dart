import 'dart:async';

import 'package:complete_advanced_flutter_app/domain/usecase/forgot_password_usecase.dart';
import 'package:complete_advanced_flutter_app/presentation/base/baseviewmodel.dart';
import 'package:complete_advanced_flutter_app/presentation/common/state_renderer/state_renderer.dart';
import 'package:complete_advanced_flutter_app/presentation/common/state_renderer/state_renderer_impl.dart';

import '../../app/functions.dart';

class ForgotPasswordViewModel extends BaseViewModel implements ForgotPasswordViewModelInput,ForgotPasswordViewModelOutput{
  final StreamController _emailStreamController = StreamController<String>.broadcast();
  final StreamController _isAllInputValidStreamController = StreamController<void>.broadcast();
  final ForgotPasswordUseCase _forgotPasswordUseCase;

  ForgotPasswordViewModel(this._forgotPasswordUseCase);
  
  var email = "";
  
  @override
  void start() {
    inputState.add(ContentState());
  }

  @override
  forgotPassword() async {
   inputState.add(LoadingState(stateRendererType: StateRendererType.POPUP_LOADING_STATE));
   (await _forgotPasswordUseCase.execute(email)).fold((failure){
     inputState.add(ErrorState(StateRendererType.POPUP_ERROR_STATE,failure.message));
   }, (supportMessage) {
     inputState.add(SuccessState(supportMessage));
   });
  }

  @override
  setEmail(String email) {
    inputEmail.add(email);
    this.email = email;
    _validate();
  }

  ///inputs
  @override
  // TODO: implement inputEmail
  Sink get inputEmail => _emailStreamController.sink;

  @override
  // TODO: implement inputIsAllInputValid
  Sink get inputIsAllInputValid => _isAllInputValidStreamController.sink;

  // output
  @override
  void dispose() {
    _emailStreamController.close();
    _isAllInputValidStreamController.close();
  }


///outputs
  @override
  // TODO: implement outputIsAllInputValid
  Stream<bool> get outputIsAllInputValid => _emailStreamController.stream.map((email) => isEmailValid(email));

  @override
  // TODO: implement outputIsEmailValid
  Stream<bool> get outputIsEmailValid => _isAllInputValidStreamController.stream.map((isAllInputValid) => _isAllInputValid());


  _isAllInputValid(){
    return isEmailValid(email);
  }

  _validate(){
    inputIsAllInputValid.add(null);
  }

}


abstract class ForgotPasswordViewModelInput{
  forgotPassword();
  setEmail(String email);
  Sink get inputEmail;
  Sink get inputIsAllInputValid;
}

abstract class ForgotPasswordViewModelOutput{

  Stream<bool> get outputIsEmailValid;
  Stream<bool> get outputIsAllInputValid;
}