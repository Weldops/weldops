import 'package:flutter/material.dart';
import '../../../../themes/app_text_styles.dart';
import '../../../../themes/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../widgets/expandable_list.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String appVersion = "Loading...";

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() {
          appVersion = "v${packageInfo.version} (${packageInfo.buildNumber})";
        });
      }
    } catch (e) {
      debugPrint("Error fetching app version: $e");
    }
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
        title: Text(AppLocalizations.of(context)!.about,
            style: AppTextStyles.headerText),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExpandableListTile(
                title: AppLocalizations.of(context)!.weldops,
                expandedLabelText: AppLocalizations.of(context)!.appVersion,
                expandedContent: appVersion,
                summaryFormat: false,
              ),
              ExpandableListTile(
                title: AppLocalizations.of(context)!.aboutEsab,
                expandedContent: 'A "terms and conditions" document outlines the rules and guidelines governing a users interaction with a service or platform, detailing their rights, responsibilities, limitations, and any restrictions on usage, essentially acting as a legally binding contract between the user and the company, including aspects like data privacy, intellectual property rights, dispute resolution procedures, and the applicable jurisdiction in case of disagreements.',
              ),
              ExpandableListTile(
                title: AppLocalizations.of(context)!.termsAndCondition,
                expandedContent: 'A "terms and conditions" document outlines the rules and guidelines governing a users interaction with a service or platform, detailing their rights, responsibilities, limitations, and any restrictions on usage, essentially acting as a legally binding contract between the user and the company, including aspects like data privacy, intellectual property rights, dispute resolution procedures, and the applicable jurisdiction in case of disagreements.',
              ),
              ExpandableListTile(
                title: AppLocalizations.of(context)!.privacyPolicy,
                expandedContent: 'A privacy policy is a thorough explanation of how you plan to use any personal information that you collect through your mobile app or website. These policies are sometimes called privacy statements or privacy notices. They serve as legal documents meant to protect both company and consumers.',
                showDivider: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
