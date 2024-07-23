import 'package:complete_advanced_flutter_app/data/network/failure.dart';
import 'package:complete_advanced_flutter_app/domain/model/model.dart';
import 'package:complete_advanced_flutter_app/domain/usecase/base_usecase.dart';
import 'package:dartz/dartz.dart';

import '../repository/repository.dart';

class StoreDetailUseCase extends BaseUseCase<void,StoreDetails>{
  final Repository _repository;
  StoreDetailUseCase(this._repository);

  @override
  Future<Either<Failure, StoreDetails>> execute(void input) async{
    return await _repository.getStoreDetails();
  }


}