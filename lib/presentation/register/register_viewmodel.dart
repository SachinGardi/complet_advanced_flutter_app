import 'dart:async';
import 'dart:io';

import 'package:complete_advanced_flutter_app/domain/usecase/register_usecase.dart';
import 'package:complete_advanced_flutter_app/presentation/base/baseviewmodel.dart';

import '../../app/functions.dart';
import '../common/freezed_data_classes.dart';
import '../common/state_renderer/state_renderer.dart';
import '../common/state_renderer/state_renderer_impl.dart';

class RegisterViewmodel extends BaseViewModel
    implements RegisterViewmodelInput, RegisterViewmodelOutput {
  final StreamController _mobileNumberStreamController =
      StreamController<String>.broadcast();
  final StreamController _userNameStreamController =
      StreamController<String>.broadcast();
  final StreamController _emailStreamController =
      StreamController<String>.broadcast();
  final StreamController _passwordStreamController =
      StreamController<String>.broadcast();
  final StreamController _profilePictureStreamController =
      StreamController<String>.broadcast();
  final StreamController _isAllInputValidStreamController =
      StreamController<void>.broadcast();

  final StreamController isUserLoggedInSuccessfullyStreamController = StreamController<bool>();


  RegisterUseCase _registerUseCase;

  RegisterViewmodel(this._registerUseCase);

  var registerViewObject = RegisterObject("", "", "", "", "", "");

  ///inputs

  @override
  void dispose() {
    _mobileNumberStreamController.close();
    _userNameStreamController.close();
    _emailStreamController.close();
    _passwordStreamController.close();
    _profilePictureStreamController.close();
    _isAllInputValidStreamController.close();
    isUserLoggedInSuccessfullyStreamController.close();
    super.dispose();
  }

  @override
  void start() {
    ///view tells state renderer, please show the content of the screen
    inputState.add(ContentState());
  }

  @override
  // TODO: implement inputCountryMobileCode
  Sink get inputMobileNumber => _mobileNumberStreamController.sink;

  @override
  // TODO: implement inputEmail
  Sink get inputEmail => _emailStreamController.sink;

  @override
  // TODO: implement inputIsAllInputValid
  Sink get inputIsAllInputValid => _isAllInputValidStreamController.sink;

  @override
  // TODO: implement inputPassword
  Sink get inputPassword => _passwordStreamController.sink;

  @override
  // TODO: implement inputProfilePic
  Sink get inputProfilePic => _profilePictureStreamController.sink;

  @override
  // TODO: implement inputUserName
  Sink get inputUserName => _userNameStreamController.sink;

  @override
  register() async{
    inputState.add(LoadingState(stateRendererType: StateRendererType.POPUP_LOADING_STATE));
    (
        await _registerUseCase.execute(RegisterUseCaseInput(registerViewObject.mobileNumber,registerViewObject.countryMobileCode,registerViewObject.userName,registerViewObject.email,registerViewObject.password,registerViewObject.profilePicture))).fold(
    (failure) => {
    //left -> failure
    inputState.add(ErrorState(StateRendererType.POPUP_ERROR_STATE, failure.message)),

    print(failure.message)

    }, (data)  {

    //right-> success(data)
    inputState.add(ContentState());
    ///Navigate to main screen after the login
    isUserLoggedInSuccessfullyStreamController.add(true);

    });
  }

  @override
  setMobileNumber(String mobileNumber) {
    if (_isMobileNumberValid(mobileNumber)) {
      ///update register view object with mobileNumber value
      registerViewObject =
          registerViewObject.copyWith(mobileNumber: mobileNumber);

      ///using data class like kotlin
    } else {
      ///reset mobileNumber value in register view object
      registerViewObject = registerViewObject.copyWith(mobileNumber: "");
    }

    inputMobileNumber.add(mobileNumber);
    _validate();
  }

  @override
  setEmail(String email) {
    if (isEmailValid(email)) {
      ///update register view object with email value
      registerViewObject = registerViewObject.copyWith(email: email);

      ///using data class like kotlin
    } else {
      ///reset email value in register view object
      registerViewObject = registerViewObject.copyWith(email: "");
    }
    inputEmail.add(email);
    _validate();
  }

  @override
  setPassword(String password) {
    if (_isPasswordValid(password)) {
      ///update register view object with password value
      registerViewObject = registerViewObject.copyWith(password: password);

      ///using data class like kotlin
    } else {
      ///reset password value in register view object
      registerViewObject = registerViewObject.copyWith(password: "");
    }
    inputPassword.add(password);
    _validate();
  }

  @override
  setProfilePic(File file) {
    if (file.path.isNotEmpty) {
      ///update register view object with file value
      registerViewObject =
          registerViewObject.copyWith(profilePicture: file.path); ///using data class like kotlin
    } else {
      ///reset file value in register view object
      registerViewObject = registerViewObject.copyWith(profilePicture: "");
    }
    inputProfilePic.add(file);
    _validate();
  }

  @override
  setUserName(String userName) {
    if (_isUserNameValid(userName)) {
      ///update register view object with username value
      registerViewObject = registerViewObject.copyWith(userName: userName);

      ///using data class like kotlin
    } else {
      ///reset username value in register view object
      registerViewObject = registerViewObject.copyWith(userName: "");
    }

    inputUserName.add(userName);
    _validate();
  }

  @override
  setCountryCode(String countryCode) {
    if (countryCode.isNotEmpty) {
      ///update register view object with countryCode value
      registerViewObject =
          registerViewObject.copyWith(countryMobileCode: countryCode);

      ///using data class like kotlin
    } else {
      ///reset countryCode value in register view object
      registerViewObject = registerViewObject.copyWith(countryMobileCode: "");
    }
    _validate();
  }

  ///Outputs

  @override
  // TODO: implement outputIsAllInputsValid
  Stream<bool> get outputIsAllInputsValid =>
      _isAllInputValidStreamController.stream.map((_) => _isAllInputsValid());

  @override
  // TODO: implement outputIsCountryMobileCodeValid
  Stream<bool> get outputIsMobileNumberValid =>
      _mobileNumberStreamController.stream
          .map((mobileNumber) => _isMobileNumberValid(mobileNumber));

  @override
  // TODO: implement outputErrorMobileNumberValid
  Stream<String?> get outputErrorMobileNumberValid =>
      outputIsMobileNumberValid.map((isMobileNumberValid) =>
          isMobileNumberValid ? null : "Invalid Mobile Number");

  @override
  // TODO: implement outputIsEmailValid
  Stream<bool> get outputIsEmailValid =>
      _emailStreamController.stream.map((email) => isEmailValid(email));

  @override
  // TODO: implement outputErrorEmailValid
  Stream<String?> get outputErrorEmailValid => outputIsEmailValid
      .map((isEmailValid) => isEmailValid ? null : "Invalid Email");

  @override
  // TODO: implement outputIsPasswordValid
  Stream<bool> get outputIsPasswordValid => _passwordStreamController.stream
      .map((password) => _isPasswordValid(password));

  @override
  // TODO: implement outputErrorPasswordValid
  Stream<String?> get outputErrorPasswordValid => outputIsPasswordValid
      .map((isPasswordValid) => isPasswordValid ? null : "Invalid Password");

  @override
  // TODO: implement outputIsProfilePicValid
  Stream<File?> get outputProfilePicture =>
      _profilePictureStreamController.stream.map((file) => file);

  @override
  // TODO: implement outputIsUserNameValid
  Stream<bool> get outputIsUserNameValid => _userNameStreamController.stream
      .map((userName) => _isUserNameValid(userName));

  @override
  // TODO: implement outputErrorUserNameValid
  Stream<String?> get outputErrorUserNameValid => outputIsUserNameValid
      .map((isUserNameValid) => isUserNameValid ? null : "Invalid username");

  ///Private functions

  bool _isPasswordValid(String password) {
    return password.length >= 8;
  }

  bool _isUserNameValid(String userName) {
    return userName.length >= 8;
  }

  bool _isMobileNumberValid(String mobileNumber) {
    return mobileNumber.length >= 10;
  }

  bool _isAllInputsValid() {
    return registerViewObject.profilePicture.isNotEmpty &&
        registerViewObject.email.isNotEmpty &&
        registerViewObject.password.isNotEmpty &&
        registerViewObject.mobileNumber.isNotEmpty &&
        registerViewObject.countryMobileCode.isNotEmpty &&
        registerViewObject.userName.isNotEmpty;
  }

  _validate() {
    inputIsAllInputValid.add(null);
  }
}

abstract class RegisterViewmodelInput {
  ///6 function for action
  setMobileNumber(String mobileNumber);

  setCountryCode(String countryCode);

  setUserName(String userName);

  setEmail(String email);

  setPassword(String password);

  setProfilePic(File file);

  register();

  Sink get inputMobileNumber;

  Sink get inputUserName;

  Sink get inputEmail;

  Sink get inputPassword;

  Sink get inputProfilePic;

  Sink get inputIsAllInputValid;
}

abstract class RegisterViewmodelOutput {
  Stream<bool> get outputIsMobileNumberValid;

  Stream<String?> get outputErrorMobileNumberValid;

  Stream<bool> get outputIsUserNameValid;

  Stream<String?> get outputErrorUserNameValid;

  Stream<bool> get outputIsEmailValid;

  Stream<String?> get outputErrorEmailValid;

  Stream<bool> get outputIsPasswordValid;

  Stream<String?> get outputErrorPasswordValid;

  Stream<File?> get outputProfilePicture;

  Stream<bool> get outputIsAllInputsValid;
}
