class SliderObject{
  String? title;
  String? subTitle;
  String? image;
  SliderObject(this.title,this.subTitle,this.image);
}

class Customer{
  String id;
  String name;
  int numOfNotifications;
  Customer(this.id,this.name,this.numOfNotifications);

}

class Contacts{
  String phone;
  String link;
  String email;
  Contacts(this.phone,this.link,this.email);

}

class Authentication{
  Customer? customer;
  Contacts? contacts;
  Authentication(this.customer,this.contacts);
}

class DeviceInfo{
  String name;
  String identifier;
  String version;
  DeviceInfo(this.name,this.identifier,this.version);
}

class Services{
  int id;
  String title;
  String image;
  Services(this.id,this.title,this.image);
}

class Stores{
  int id;
  String title;
  String image;
  Stores(this.id,this.title,this.image);
}
class Banners{
  int id;
  String link;
  String title;
  String image;
  Banners(this.id,this.link,this.title,this.image);
}

class HomeData{
  List<Services> services;
  List<Stores> stores;
  List<Banners> banners;
  HomeData(this.services,this.stores,this.banners);
}

class HomeObject{
  HomeData data;
  HomeObject(this.data);
}

class StoreDetails{
  String image;
  int id;
  String title;
  String details;
  String services;
  String about;
  StoreDetails(this.image,this.id,this.title,this.details,this.services,this.about);
}