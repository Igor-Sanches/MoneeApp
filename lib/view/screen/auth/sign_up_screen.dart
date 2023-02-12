import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:monetization/view/screen/auth/widget/already_have_an_account_button.dart';
import 'package:monetization/view/screen/auth/widget/condition_check_box.dart';

import '../../../controller/auth_controller.dart';
import '../../../helper/helpers.dart';
import '../../../helper/responsive_helper.dart';
import '../../../helper/route_helper.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../../util/styles.dart';
import '../../base/custom_button.dart';
import '../../base/custom_snackbar.dart';
import '../../base/custom_text_field.dart';
import 'widget/guest_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _zipcodeFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _referCodeFocus = FocusNode();

  final MaskedTextController _phoneController = MaskedTextController(mask: '(00) 00000-0000');
  final MaskedTextController _zipcodeController = MaskedTextController(mask: '00000-000');
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _referCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: Center(
          child: Helpers.loading(),
        ),
        overlayOpacity: 0.8,
      child: Scaffold(
        body: SafeArea(child: Scrollbar(
          child: SingleChildScrollView(
            padding: ResponsiveHelper.isDesktop(context) ? EdgeInsets.zero : const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            physics: const BouncingScrollPhysics(),
            child: Center(
              child: Container(
                width: context.width > 700 ? 700 : context.width,
                padding: context.width > 700 ? const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT) : null,
                margin: context.width > 700 ? const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT) : null,
                decoration: context.width > 700 ? BoxDecoration(
                  color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 700 : 300], blurRadius: 5, spreadRadius: 1)],
                ) : null,
                child: GetBuilder<AuthController>(builder: (authController) {

                  return Column(children: [

                    const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                    Image.asset(Images.logo_icon, width: 150),
                    const SizedBox(height: 10),

                    const AlreadyHaveAnAccountButton(),
                    const SizedBox(height: 20),

                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                        color: Theme.of(context).cardColor,
                        boxShadow: [BoxShadow(color: Colors.grey[Get.isDarkMode ? 800 : 200], spreadRadius: 1, blurRadius: 5)],
                      ),
                      child: Column(children: [

                        CustomTextField(
                          hintText: 'name'.tr,
                          controller: _nameController,
                          focusNode: _nameFocus,
                          nextFocus: _emailFocus,
                          inputType: TextInputType.name,
                          capitalization: TextCapitalization.words,
                          prefixIcon: Images.user,
                          divider: true,
                        ),

                        CustomTextField(
                          hintText: 'email'.tr,
                          controller: _emailController,
                          focusNode: _emailFocus,
                          nextFocus: _phoneFocus,
                          inputType: TextInputType.emailAddress,
                          prefixIcon: Images.mail,
                          divider: true,
                        ),
                        CustomTextField(
                          hintText: 'phone'.tr,
                          controllerMask: _phoneController,
                          focusNode: _phoneFocus,
                          nextFocus: _zipcodeFocus,
                          inputType: const TextInputType.numberWithOptions(decimal: false, signed: true),
                          prefixIcon: Images.user,
                          divider: true,
                        ),
                        CustomTextField(
                          hintText: 'zipcode'.tr,
                          controllerMask: _zipcodeController,
                          focusNode: _zipcodeFocus,
                          nextFocus: _passwordFocus,
                          inputType: const TextInputType.numberWithOptions(decimal: false, signed: true),
                          prefixIcon: Images.user,
                          divider: true,
                        ),

                        CustomTextField(
                          hintText: 'password'.tr,
                          controller: _passwordController,
                          focusNode: _passwordFocus,
                          nextFocus: _confirmPasswordFocus,
                          inputType: TextInputType.visiblePassword,
                          prefixIcon: Images.lock,
                          isPassword: true,
                          divider: true,
                        ),

                        CustomTextField(
                          hintText: 'confirm_password'.tr,
                          controller: _confirmPasswordController,
                          focusNode: _confirmPasswordFocus,
                          nextFocus: _referCodeFocus,
                          inputAction: TextInputAction.next,
                          inputType: TextInputType.visiblePassword,
                          prefixIcon: Images.lock,
                          isPassword: true,
                        ),

                        CustomTextField(
                          hintText: 'refer_code'.tr,
                          controller: _referCodeController,
                          focusNode: _referCodeFocus,
                          inputAction: TextInputAction.done,
                          inputType: TextInputType.text,
                          capitalization: TextCapitalization.words,
                          prefixIcon: Images.refer_code,
                          divider: false,
                          prefixSize: 14,
                        )

                      ]),
                    ),
                    const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                    ConditionCheckBox(authController: authController),
                    const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                    Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: CustomButton(
                          buttonText: 'sign_up'.tr,
                          onPressed: authController.acceptTerms ? () => _register(authController) : null,
                        )
                    ),
                    const SizedBox(height: 30),

                    // SocialLoginWidget(),

                    const GuestButton(),

                  ]);
                }),
              ),
            ),
          ),
        )),
      ),
    );
  }

  void _register(AuthController authController) async {
    String name = _nameController.text.trim();
    String zipcode = _zipcodeController.text.trim();
    String phone = _phoneController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();
    String referCode = _referCodeController.text.trim();

    if (name.isEmpty) {
      showCustomSnackBar('enter_your_name'.tr);
    }else if (email.isEmpty) {
      showCustomSnackBar('enter_email_address'.tr);
    }else if (zipcode.isEmpty) {
      showCustomSnackBar('enter_zipcode'.tr);
    }else if (phone.isEmpty) {
      showCustomSnackBar('enter_phone'.tr);
    }else if (password.isEmpty) {
      showCustomSnackBar('enter_password'.tr);
    }else if (password.length < 6) {
      showCustomSnackBar('password_should_be'.tr);
    }else if (password != confirmPassword) {
      showCustomSnackBar('confirm_password_does_not_matched'.tr);
    }else if (referCode.isNotEmpty && referCode.length != 6) {
      showCustomSnackBar('invalid_refer_code'.tr);
    }else {
      context.loaderOverlay.show();
      authController.registration(name, zipcode, phone, email, password, referCode).then((status) async {
        context.loaderOverlay.hide();
        if (status.isSuccess) {
          Get.toNamed(RouteHelper.getInitialRoute());
        }else {
          showCustomSnackBar(status.message);
        }
      });
    }
  }
}
