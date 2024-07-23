import 'package:complete_advanced_flutter_app/domain/model/model.dart';
import 'package:complete_advanced_flutter_app/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:complete_advanced_flutter_app/presentation/resources/color_manager.dart';
import 'package:complete_advanced_flutter_app/presentation/resources/strings_manager.dart';
import 'package:complete_advanced_flutter_app/presentation/resources/values_manager.dart';
import 'package:complete_advanced_flutter_app/presentation/store_details/store_detail_viewmodel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../app/di.dart';

class StoreDetailView extends StatefulWidget {
  const StoreDetailView({super.key});

  @override
  State<StoreDetailView> createState() => _StoreDetailViewState();
}

class _StoreDetailViewState extends State<StoreDetailView> {
  final StoreDetailViewModel _viewModel = instance<StoreDetailViewModel>();


  @override
  void initState() {
    _bind();
    super.initState();
  }

  _bind(){
    _viewModel.start();
  }
  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<FlowState>(
        stream: _viewModel.outputState,
        builder: (context, snapshot) {
          return Scaffold(
            body:  snapshot.data?.getScreenWidget(context, _getContentWidgets(),
                    () {
                  _viewModel.start();
                }) ??
                Container()
          );

        },
      )
    );
  }

  Widget _getContentWidgets(){
   return Scaffold(
     backgroundColor: ColorManager.white,
     appBar: AppBar(
       title:  Text(AppStrings.storeDetails.tr()),
       elevation: AppSize.s0,
       centerTitle: true,
       iconTheme: IconThemeData(
         color: ColorManager.white
       ),
       backgroundColor: ColorManager.primary,
     ),
     body: Container(
       constraints: const BoxConstraints.expand(),
       color: ColorManager.white,
       child: SingleChildScrollView(
         child: StreamBuilder<StoreDetails>(
           stream: _viewModel.outputStoreDetailsData,
             builder: (context, snapshot) {
               return _getItems(snapshot.data);
             },
         ),
       ),
     ),
   );
  }

  Widget _getItems(StoreDetails? storeDetails){
    if(storeDetails != null){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Center(
          child: Image.network(storeDetails.image,fit: BoxFit.cover,width: double.infinity,height: 250,),
        ),
          _getSection(AppStrings.details.tr()),
          _getInfoText(storeDetails.details),
          _getSection(AppStrings.services.tr()),
          _getInfoText(storeDetails.services),
          _getSection(AppStrings.about.tr()),
          _getInfoText(storeDetails.about),
        ],
      );
    }
    else{
      return Container();
    }
  }

  Widget _getSection(String title) {
    return Padding(
        padding: const EdgeInsets.only(
            top: AppPadding.p12,
            left: AppPadding.p12,
            right: AppPadding.p12,
            bottom: AppPadding.p2),
        child: Text(title, style: Theme.of(context).textTheme.displaySmall));
  }

  Widget _getInfoText(String info) {
    return Padding(
      padding: const EdgeInsets.all(AppSize.s12),
      child: Text(info, style: Theme.of(context).textTheme.bodyMedium),
    );
  }

}
