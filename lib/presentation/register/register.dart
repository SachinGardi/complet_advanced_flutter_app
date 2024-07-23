import 'dart:io';

import 'package:complete_advanced_flutter_app/data/mapper/mapper.dart';
import 'package:complete_advanced_flutter_app/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:complete_advanced_flutter_app/presentation/register/register_viewmodel.dart';
import 'package:complete_advanced_flutter_app/presentation/resources/color_manager.dart';
import 'package:complete_advanced_flutter_app/presentation/resources/values_manager.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';


import '../../app/app_prefs.dart';
import '../../app/di.dart';
import '../resources/assets_manager.dart';
import '../resources/routes_manager.dart';
import '../resources/strings_manager.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final RegisterViewmodel _viewmodel = instance<RegisterViewmodel>();
  final AppPreferences _appPreferences = instance<AppPreferences>();
  final ImagePicker picker = instance<ImagePicker>();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _userNameTextEditingController =
      TextEditingController();
  final TextEditingController _mobileNumberTextEditingController =
      TextEditingController();
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();

  _bind() {
    _viewmodel.start();

    ///userName set
    _userNameTextEditingController.addListener(() {
      _viewmodel.setUserName(_userNameTextEditingController.text);
    });

    ///mobile number set
    _mobileNumberTextEditingController.addListener(() {
      _viewmodel.setMobileNumber(_mobileNumberTextEditingController.text);
    });

    ///email set
    _emailTextEditingController.addListener(() {
      _viewmodel.setEmail(_emailTextEditingController.text);
    });

    ///password set
    _passwordTextEditingController.addListener(() {
      _viewmodel.setPassword(_passwordTextEditingController.text);
    });

    _viewmodel.isUserLoggedInSuccessfullyStreamController.stream.listen((isSuccessLoggedIn) {
      ///Navigate to main screen
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _appPreferences.setIsUserLoggedIn();
        Navigator.pushReplacementNamed(context,Routes.mainRoute);
      });
    });
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  void dispose() {
    _viewmodel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: AppSize.s0,
          backgroundColor: ColorManager.white,
          iconTheme: IconThemeData(color: ColorManager.primary),
        ),
        backgroundColor: ColorManager.white,
        body: StreamBuilder<FlowState>(
          stream: _viewmodel.outputState,
          builder: (context, snapshot) {
            return Center(
              child: snapshot.data
                      ?.getScreenWidget(context, _getContentWidget(), () {
                    _viewmodel.register();
                  }) ??
                  _getContentWidget(),
            );
          },
        ));
  }

  Widget _getContentWidget() {
    return Container(
      padding: const EdgeInsets.only(top: AppPadding.p30),
      child: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Image(image: AssetImage(ImageAssets.splashLogo)),
                const SizedBox(
                  height: AppSize.s28,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: AppPadding.p28, right: AppPadding.p28),
                  child: StreamBuilder<String?>(
                    stream: _viewmodel.outputErrorUserNameValid,
                    builder: (context, snapshot) {
                      return TextFormField(
                        controller: _userNameTextEditingController,
                        decoration: InputDecoration(
                            hintText: AppStrings.username.tr(),
                            labelText: AppStrings.username.tr(),
                            errorText: snapshot.data),
                      );
                    },
                  ),
                ),
                Center(
                  child: Padding(
                      padding: const EdgeInsets.only(
                        top: AppPadding.p24, left: AppPadding.p28,right: AppPadding.p28,bottom: AppPadding.p12
                      ),
                    child: Row(
                      children: [
                        Expanded(flex:1,child: CountryCodePicker(
                          onChanged: (country) {
                            ///update view model with the selected code
                            _viewmodel.setCountryCode(country.dialCode ?? EMPTY);
                          },
                          initialSelection: "+91",
                          showCountryOnly: true,
                          hideMainText: true,
                          showOnlyCountryWhenClosed: true,
                          favorite: const ["+33","+39","+93"],

                        )),
                        Expanded(flex:3,child: StreamBuilder<String?>(
                          stream: _viewmodel.outputErrorMobileNumberValid,
                          builder: (context, snapshot) {
                            return TextFormField(
                              keyboardType: TextInputType.phone,
                              controller: _mobileNumberTextEditingController,
                              decoration: InputDecoration(
                                  hintText: AppStrings.mobileNumber.tr(),
                                  labelText: AppStrings.mobileNumber.tr(),
                                  errorText: snapshot.data),
                            );
                          },
                        ),),
                      ],
                    ),
                  ),
                ),


                const SizedBox(
                  height: AppSize.s12,
                ),

                Padding(
                  padding: const EdgeInsets.only(
                      left: AppPadding.p28, right: AppPadding.p28),
                  child: StreamBuilder<String?>(
                    stream: _viewmodel.outputErrorEmailValid,
                    builder: (context, snapshot) {
                      return TextFormField(
                        controller: _emailTextEditingController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            hintText: AppStrings.emailHint.tr(),
                            labelText: AppStrings.emailHint.tr(),
                            errorText: snapshot.data),
                      );
                    },
                  ),
                ),

                const SizedBox(
                  height: AppSize.s12,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: AppPadding.p12,
                      left: AppPadding.p28, right: AppPadding.p28),
                  child: StreamBuilder<String?>(
                    stream: _viewmodel.outputErrorPasswordValid,
                    builder: (context, snapshot) {
                      return TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        controller: _passwordTextEditingController,
                        decoration: InputDecoration(
                            hintText: AppStrings.password.tr(),
                            labelText: AppStrings.password.tr(),
                            errorText: snapshot.data),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: AppSize.s12,
                ),
           Padding(
            padding: const EdgeInsets.only(
              top: AppPadding.p12,
                left: AppPadding.p28, right: AppPadding.p28),
          child: Container(
            height: AppSize.s40,
            decoration: BoxDecoration(
              border: Border.all(color: ColorManager.lightGrey)
            ),
            child: GestureDetector(
              child: _getMediaWidget(),
              onTap: () {
                _showPicker(context);
              },
            ),
          ),
          ),
                const SizedBox(
                  height: AppSize.s28,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: AppPadding.p28, right: AppPadding.p28),
                  child: StreamBuilder<bool>(
                    stream: _viewmodel.outputIsAllInputsValid,
                    builder: (context, snapshot) {
                      return SizedBox(
                        width: double.infinity,
                        height: AppSize.s40,
                        child: ElevatedButton(
                            onPressed: (snapshot.data ?? false)
                                ? () {
                                    _viewmodel.register();
                                  }
                                : null,
                            child: const Text(AppStrings.register).tr()),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: AppPadding.p8,
                    left: AppPadding.p28,
                    right: AppPadding.p28,
                  ),
                  child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        AppStrings.alreadyHaveAccount,
                        style: Theme.of(context).textTheme.titleSmall,
                      ).tr()),
                )
              ],
            )),
      ),
    );
  }

 Widget _getMediaWidget(){
    return Padding(
        padding: const EdgeInsets.only(left: AppPadding.p8,right: AppPadding.p8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
           Flexible(child: const Text(AppStrings.profilePicture).tr()),
          Flexible(
            child: StreamBuilder<File?>(
            stream: _viewmodel.outputProfilePicture,
            builder: (context, snapshot){
              return _imagePickedByUser(snapshot.data);
            },
          ),),
          Flexible(child: SvgPicture.asset(ImageAssets.photoCameraIc)),
        ],
      ),
    );
  }

  Widget _imagePickedByUser(File? image){
    if(image != null && image.path.isNotEmpty){
      return Image.file(image);
    }
    else{
      return Container();
    }
  }

  _showPicker(BuildContext context){
    showModalBottomSheet(context: context, builder: (context) {
      return  SafeArea(child: Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera),
            title: const Text(AppStrings.photoGallery).tr(),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              _imageFromGallery();
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt_rounded),
            title: const Text(AppStrings.photoCamera).tr(),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              _imageFromCamera();
              Navigator.of(context).pop();
            },
          ),
        ],
      ));
    },);
  }

  _imageFromGallery()async{
    var image = await picker.pickImage(source: ImageSource.gallery);
    _viewmodel.setProfilePic(File(image?.path ?? ""));
  }

  _imageFromCamera()async{
      var image = await picker.pickImage(source: ImageSource.camera);
    _viewmodel.setProfilePic(File(image?.path ?? ""));
  }
}
