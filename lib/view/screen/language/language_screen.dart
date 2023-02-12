import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/localization_controller.dart';
import '../../../helper/responsive_helper.dart';
import '../../../helper/route_helper.dart';
import '../../../util/app_constants.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../../util/styles.dart';
import '../../base/custom_button.dart';
import '../../base/custom_snackbar.dart';
import 'widget/language_widget.dart';

class ChooseLanguageScreen extends StatefulWidget {
  const ChooseLanguageScreen({Key key}) : super(key: key);

  @override
  State<ChooseLanguageScreen> createState() => _ChooseLanguageScreenState();
}

class _ChooseLanguageScreenState extends State<ChooseLanguageScreen> {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
  FirebaseAnalyticsObserver(analytics: analytics);

  @override
  void initState() {
    // TODO: implement initState
    observer.analytics.logScreenView(screenClass: 'ChooseLanguageScreen', screenName: 'ChooseLanguage');
    observer.analytics.setCurrentScreen(screenName: 'ChooseLanguageScreen');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<LocalizationController>(builder: (localizationController) {
          return Column(children: [

            Expanded(child: Center(
              child: Scrollbar(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.zero : const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: Center(child: SizedBox(
                    width: Dimensions.WEB_MAX_WIDTH,
                    child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [

                      Center(child: Image.asset(Images.logo_bg, width: 200)),
                      // Center(child: Text(AppConstants.APP_NAME, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge))),
                      const SizedBox(height: 30),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        child: Text('select_language'.tr, style: robotoMedium),
                      ),
                      const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                      GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: ResponsiveHelper.isDesktop(context) ? 4 : ResponsiveHelper.isTab(context) ? 3 : 2,
                          childAspectRatio: (1/1),
                        ),
                        itemCount: localizationController.languages.length,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => LanguageWidget(
                          languageModel: localizationController.languages[index],
                          localizationController: localizationController, index: index,
                        ),
                      ),
                      const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                      Text('you_can_change_language'.tr, style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor,
                      )),

                      ResponsiveHelper.isDesktop(context) ? Padding(
                        padding: const EdgeInsets.only(top: Dimensions.PADDING_SIZE_LARGE),
                        child: LanguageSaveButton(localizationController: localizationController),
                      ) : const SizedBox.shrink() ,

                    ]),
                  )),
                ),
              ),
            )),

            ResponsiveHelper.isDesktop(context) ? const SizedBox.shrink() : LanguageSaveButton(localizationController: localizationController),
          ]);
        }),
      ),
    );
  }
}

class LanguageSaveButton extends StatelessWidget {
  final LocalizationController localizationController;
  const LanguageSaveButton({Key key, @required this.localizationController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      buttonText: 'save'.tr,
      margin: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      onPressed: () {
        if(localizationController.languages.isNotEmpty && localizationController.selectedIndex != -1) {
          localizationController.setLanguage(Locale(
            AppConstants.languages[localizationController.selectedIndex].languageCode,
            AppConstants.languages[localizationController.selectedIndex].countryCode,
          ));
          localizationController.setLanguageSetup(true);
          Get.offAllNamed(RouteHelper.getSplashRoute());
        }else {
          showCustomSnackBar('select_a_language'.tr);
        }
      },
    );
  }
}

