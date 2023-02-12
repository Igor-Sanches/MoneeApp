import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../controller/splash_controller.dart';
import '../../../helper/responsive_helper.dart';
import '../../../util/dimensions.dart';
import '../../../util/html_type.dart';
import '../../../util/styles.dart';
import '../../base/custom_app_bar.dart';

class HtmlViewerScreen extends StatefulWidget {
  final HtmlType htmlType;
  const HtmlViewerScreen({@required this.htmlType});

  @override
  State<HtmlViewerScreen> createState() => _HtmlViewerScreenState();
}

class _HtmlViewerScreenState extends State<HtmlViewerScreen> {

  @override
  void initState() {
    super.initState();

    Get.find<SplashController>().getHtmlText(widget.htmlType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.htmlType == HtmlType.TERMS_AND_CONDITION ? 'terms_conditions'.tr
          : widget.htmlType == HtmlType.ABOUT_US ? 'about_us'.tr : widget.htmlType == HtmlType.PRIVACY_POLICY
          ? 'privacy_policy'.tr : widget.htmlType == HtmlType.SHIPPING_POLICY ? 'shipping_policy'.tr
          : widget.htmlType == HtmlType.REFUND ? 'refund_policy'.tr :  widget.htmlType == HtmlType.CANCELATION
          ? 'cancellation_policy'.tr : 'no_data_found'.tr),
      body: GetBuilder<SplashController>(builder: (splashController) {
        return Center(
          child: splashController.htmlText != null ? SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Ink(
              width: Dimensions.WEB_MAX_WIDTH,
              color: Theme.of(context).cardColor,
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              child: Column(children: [

                ResponsiveHelper.isDesktop(context) ? Container(
                  height: 50, alignment: Alignment.center, color: Theme.of(context).cardColor, width: Dimensions.WEB_MAX_WIDTH,
                  child: SelectableText(widget.htmlType == HtmlType.TERMS_AND_CONDITION ? 'terms_conditions'.tr
                      : widget.htmlType == HtmlType.ABOUT_US ? 'about_us'.tr : widget.htmlType == HtmlType.PRIVACY_POLICY
                      ? 'privacy_policy'.tr : widget.htmlType == HtmlType.SHIPPING_POLICY ? 'shipping_policy'.tr
                      : widget.htmlType == HtmlType.REFUND ? 'refund_policy'.tr :  widget.htmlType == HtmlType.CANCELATION
                      ? 'cancellation_policy'.tr : 'no_data_found'.tr,
                    style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Colors.black),
                  ),
                ) : const SizedBox(),

                (splashController.htmlText.contains('<ol>') || splashController.htmlText.contains('<ul>')) ? HtmlWidget(
                  splashController.htmlText ?? '',
                  key: Key(widget.htmlType.toString()),
                  onTapUrl: (String url) {
                    return launchUrlString(url, mode: LaunchMode.externalApplication);
                  },
                ) : SelectableHtml(
                  data: splashController.htmlText, shrinkWrap: true,
                  onLinkTap: (String url, RenderContext context, Map<String, String> attributes, element) {
                    if(url.startsWith('www.')) {
                      url = 'https://$url';
                    }
                    if (kDebugMode) {
                      print('Redirect to url: $url');
                    }
                    html.window.open(url, "_blank");
                  },
                ),

              ]),
            ),
          ) : const CircularProgressIndicator(),
        );
      }),
    );
  }
}