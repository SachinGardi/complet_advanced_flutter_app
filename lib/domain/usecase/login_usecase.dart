import 'package:complete_advanced_flutter_app/app/functions.dart';
import 'package:complete_advanced_flutter_app/data/network/failure.dart';
import 'package:complete_advanced_flutter_app/data/request/request.dart';
import 'package:complete_advanced_flutter_app/domain/model/model.dart';
import 'package:complete_advanced_flutter_app/domain/repository/repository.dart';
import 'package:complete_advanced_flutter_app/domain/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

class LoginUseCase implements BaseUseCase<LoginUseCaseInput, Authentication>{
  final Repository _repository;
  LoginUseCase(this._repository);

  @override
  Future<Either<Failure, Authentication>> execute(LoginUseCaseInput input) async{
    DeviceInfo deviceInfo = await getDeviceDetails();
    return await _repository.login(LoginRequest(input.email, input.password, deviceInfo.identifier, deviceInfo.name));
  }

}

class LoginUseCaseInput{
  String email;
  String password;
  LoginUseCaseInput(this.email,this.password);
}