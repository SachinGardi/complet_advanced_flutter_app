import 'package:complete_advanced_flutter_app/data/network/failure.dart';
import 'package:dartz/dartz.dart';

abstract class BaseUseCase<In,Out>{
  Future<Either<Failure,Out>> execute(In input);
}