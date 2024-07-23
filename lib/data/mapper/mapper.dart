//To convert a response into a non nullable object(model)(use of mapper )

import 'package:complete_advanced_flutter_app/app/extensions.dart';
import 'package:complete_advanced_flutter_app/data/responses/responses.dart';

import '../../domain/model/model.dart';


const EMPTY = '';
const ZERO = 0;


extension CustomerResponseMapper on CustomerResponse?{
  Customer toDomain(){
    return Customer(this?.id?.orEmpty()??EMPTY, this?.name?.orEmpty()??EMPTY, this?.numOfNotifications?.orZero()??ZERO);
  }
}

extension ContactResponseMapper on ContactResponse?{
  Contacts toDomain(){
    return Contacts(this?.phone?.orEmpty()??EMPTY, this?.link?.orEmpty()??EMPTY, this?.email?.orEmpty()??EMPTY);
  }
}

extension AuthenticationResponseMapper on AuthenticationResponse?{
  Authentication toDomain(){
    return Authentication(this?.customer.toDomain(),this?.contact.toDomain());
  }
}

extension ForgotPasswordResponseMapper on ForgotPasswordResponse?{
  String toDomain(){
    return this?.support?.orEmpty()??EMPTY;
  }
}

extension ServiceResponseMapper on ServiceResponse?{
  Services toDomain(){
    return Services(this?.id?.orZero() ?? ZERO,this?.title?.orEmpty() ?? EMPTY,this?.image?.orEmpty() ?? EMPTY);
  }
}

extension StoresResponseMapper on StoreResponse?{
  Stores toDomain(){
    return Stores(this?.id?.orZero() ?? ZERO,this?.title?.orEmpty() ?? EMPTY,this?.image?.orEmpty() ?? EMPTY);
  }
}

extension BannersResponseMapper on BannerResponse?{
  Banners toDomain(){
    return Banners(this?.id?.orZero() ?? ZERO,this?.link?.orEmpty() ?? EMPTY,this?.title?.orEmpty() ?? EMPTY,this?.image?.orEmpty() ?? EMPTY);
  }
}



extension HomeResponseMapper on HomeResponse?{

  HomeObject toDomain(){

    List<Services> mappedServices = (this?.data?.services?.map((services) => services.toDomain())?? const Iterable.empty()).cast<Services>().toList();
    List<Stores> mappedStores = (this?.data?.stores?.map((stores) => stores.toDomain())?? const Iterable.empty()).cast<Stores>().toList();
    List<Banners> mappedBanners = (this?.data?.banners?.map((banners) => banners.toDomain())?? const Iterable.empty()).cast<Banners>().toList();

    var data = HomeData(mappedServices, mappedStores, mappedBanners);
    return HomeObject(data);
  }
}

extension StoreDetailsMapper on StoreDetailResponse?{
  StoreDetails toDomain(){
    return StoreDetails(this?.image?.orEmpty()??EMPTY, this?.id?.orZero()??ZERO, this?.title?.orEmpty()??EMPTY, this?.details?.orEmpty()??EMPTY, this?.services?.orEmpty()??EMPTY, this?.about?.orEmpty()??EMPTY);
  }
}

