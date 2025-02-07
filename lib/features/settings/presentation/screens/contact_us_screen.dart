import 'package:flutter/material.dart';
import '../../../../themes/app_text_styles.dart';
import '../../../../themes/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/contact_card.dart';
import '../widgets/expandable_list.dart';
import '../widgets/header_bar.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBackgroundColor,
        foregroundColor: AppColors.secondaryColor,
        elevation: 0,
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.contactUs,
            style: AppTextStyles.headerText),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 26,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocalizations.of(context)!.howCanWeHelp,
                      style: AppTextStyles.secondaryMediumText),
                  imageContainer(
                      image: 'assets/images/welding_helmet.png',
                      height: 50,
                      width: 60)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                style: const TextStyle(color: AppColors.secondaryColor),
                decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.contactUsHintText,
                    hintStyle: AppTextStyles.secondarySmallText,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: AppColors.secondaryColor))),
              ),
            ),
            const SizedBox(height: 28),
            HeaderBar(
                text: AppLocalizations.of(context)!.frequentQuestions,
                height: 34),
            const SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    ExpandableListTile(
                      title: "How to Pair Helmet with the App ?",
                      expandedContent:
                          'Scan the device in application and choose the device add a nickname as your choice.Then all set you can access from the device list',
                    ),
                    ExpandableListTile(
                      title: "How to Pair Helmet with the App ?",
                      expandedContent:
                          'A "terms and conditions" document outlines the rules and guidelines governing a users interaction with a service or platform, detailing their rights, responsibilities, limitations, and any restrictions on usage, essentially acting as a legally binding contract between the user and the company, including aspects like data privacy, intellectual property rights, dispute resolution procedures, and the applicable jurisdiction in case of disagreements.',
                    ),
                    ExpandableListTile(
                      title: "How to Pair Helmet with the App ?",
                      expandedContent:
                          'A privacy policy is a thorough explanation of how you plan to use any personal information that you collect through your mobile app or website. These policies are sometimes called privacy statements or privacy notices. They serve as legal documents meant to protect both company and consumers.',
                      // showDivider: false,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),
            HeaderBar(
                text: AppLocalizations.of(context)!.directContact, height: 34),
            Row(
              children: [
                Expanded(
                  child: ContactCard(
                    imagePath: "assets/images/email.png",
                    height: 5,
                    title: "Have an urgent issue? \n Reach out to us at",
                    highlightedText: "support@esab.com",
                    onTap: () {
                      print('Highlighted text tapped!');
                    },
                  ),
                ),
                Expanded(
                  child: ContactCard(
                    imagePath: "assets/images/call.png",
                    height: 10,
                    title: "Call us directly at",
                    highlightedText: "+1-800-123-4567",
                    onTap: () {
                      print('Highlighted text tapped!');
                    },
                  ),
                ),
              ],
            ),
            HeaderBar(
              text: "Can’t find your issue?",
              height: 126,
              image: "assets/images/question_contact.png",
              isQuestionCard: true,
              description:
                  "Raise ticket for your custom quires our\ncustomer support person will replay soon.",
              highlightText: "Raise a Ticket",
              onTap: () {
                print('Highlighted text tapped!');
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                imageContainer(
                    image: "assets/images/linkedin.png",
                    onTap: () {
                      print('Highlighted text tapped!');
                    }),
                const SizedBox(
                  width: 12,
                ),
                imageContainer(
                    image: "assets/images/youtube.png",
                    onTap: () {
                      print('Highlighted text tapped!');
                    }),
                const SizedBox(
                  width: 12,
                ),
                imageContainer(
                    image: "assets/images/instagram.png",
                    onTap: () {
                      print('Highlighted text tapped!');
                    }),
                const SizedBox(
                  width: 12,
                ),
                imageContainer(
                    image: "assets/images/facebook.png",
                    onTap: () {
                      print('Highlighted text tapped!');
                    }),
                const SizedBox(
                  width: 12,
                ),
                imageContainer(image: "assets/images/twitter.png"),
              ],
            ),
            const SizedBox(height: 8),
            const Center(
                child: Text(
              " © 2024 ESAB. All Rights Reserved.",
              style: AppTextStyles.secondarySmallText,
            ))
          ],
        ),
      ),
    );
  }

  Widget imageContainer(
      {required String image,
      double height = 24,
      double width = 24,
      final VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: height,
        width: width,
        child: Image.asset(image),
      ),
    );
  }
}
