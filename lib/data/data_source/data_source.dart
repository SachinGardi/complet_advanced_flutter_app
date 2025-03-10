import 'package:complete_advanced_flutter_app/data/request/request.dart';
import 'package:complete_advanced_flutter_app/data/responses/responses.dart';
import '../network/app_api.dart';

abstract class RemoteDataSource{
  Future<AuthenticationResponse>login(LoginRequest loginRequest);
  Future<AuthenticationResponse>register(RegisterRequest registerRequest);
  Future<ForgotPasswordResponse>forgotPassword(String email);
  Future<HomeResponse>getHome();
  Future<StoreDetailResponse>getStoreDetails();
}


class RemoteDataSourceImplementer implements RemoteDataSource{
  final AppServiceClient _appServiceClient;
  RemoteDataSourceImplementer(this._appServiceClient);
  @override
  Future<AuthenticationResponse> login(LoginRequest loginRequest) async{
   return await _appServiceClient.login(loginRequest.email,loginRequest.password,"","");
  }

  @override
  Future<ForgotPasswordResponse> forgotPassword(String email)async {
    return await _appServiceClient.forgotPassword(email);
  }

  @override
  Future<AuthenticationResponse> register(RegisterRequest registerRequest) async {
   return await _appServiceClient.register(registerRequest.countryMobileCode, registerRequest.userName, registerRequest.email, registerRequest.password,registerRequest.mobileNumber,"");
  }

  @override
  Future<HomeResponse> getHome() async{
    return await _appServiceClient.getHome();
  }

  @override
  Future<StoreDetailResponse> getStoreDetails() async{
    return await _appServiceClient.getStoreDetail();
  }
  
}