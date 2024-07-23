import 'package:complete_advanced_flutter_app/data/network/failure.dart';
import 'package:complete_advanced_flutter_app/domain/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';
import '../repository/repository.dart';

class ForgotPasswordUseCase extends BaseUseCase<String,String>{
  final Repository _repository;
  
  ForgotPasswordUseCase(this._repository);

  @override
  Future<Either<Failure, String>> execute(String input) async{
   return await _repository.forgotPassword(input);
  }

  
}