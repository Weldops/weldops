import 'package:flutter/material.dart';
import '../../../../themes/app_text_styles.dart';
import '../../../../themes/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../widgets/constants.dart';


class DealerLocationScreen extends StatefulWidget {
  const DealerLocationScreen({super.key});

  @override
  State<DealerLocationScreen> createState() => _DealerLocationScreenState();
}

class _DealerLocationScreenState extends State<DealerLocationScreen> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(dealer_locator_url)); // Replace with your URL
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBackgroundColor,
        foregroundColor: AppColors.secondaryColor,
        elevation: 0,
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.dealerLocation,
            style: AppTextStyles.headerText),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}

