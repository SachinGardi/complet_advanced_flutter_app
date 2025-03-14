import 'package:complete_advanced_flutter_app/app/app_prefs.dart';
import 'package:complete_advanced_flutter_app/app/di.dart';
import 'package:complete_advanced_flutter_app/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:complete_advanced_flutter_app/presentation/login/login_viewmodel.dart';
import 'package:complete_advanced_flutter_app/presentation/resources/assets_manager.dart';
import 'package:complete_advanced_flutter_app/presentation/resources/color_manager.dart';
import 'package:complete_advanced_flutter_app/presentation/resources/routes_manager.dart';
import 'package:complete_advanced_flutter_app/presentation/resources/strings_manager.dart';
import 'package:complete_advanced_flutter_app/presentation/resources/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  final LoginViewModel _viewModel = instance<LoginViewModel>();
  final AppPreferences _appPreferences = instance<AppPreferences>();

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  _bind(){
    _viewModel.start();
    _userNameController.addListener(()=>_viewModel.setUserName(_userNameController.text));
    _passwordController.addListener(()=>_viewModel.setPassword(_passwordController.text));
    _viewModel.isUserLoggedInSuccessfullyStreamController.stream.listen((token) {
    ///Navigate to main screen
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _appPreferences.setIsUserLoggedIn();
        _appPreferences.setToken(token);
        resetAllModule();
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: StreamBuilder<FlowState>(
        stream: _viewModel.outputState,
        builder: (context, snapshot) {
         return snapshot.data?.getScreenWidget(context, _getContentWidget(), (){
            _viewModel.login();
          })??_getContentWidget();
        },
      ),
    );
  }

  Widget _getContentWidget(){
    return Container(
        padding: const EdgeInsets.only(top: AppPadding.p100),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
              child: Column(
                children: [
                  const Image(image: AssetImage(ImageAssets.splashLogo)),
                  const SizedBox(height: AppSize.s28,),
                   Padding(
                      padding: const EdgeInsets.only(left: AppPadding.p28,right: AppPadding.p28),
                    child: StreamBuilder<bool>(
                      stream: _viewModel.outputIsUserNameValid,
                      builder: (context, snapshot) {
                        return TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _userNameController,
                          decoration:  InputDecoration(
                            hintText:AppStrings.username.tr(),
                            labelText: AppStrings.username.tr(),
                            errorText: (snapshot.data ?? true)?null:AppStrings.usernameError.tr()
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppSize.s28,),
                  Padding(
                    padding: const EdgeInsets.only(left: AppPadding.p28,right: AppPadding.p28),
                    child: StreamBuilder<bool>(
                      stream: _viewModel.outputIsPasswordValid,
                      builder: (context, snapshot) {
                        return TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          controller: _passwordController,
                          decoration:  InputDecoration(
                              hintText:AppStrings.password.tr(),
                              labelText: AppStrings.password.tr(),
                              errorText: (snapshot.data ?? true)?null:AppStrings.passwordError.tr()
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppSize.s28,),
              Padding(
                padding: const EdgeInsets.only(left: AppPadding.p28,right: AppPadding.p28),
              child: StreamBuilder<bool>(
                stream: _viewModel.outputIsAllInputsValid,
                builder: (context, snapshot) {
                  return SizedBox(
                    width: double.infinity,
                    height: AppSize.s40,
                    child: ElevatedButton(onPressed: (snapshot.data ?? false)?(){_viewModel.login();}:null,
                        child: const Text(AppStrings.login).tr()),
                  );
                },
              ),
              ),
                   Padding(padding: const EdgeInsets.only(
                    top: AppPadding.p8,
                    left: AppPadding.p28,
                    right: AppPadding.p28,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(onPressed: () {
                        Navigator.pushNamed(context, Routes.forgetPasswordRoute);
                      },
                          child:  Text(
                            AppStrings.forgotPassword,
                            style: Theme.of(context).textTheme.titleSmall,
                          ).tr()),
                      Expanded(
                        child: Align(
                          heightFactor: AppSize.s1_25,
                          child: TextButton(onPressed: () {
                            Navigator.pushNamed(context, Routes.registerRoute);
                          },
                              child:  Text(
                              textAlign: TextAlign.end,
                                AppStrings.registerText,
                                style: Theme.of(context).textTheme.titleSmall,
                              ).tr()),
                        ),
                      ),
                    ],
                  ),
                  )
                ],
              )),
        ),
      );

  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
