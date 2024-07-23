import 'package:complete_advanced_flutter_app/presentation/main/home/home_page.dart';
import 'package:complete_advanced_flutter_app/presentation/main/notification_page.dart';
import 'package:complete_advanced_flutter_app/presentation/main/search_page.dart';
import 'package:complete_advanced_flutter_app/presentation/main/settings_page.dart';
import 'package:complete_advanced_flutter_app/presentation/resources/color_manager.dart';
import 'package:complete_advanced_flutter_app/presentation/resources/strings_manager.dart';
import 'package:complete_advanced_flutter_app/presentation/resources/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {

  List<Widget> pages = [const HomePage(),const SearchPage(),const NotificationsPage(),const SettingsPage()];
  List<String> title = [AppStrings.home.tr(),AppStrings.search.tr(),AppStrings.notifications.tr(),AppStrings.settings.tr()];

  var _title = AppStrings.home.tr();
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: ColorManager.primary,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
        ),
        backgroundColor: ColorManager.primary,
        automaticallyImplyLeading: false,
        title:  Text(_title,style: Theme.of(context).textTheme.displayMedium,),
        centerTitle: true,
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: ColorManager.lightGrey,
              spreadRadius: AppSize.s1
            )
          ]
        ),
        child: BottomNavigationBar(
          selectedItemColor: ColorManager.primary,
          unselectedItemColor: ColorManager.grey,
            currentIndex: _currentIndex,
            onTap: onTap,
            items:  [
               BottomNavigationBarItem(
                  icon: const Icon(Icons.home),
                  label: AppStrings.home.tr()
              ),
              BottomNavigationBarItem(
                  icon: const Icon(Icons.search),
                  label: AppStrings.search.tr()
              ),
               BottomNavigationBarItem(
                  icon: const Icon(Icons.notifications),
                  label: AppStrings.notifications.tr()
              ),
               BottomNavigationBarItem(
                  icon: const Icon(Icons.settings),
                  label: AppStrings.settings.tr()
              ),
            ]
        ),
      ),
    );
  }

  ///this function to change the view of bottom navigation bar with onTap
  onTap(int index){
    setState(() {
      _currentIndex = index;
      _title = title[index];
    });
  }
}
