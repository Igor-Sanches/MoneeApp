import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:monetization/view/screen/auth/widget/condition_check_box.dart';
import 'package:monetization/view/screen/auth/widget/guest_button.dart';

import '../../../controller/auth_controller.dart';
import '../../../helper/helpers.dart';
import '../../../helper/route_helper.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../../util/styles.dart';
import '../../base/custom_button.dart';
import '../../base/custom_snackbar.dart';
import '../../base/custom_text_field.dart';
import 'widget/new_account_button.dart';

class SignInScreen extends StatefulWidget {
  final bool exitFromApp;
  const SignInScreen({Key key, @required this.exitFromApp}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _countryDialCode;
  bool _canExit = GetPlatform.isWeb ? true : false;

  @override
  void initState() {
    super.initState();

    _emailController.text =  Get.find<AuthController>().getUserEmail() ?? '';
    _passwordController.text = Get.find<AuthController>().getUserPassword() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: Center(
          child: Helpers.loading(),
        ),
        overlayOpacity: 0.8,
      child: WillPopScope(
        onWillPop: () async {
          if(widget.exitFromApp) {
            if (_canExit) {
              if (GetPlatform.isAndroid) {
                SystemNavigator.pop();
              } else if (GetPlatform.isIOS) {
                exit(0);
              } else {
                Navigator.pushNamed(context, RouteHelper.getInitialRoute());
              }
              return Future.value(false);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('back_press_again_to_exit'.tr, style: const TextStyle(color: Colors.white)),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
                margin: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              ));
              _canExit = true;
              Timer(const Duration(seconds: 2), () {
                _canExit = false;
              });
              return Future.value(false);
            }
          }else {
            return true;
          }
        },
        child: Scaffold(
          appBar: AppBar(leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back_ios_rounded, color: Theme.of(context).textTheme.bodyLarge.color),
          ), elevation: 0, backgroundColor: Colors.transparent),
          body: SafeArea(child: Center(
            child: Scrollbar(
              child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Center(
                    child: Container(
                      width: context.width > 700 ? 700 : context.width,
                      padding: context.width > 700 ? const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT) : const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      margin: context.width > 700 ? const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT) : EdgeInsets.zero,
                      decoration: context.width > 700 ? BoxDecoration(
                        color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                        boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300], blurRadius: 5, spreadRadius: 1)],
                      ) : null,
                      child: GetBuilder<AuthController>(builder: (authController) {

                        return Column(children: [

                          Image.asset(Images.logo_icon, width: 150),
                          // SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          // Center(child: Text(AppConstants.APP_NAME, style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge))),
                          const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),

                          const NewAccountButton(),
                          const SizedBox(height: 50),

                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                              color: Theme.of(context).cardColor,
                              boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 1, blurRadius: 5)],
                            ),
                            child: Column(children: [

                              CustomTextField(
                                hintText: 'email'.tr,
                                controller: _emailController,
                                focusNode: _emailFocus,
                                nextFocus: _passwordFocus,
                                inputType: TextInputType.emailAddress,
                                prefixIcon: Images.mail,
                                divider: false,
                              ),
                              const Padding(padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE), child: Divider(height: 1)),

                              CustomTextField(
                                hintText: 'password'.tr,
                                controller: _passwordController,
                                focusNode: _passwordFocus,
                                inputAction: TextInputAction.done,
                                inputType: TextInputType.visiblePassword,
                                prefixIcon: Images.lock,
                                isPassword: true,
                                onSubmit: (text) => (GetPlatform.isWeb && authController.acceptTerms)
                                    ? _login(authController, _countryDialCode) : null,
                              ),

                            ]),
                          ),
                          const SizedBox(height: 10),

                          Row(children: [
                            Expanded(
                              child: ListTile(
                                onTap: () => authController.toggleRememberMe(),
                                leading: Checkbox(
                                  activeColor: Theme.of(context).primaryColor,
                                  value: authController.isActiveRememberMe,
                                  onChanged: (bool isChecked) => authController.toggleRememberMe(),
                                ),
                                title: Text('remember_me'.tr),
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                horizontalTitleGap: 0,
                              ),
                            ),
                          ]),
                          const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                          ConditionCheckBox(authController: authController),
                          const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                            child: CustomButton(
                              buttonText: 'sign_in'.tr,
                              onPressed: authController.acceptTerms ? () => _login(authController, _countryDialCode) : null,
                            ),
                          ),
                          const SizedBox(height: 30),
                          const GuestButton(),

                        ]);
                      }),
                    ),
                  )
              ),
            ),
          )),
        ),
      ),
    );
  }

  void _login(AuthController authController, String countryDialCode) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty) {
      showCustomSnackBar('enter_email'.tr);
    }else if (password.isEmpty) {
      showCustomSnackBar('enter_password'.tr);
    }else if (password.length < 6) {
      showCustomSnackBar('password_should_be'.tr);
    }else {
      context.loaderOverlay.show();
      authController.login(email, password).then((status) async {
        context.loaderOverlay.hide();
        if (status.isSuccess) {
          if (authController.isActiveRememberMe) {
            authController.saveUserNumberAndPassword(email, password, countryDialCode);
          } else {
            authController.clearUserNumberAndPassword();
          }
          Get.toNamed(RouteHelper.getInitialRoute());
        }else {
          showCustomSnackBar(status.message);
        }
      });
    }
  }
}
