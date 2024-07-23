import 'package:complete_advanced_flutter_app/app/di.dart';
import 'package:complete_advanced_flutter_app/presentation/resources/language_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'app/app.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized(); /// if we want to initialize something before run app
  await EasyLocalization.ensureInitialized();
  await initAppModule();

  runApp(
      EasyLocalization(
          supportedLocales: const [ENGLISH_LOCAL,MARATHI_LOCAL],
      path: ASSET_PATH_LOCALISATIONS,
      child: Phoenix(child: MyApp()))
  );
}

