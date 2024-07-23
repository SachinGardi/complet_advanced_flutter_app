
import 'package:easy_localization/easy_localization.dart';
import '../../app/di.dart';
import '../resources/strings_manager.dart';
import 'package:flutter/material.dart';
import '../forgot_password/forgot_password.dart';
import '../login/login.dart';
import '../main/main_view.dart';
import '../onboarding/onboarding.dart';
import '../register/register.dart';
import '../splash/splash.dart';
import '../store_details/store_detail.dart';

class Routes{
  static const String splashRoute = '/';
  static const String onBoardingRoute = '/onboarding';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String forgetPasswordRoute = '/forgetPassword';
  static const String mainRoute = '/main';
  static const String storeDetailsRoute = '/storeDetails';
}

class RouteGenerator{
  static Route<dynamic> getRoute(RouteSettings routeSettings){
    switch(routeSettings.name){
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case Routes.onBoardingRoute:
        return MaterialPageRoute(builder: (_) => const OnBoardingView());
      case Routes.loginRoute:
        initLoginModule();
        return MaterialPageRoute(builder: (_) => const LoginView());
      case Routes.registerRoute:
        initRegisterModule();
        return MaterialPageRoute(builder: (_) => const RegisterView());
      case Routes.forgetPasswordRoute:
        initForgotPasswordModule();
        return MaterialPageRoute(builder: (_) => const ForgotPasswordView());
      case Routes.mainRoute:
        initHomeModule();
        return MaterialPageRoute(builder: (_) => const MainView());
      case Routes.storeDetailsRoute:
        initStoreDetails();
        return MaterialPageRoute(builder: (_) => const StoreDetailView());
      default:unDefinedRoute();
    }
    return unDefinedRoute();
  }

  static Route<dynamic> unDefinedRoute(){
    return MaterialPageRoute(builder: (_)=>Scaffold(
      appBar: AppBar(title:  const Text(AppStrings.noRouteFound).tr(),),
      body:  Center(child: const Text(AppStrings.noRouteFound).tr()),
    ));
  }
}

