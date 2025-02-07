import 'package:esab/features/onboard/presentation/providers/onboadrd_state_notifier_provider.dart';
import 'package:esab/themes/app_text_styles.dart';
import 'package:esab/shared/widgets/buttons/custom_button.dart';
import 'package:esab/shared/widgets/texts/navigate_text.dart';
import 'package:esab/themes/colors.dart';
import 'package:esab/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardScreen extends ConsumerWidget {
  const OnboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void markOnboardingAsCompleted() async {
      await ref
          .read(onboardStateNotifierProvider.notifier)
          .completeOnboarding();
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/createAccount', (route) => false);
      }
    }

    void navigateToSignIn() async {
      await ref
          .read(onboardStateNotifierProvider.notifier)
          .completeOnboarding();
      if (context.mounted) {
        Navigator.pushNamed(context, '/signIn');
      }
    }

    return Scaffold(
      body: Container(
        padding:
            const EdgeInsets.only(top: 80.0, left: 20, right: 20, bottom: 80),
        color: AppColors.primaryBackgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top content
            Align(
              alignment: Alignment.centerLeft,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Image.asset(
                      AppImages.onboardBackgroundImage,
                      height: 300,
                      width: 189,
                      fit: BoxFit.contain,
                    ),
                  ),
                  // Foreground content (icon and text)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        AppImages.weldopsLogo2,
                        height: 25,
                        width: 170,
                      ),
                      const SizedBox(height: 50),
                      Text(
                        AppLocalizations.of(context)!.onboardTitle,
                        style: AppTextStyles.headlineXl,
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 80),
                      Text(
                        AppLocalizations.of(context)!.onboardDesc,
                        style: AppTextStyles.secondaryRegularText,
                      )
                    ],
                  ),
                ],
              ),
            ),

            // Bottom content
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: CustomButton(
                    onTapCallback: markOnboardingAsCompleted,
                    buttonText: AppLocalizations.of(context)!.createAnAccount,
                    backgroundColor: AppColors.secondaryColor,
                  ),
                ),
                const SizedBox(height: 30),
                NavigateText(
                  questionText:
                      AppLocalizations.of(context)!.alreadyHaveAnAccount,
                  routeText: AppLocalizations.of(context)!.signIn,
                  onTapCallback: () {
                    navigateToSignIn();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
