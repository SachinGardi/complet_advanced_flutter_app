import 'package:complete_advanced_flutter_app/app/app_prefs.dart';
import 'package:complete_advanced_flutter_app/app/di.dart';
import 'package:complete_advanced_flutter_app/data/data_source/local_data_source.dart';
import 'package:complete_advanced_flutter_app/presentation/resources/assets_manager.dart';
import 'package:complete_advanced_flutter_app/presentation/resources/strings_manager.dart';
import 'package:complete_advanced_flutter_app/presentation/resources/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../resources/routes_manager.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AppPreferences _appPreferences = instance<AppPreferences>();
  final LocalDataSource _localDataSource = instance<LocalDataSource>();
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppPadding.p8),
      children:  [
        ListTile(
          title:  Text(AppStrings.changeLanguage.tr(),style: Theme.of(context).textTheme.headlineMedium),
          leading: SvgPicture.asset(ImageAssets.settingIc),
          trailing: SvgPicture.asset(ImageAssets.settingRightArrowIc),
          onTap: () {
            _changeLanguage();
          },
        ),
        ListTile(
          title:  Text(AppStrings.contactUs.tr(),style: Theme.of(context).textTheme.headlineMedium),
          leading: SvgPicture.asset(ImageAssets.contactUsIc),
          trailing: SvgPicture.asset(ImageAssets.settingRightArrowIc),
          onTap: () {
            _contactUs();
          },
        ),
        ListTile(
          title:  Text(AppStrings.inviteYourFriend.tr(),style: Theme.of(context).textTheme.headlineMedium),
          leading: SvgPicture.asset(ImageAssets.inviteFriendIc),
          trailing: SvgPicture.asset(ImageAssets.settingRightArrowIc),
          onTap: () {
            _inviteFriends();
          },
        ),
        ListTile(
          title:  Text(AppStrings.logout.tr(),style: Theme.of(context).textTheme.headlineMedium,),
          leading: SvgPicture.asset(ImageAssets.logoutIc),
          trailing: SvgPicture.asset(ImageAssets.settingRightArrowIc),
          onTap: () {
            _logout();
          },
        )
      ],
    );
  }

  void _changeLanguage(){
    /// i will apply localization later
    _appPreferences.setLanguageChanged();
    Phoenix.rebirth(context); ///restart to apply language changed
  }

  void _contactUs(){
    /// task for me to open any dummy web page with content
  }

  void _inviteFriends(){
    ///share the app name with friends
  }

  void _logout(){
    _appPreferences.logout();
    _localDataSource.clearCache();
    Navigator.pushReplacementNamed(context, Routes.loginRoute);
  }

}
