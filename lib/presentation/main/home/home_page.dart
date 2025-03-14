import 'package:carousel_slider/carousel_slider.dart';
import 'package:complete_advanced_flutter_app/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:complete_advanced_flutter_app/presentation/main/home/home_viewmodel.dart';
import 'package:complete_advanced_flutter_app/presentation/resources/color_manager.dart';
import 'package:complete_advanced_flutter_app/presentation/resources/routes_manager.dart';
import 'package:complete_advanced_flutter_app/presentation/resources/strings_manager.dart';
import 'package:complete_advanced_flutter_app/presentation/resources/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../app/di.dart';
import '../../../domain/model/model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeViewModel _viewModel = instance<HomeViewModel>();

  @override
  void initState() {
    _bind();
    super.initState();
  }

  _bind() {
    _viewModel.start();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
      child: StreamBuilder<FlowState>(
        stream: _viewModel.outputState,
        builder: (context, snapshot) {
          return snapshot.data?.getScreenWidget(context, _getContentWidgets(),
                  () {
                _viewModel.start();
              }) ??
              Container();
        },
      ),
    ));
  }

  Widget _getContentWidgets() {
    return StreamBuilder<HomeViewObject>(
      stream: _viewModel.outputHomeData,
      builder: (context, snapshot) {
       return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // _getBannersCarousel(),
            _getBanner(snapshot.data?.banners),
            _getSection(AppStrings.services.tr()),
            _getServicesWidget(snapshot.data?.services),
            _getSection(AppStrings.stores.tr()),
            _getStoresWidget(snapshot.data?.stores)
          ],
        );
      },

    );
  }

  Widget _getSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(
          left: AppPadding.p12,
          right: AppPadding.p12,
          top: AppPadding.p12,
          bottom: AppPadding.p2),
      child: Text(
        title,
        style: Theme.of(context).textTheme.displaySmall,
      ),
    );
  }



  Widget _getBanner(List<Banners>? banners){
    if(banners != null){
      return CarouselSlider(
          items: banners.map((banners) => SizedBox(
            width: double.infinity,
            child: Card(
              elevation: AppSize.s1_5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.s12),
                side: BorderSide(
                  color: ColorManager.white,
                  width: AppSize.s1_5
                ),

              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSize.s12),
                child: Image.network(banners.image,fit: BoxFit.cover,),
              ),
            ),
          )).toList(),
          options: CarouselOptions(
            height: AppSize.s190,
            autoPlay: true,
            enableInfiniteScroll: true,
            enlargeCenterPage: true
          )
      );
    }
    else{
      return Container();
    }
  }



  Widget _getServicesWidget(List<Services>? services){

    if(services != null){
      return Padding(padding: const EdgeInsets.only(left: AppPadding.p12,right: AppPadding.p12),
      child: Container(
        height: AppSize.s140,
        margin: const EdgeInsets.symmetric(vertical: AppMargin.m12),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: services.map((services) => Card(
            elevation: AppSize.s4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSize.s12),
              side: BorderSide(
                  color: ColorManager.white,
                  width: AppSize.s1_5
              ),
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppSize.s12),
                  child: Image.network(
                    services.image,
                    fit: BoxFit.cover,
                    width: AppSize.s110,
                    height: AppSize.s100,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: AppPadding.p8),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(services.title,textAlign: TextAlign.center,),
                  ),
                )
              ],
            ),
          )).toList(),
        ),
      ),
      );
    }else{
      return Container();
    }

  }



  Widget _getStoresWidget(List<Stores>? stores){
  if(stores != null){
    return Padding(
        padding: const EdgeInsets.only(left: AppPadding.p12,right: AppPadding.p12,top: AppPadding.p12),
        child: Flex(
            direction: Axis.vertical,
          children: [
           GridView.count(
                mainAxisSpacing: AppSize.s8,
               crossAxisSpacing: AppSize.s8,
               physics: const ScrollPhysics(),
               shrinkWrap: true,
               crossAxisCount: 2,
                children: List.generate(stores.length, (index){
                  return InkWell(
                    onTap: () {
                      ///Navigate to store details page
                      Navigator.of(context).pushNamed(Routes.storeDetailsRoute);
                    },
                    child: Card(
                      elevation: AppSize.s4,
                      child: Image.network(stores[index].image,fit: BoxFit.cover,),
                    ),
                  );
                }),
           )
          ],
        ),
    );
  }else{
    return Container();
  }
  }
}
