import 'dart:async';

import 'package:complete_advanced_flutter_app/domain/usecase/login_usecase.dart';
import 'package:complete_advanced_flutter_app/presentation/base/baseviewmodel.dart';
import 'package:complete_advanced_flutter_app/presentation/common/state_renderer/state_renderer.dart';
import 'package:complete_advanced_flutter_app/presentation/common/state_renderer/state_renderer_impl.dart';

import '../common/freezed_data_classes.dart';

class LoginViewModel extends BaseViewModel implements LoginViewModelInput, LoginViewModelOutput{

  final StreamController _userNameStreamController = StreamController<String>.broadcast();
  final StreamController _passwordStreamController = StreamController<String>.broadcast();
  final StreamController _isAllInputValidStreamController = StreamController<void>.broadcast();
  final StreamController isUserLoggedInSuccessfullyStreamController = StreamController<String>();

  var loginObject = LoginObject("","");

  final LoginUseCase _loginUseCase;
  LoginViewModel(this._loginUseCase);

  ///input
  @override
  void dispose() {
    _userNameStreamController.close();
    _passwordStreamController.close();
    _isAllInputValidStreamController.close();
    isUserLoggedInSuccessfullyStreamController.close();
  }

  @override
  void start() {
    ///view tells state renderer, please show the content of the screen
    inputState.add(ContentState());
  }

  @override
  // TODO: implement inputPassword
  Sink get inputPassword => _passwordStreamController.sink;

  @override
  // TODO: implement inputUserName
  Sink get inputUserName => _userNameStreamController.sink;

  @override
  // TODO: implement inputIsAllInputValid
  Sink get inputIsAllInputValid => _isAllInputValidStreamController.sink;

  @override
  login() async{
    inputState.add(LoadingState(stateRendererType: StateRendererType.POPUP_LOADING_STATE));
    (
        await _loginUseCase.execute(LoginUseCaseInput(loginObject.userName, loginObject.password))).fold(
            (failure) => {
              //left -> failure
            inputState.add(ErrorState(StateRendererType.POPUP_ERROR_STATE, failure.message)),

            print(failure.message)
              

            }, (data)  {

              //right-> success(data)
            inputState.add(ContentState());
            ///Navigate to main screen after the login
            isUserLoggedInSuccessfullyStreamController.add('ABCDEFGH');
    });
  }

  @override
  setPassword(String password) {
    inputPassword.add(password);
    loginObject = loginObject.copyWith(password: password); //data class operation same as kotlin
    _validate();
  }

  @override
  setUserName(String userName) {
   inputUserName.add(userName);
   loginObject = loginObject.copyWith(userName: userName); //data class operation same as kotlin
   _validate();

  }

  ///output
  @override
  // TODO: implement outputIsPasswordValid
  Stream<bool> get outputIsPasswordValid => _passwordStreamController.stream.map((password) => _isPasswordValid(password));

  @override
  // TODO: implement outputIsUserNameValid
  Stream<bool> get outputIsUserNameValid => _userNameStreamController.stream.map((userName) => _isUserNameValid(userName));

  @override
  // TODO: implement outputIsAllInputsValid
  Stream<bool> get outputIsAllInputsValid => _isAllInputValidStreamController.stream.map((_) => _isAllInputsValid());


  ///private function
  _validate(){
    inputIsAllInputValid.add(null);
  }

  bool _isPasswordValid(String password){
    return password.isNotEmpty;
  }

  bool _isUserNameValid(String userName){
    return userName.isNotEmpty;
  }

   bool _isAllInputsValid(){
     return _isPasswordValid(loginObject.password) && _isUserNameValid(loginObject.userName);
  }

}

abstract class LoginViewModelInput{
  ///three function for action
  setUserName(String userName);
  setPassword(String password);
  login();

  ///two sink for stream
  Sink get inputUserName;
  Sink get inputPassword;
  Sink get inputIsAllInputValid;

}

abstract class LoginViewModelOutput{
Stream<bool> get  outputIsUserNameValid;
Stream<bool> get outputIsPasswordValid;
Stream<bool> get outputIsAllInputsValid;
}