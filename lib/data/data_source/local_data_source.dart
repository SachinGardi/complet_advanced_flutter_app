import 'package:complete_advanced_flutter_app/data/network/error_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../responses/responses.dart';

const CACHE_HOME_KEY = 'CACHE_HOME_KEY';
const CACHE_STORE_DETAILS_KEY = 'CACHE_STORE_DETAILS_KEY';
const CACHE_HOME_INTERVAL = 60 * 1000; //1 MINUTE IN MILLISECOND
const CACHE_STORE_DETAILS_INTERVAL = 60 * 1000; //1 MINUTE IN MILLISECOND

abstract class LocalDataSource{
  Future<HomeResponse>getHome();
  Future<StoreDetailResponse>getStoreDetails();
  Future<void> saveHomeToCache(HomeResponse homeResponse);
  Future<void> saveStoreDetailToCache(StoreDetailResponse storeDetailResponse);
  void clearCache();
  void removeFromCache(String key);
}

class LocalDataSourceImplementer implements LocalDataSource{
  final SharedPreferences _sharedPreferences;
  LocalDataSourceImplementer(this._sharedPreferences);
  ///Run time cache
  Map<String,CachedItem> cacheMap = Map();

  @override
  Future<HomeResponse> getHome()async {
  CachedItem?  cachedItem = cacheMap[CACHE_HOME_KEY];
  if(cachedItem != null && cachedItem.isValid(CACHE_HOME_INTERVAL)){
    ///return the response from cache
    return cachedItem.data;

  }else{
    /// return the error that cache is not valid
    throw ErrorHandler.handle(DataSource.CACHE_ERROR);
  }
  }

  @override
  Future<void> saveHomeToCache(HomeResponse homeResponse) async{
    cacheMap[CACHE_HOME_KEY] = CachedItem(homeResponse);
  }

  @override
  void clearCache() {
    cacheMap.clear();
  }

  @override
  void removeFromCache(String key) {
    cacheMap.remove(key);
  }

  @override
  Future<StoreDetailResponse> getStoreDetails() async{
    CachedItem?  cachedItem = cacheMap[CACHE_STORE_DETAILS_KEY];
    if(cachedItem != null && cachedItem.isValid(CACHE_STORE_DETAILS_INTERVAL)){
      ///return the response from cache
      return cachedItem.data;

    }else{
      /// return the error that cache is not valid
      throw ErrorHandler.handle(DataSource.CACHE_ERROR);
    }
  }

  @override
  Future<void> saveStoreDetailToCache(StoreDetailResponse storeDetailResponse) async{
    cacheMap[CACHE_STORE_DETAILS_KEY] = CachedItem(storeDetailResponse);
  }

}

class CachedItem{
  dynamic data;
  int cacheTime = DateTime.now().millisecondsSinceEpoch;
  CachedItem(this.data);
}

extension CachedItemExtension on CachedItem{

  bool isValid(int expirationTime){
    ///Suppose expiration time is 60sec
    int currentTimeInMills = DateTime.now().millisecondsSinceEpoch; ///suppose time is 1:00:00 pm
    bool isCacheValid = currentTimeInMills - expirationTime < cacheTime;
    ///false if current time > 1:00:30
    ///true if current time < 1:00:30
    return isCacheValid;

  }

}