import 'package:complete_advanced_flutter_app/data/data_source/data_source.dart';
import 'package:complete_advanced_flutter_app/data/data_source/local_data_source.dart';
import 'package:complete_advanced_flutter_app/data/mapper/mapper.dart';
import 'package:complete_advanced_flutter_app/data/network/error_handler.dart';
import 'package:complete_advanced_flutter_app/data/network/failure.dart';
import 'package:complete_advanced_flutter_app/data/network/network_info.dart';
import 'package:complete_advanced_flutter_app/data/request/request.dart';
import 'package:complete_advanced_flutter_app/domain/model/model.dart';
import 'package:complete_advanced_flutter_app/domain/repository/repository.dart';
import 'package:dartz/dartz.dart';

class RepositoryImpl extends Repository{
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;
  RepositoryImpl(this._remoteDataSource,this._networkInfo,this._localDataSource);

  @override
  Future<Either<Failure, Authentication>> login(LoginRequest loginRequest) async{
    if(await _networkInfo.isConnected){
      try{
        /// its safe to call the api
        final response = await _remoteDataSource.login(loginRequest);

        if(response.status == ApiInternalStatus.SUCCESS){
          ///return data
          ///return right
          return Right(response.toDomain());
        }else{
          ///return Biz Logic
          ///return left
          return Left(Failure(response.status??ApiInternalStatus.FAILURE, response.message??ResponseMessage.DEFAULT));
        }
      }catch(error){
      return  (Left(ErrorHandler.handle(error).failure));
      }

    }else{
    /// return connection error
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());

    }
  }

  @override
  Future<Either<Failure, String>> forgotPassword(String email)async {
    if(await _networkInfo.isConnected){
      try{
        /// its safe to call the api
        final response = await _remoteDataSource.forgotPassword(email);
        
        if(response.status == ApiInternalStatus.SUCCESS){
          ///return data
          ///return right
          return Right(response.toDomain());

        }
        else{
          ///return Biz Logic
          ///return left
          return Left(Failure(response.status??ResponseCode.DEFAULT, response.message??ResponseMessage.DEFAULT));
        }
        }
        catch(error){
        return(Left(ErrorHandler.handle(error).failure));
      }
    }
    else{
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, Authentication>> register(RegisterRequest registerRequest) async {
    if(await _networkInfo.isConnected){
      try{

        /// its safe to call the api
        final response = await _remoteDataSource.register(registerRequest);

        if(response.status == ApiInternalStatus.SUCCESS){
          ///return data
          ///return right
          return Right(response.toDomain());
        }
        else{
          ///return Biz Logic
          ///return left
          return Left(Failure(response.status??ApiInternalStatus.FAILURE, response.message??ResponseMessage.DEFAULT));
        }
      }
      catch(error){
        return  (Left(ErrorHandler.handle(error).failure));
      }
    }
    else{
      /// return connection error
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());

    }
  }

  @override
  Future<Either<Failure, HomeObject>> getHome() async {

    try{
      ///get from cache
      final response = await _localDataSource.getHome();
      return Right(response.toDomain());

    }catch(cacheError){
      ///we have cache error so we should call api
      if(await _networkInfo.isConnected){
        try{

          /// its safe to call the api
          final response = await _remoteDataSource.getHome();

          if(response.status == ApiInternalStatus.SUCCESS){
            ///return data
            ///return right
            _localDataSource.saveHomeToCache(response);
            return Right(response.toDomain());
          }
          else{
            ///return Biz Logic
            ///return left
            return Left(Failure(response.status??ApiInternalStatus.FAILURE, response.message??ResponseMessage.DEFAULT));
          }
        }
        catch(error){
          return  (Left(ErrorHandler.handle(error).failure));
        }
      }
      else{
        /// return connection error
        return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());

      }
    }

  }

  @override
  Future<Either<Failure, StoreDetails>> getStoreDetails() async{

    try{
      ///get from cache
      final response = await _localDataSource.getStoreDetails();
      return Right(response.toDomain());

    }catch(cacheError){
      ///we have cache error so we should call api
      if(await _networkInfo.isConnected){
        try{

          /// its safe to call the api
          final response = await _remoteDataSource.getStoreDetails();

          if(response.status == ApiInternalStatus.SUCCESS){
            ///return data
            ///return right
            _localDataSource.saveStoreDetailToCache(response);
            return Right(response.toDomain());
          }
          else{
            ///return Biz Logic
            ///return left
            return Left(Failure(response.status??ApiInternalStatus.FAILURE, response.message??ResponseMessage.DEFAULT));
          }
        }
        catch(error){
          return  (Left(ErrorHandler.handle(error).failure));
        }
      }
      else{
        /// return connection error
        return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());

      }
    }

  }

  
}