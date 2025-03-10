import 'package:complete_advanced_flutter_app/domain/model/model.dart';
import 'package:dartz/dartz.dart';
import '../../data/network/failure.dart';
import '../../data/request/request.dart';

abstract class Repository{
  Future<Either<Failure,Authentication>>login(LoginRequest loginRequest);
  Future<Either<Failure,String>>forgotPassword(String email);
  Future<Either<Failure,Authentication>>register(RegisterRequest registerRequest);
  Future<Either<Failure,HomeObject>>getHome();
  Future<Either<Failure,StoreDetails>>getStoreDetails();
}