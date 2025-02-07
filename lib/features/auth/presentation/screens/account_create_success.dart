import 'package:esab/themes/app_text_styles.dart';
import 'package:esab/themes/colors.dart';
import 'package:esab/utils/common.dart';
import 'package:esab/shared/widgets/buttons/custom_button.dart';
import 'package:esab/shared/widgets/logos/logo.dart';
import 'package:esab/shared/widgets/texts/auth_heading.dart';
import 'package:esab/shared/widgets/texts/navigate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountCreateSuccess extends StatelessWidget {
  const AccountCreateSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    navigateToSignIn() {
      Navigator.pushNamedAndRemoveUntil(context, '/signIn', (route) => false);
    }

    navigateToSignUp() {
      Navigator.pushNamedAndRemoveUntil(
          context, '/createAccount', (route) => false);
    }

    return Scaffold(
      backgroundColor: AppColors.primaryBackgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top left logo
                  const Logo(),
                  SizedBox(height: screenHeight * 0.06),

                  // Header
                  AuthHeading(
                    text: AppLocalizations.of(context)!.accountCreateSuccess,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Image.asset(
                      AppImages.accountCreateSuccess,
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.28,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    AppLocalizations.of(context)!.accountCreateWelcomeText,
                    style: AppTextStyles.secondaryRegularText,
                  )
                ],
              ),
            ),

            // Bottom section with button and text
            Padding(
              padding: EdgeInsets.only(
                bottom: screenHeight * 0.03,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                    child: CustomButton(
                      buttonText: AppLocalizations.of(context)!.getStarted,
                      onTapCallback: () {
                        navigateToSignIn();
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  NavigateText(
                      questionText: AppLocalizations.of(context)!.backTo,
                      routeText: AppLocalizations.of(context)!.signUp,
                      onTapCallback: () {
                        navigateToSignUp();
                      }),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
