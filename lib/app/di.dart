
import 'package:complete_advanced_flutter_app/app/app_prefs.dart';
import 'package:complete_advanced_flutter_app/data/data_source/data_source.dart';
import 'package:complete_advanced_flutter_app/data/data_source/local_data_source.dart';
import 'package:complete_advanced_flutter_app/data/network/app_api.dart';
import 'package:complete_advanced_flutter_app/data/network/dio_factory.dart';
import 'package:complete_advanced_flutter_app/data/network/network_info.dart';
import 'package:complete_advanced_flutter_app/data/repository/repository_impl.dart';
import 'package:complete_advanced_flutter_app/domain/repository/repository.dart';
import 'package:complete_advanced_flutter_app/domain/usecase/forgot_password_usecase.dart';
import 'package:complete_advanced_flutter_app/domain/usecase/home_usecase.dart';
import 'package:complete_advanced_flutter_app/domain/usecase/login_usecase.dart';
import 'package:complete_advanced_flutter_app/domain/usecase/register_usecase.dart';
import 'package:complete_advanced_flutter_app/domain/usecase/store_detail_usecase.dart';
import 'package:complete_advanced_flutter_app/presentation/forgot_password/forgot_password_viewmodel.dart';
import 'package:complete_advanced_flutter_app/presentation/login/login_viewmodel.dart';
import 'package:complete_advanced_flutter_app/presentation/main/home/home_viewmodel.dart';
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../presentation/register/register_viewmodel.dart';
import '../presentation/store_details/store_detail_viewmodel.dart';

final instance = GetIt.instance;

Future<void> initAppModule()async{
  final sharedPrefs = await SharedPreferences.getInstance();

  ///SharedPreferences instance
  instance.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  ///AppPreferences instance
  instance.registerLazySingleton<AppPreferences>(() => AppPreferences(instance()));

  ///Network info instance
  instance.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(DataConnectionChecker()));

  ///dio factory instance
  instance.registerLazySingleton<DioFactory>(() => DioFactory(instance()));

  ///app service client
  final dio = await instance<DioFactory>().getDio();
  instance.registerLazySingleton<AppServiceClient>(() => AppServiceClient(dio));

  ///remote data source
  instance.registerLazySingleton<RemoteDataSource>(() => RemoteDataSourceImplementer(instance()));

  ///local data source
  instance.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImplementer(instance()));

  ///repository instance
  instance.registerLazySingleton<Repository>(() => RepositoryImpl(instance(),instance(),instance()));

}

initLoginModule(){

  if(!GetIt.I.isRegistered<LoginUseCase>()){
    ///LoginUseCase instance
    instance.registerFactory<LoginUseCase>(() => LoginUseCase(instance()));

    ///LoginViewModel instance
    instance.registerFactory<LoginViewModel>(() => LoginViewModel(instance()));
  }

}

initForgotPasswordModule(){
  if(!GetIt.I.isRegistered<ForgotPasswordUseCase>()){
    ///ForgotPasswordUseCase instance
    instance.registerFactory<ForgotPasswordUseCase>(() => ForgotPasswordUseCase(instance()));

    ///ForgotPasswordViewModel instance
    instance.registerFactory<ForgotPasswordViewModel>(() => ForgotPasswordViewModel(instance()));
  }
}

initRegisterModule(){
  if(!GetIt.I.isRegistered<RegisterUseCase>()){
    ///RegisterUseCase instance
    instance.registerFactory<RegisterUseCase>(() => RegisterUseCase(instance()));

    ///RegisterViewModel instance
    instance.registerFactory<RegisterViewmodel>(() => RegisterViewmodel(instance()));
    ///Image picker instance
    instance.registerFactory<ImagePicker>(() => ImagePicker());
  }
}

initHomeModule(){
  if(!GetIt.I.isRegistered<HomeUseCase>()){
    ///HomeUseCase instance
    instance.registerFactory<HomeUseCase>(() => HomeUseCase(instance()));

    ///HomeViewModel instance
    instance.registerFactory<HomeViewModel>(() => HomeViewModel(instance()));

  }
}

initStoreDetails(){
  if(!GetIt.I.isRegistered<StoreDetailUseCase>()){
    ///HomeUseCase instance
    instance.registerFactory<StoreDetailUseCase>(() => StoreDetailUseCase(instance()));

    ///HomeViewModel instance
    instance.registerFactory<StoreDetailViewModel>(() => StoreDetailViewModel(instance()));

  }
}

resetAllModule(){
  instance.reset(dispose: false);
  initAppModule();
  initLoginModule();
  initForgotPasswordModule();
  initRegisterModule();
  initHomeModule();
  initStoreDetails();
}