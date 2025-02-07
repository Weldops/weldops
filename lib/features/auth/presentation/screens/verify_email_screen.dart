import 'dart:async';

import 'package:esab/features/auth/presentation/providers/auth_state_notifier_provider.dart';
import 'package:esab/themes/app_text_styles.dart';
import 'package:esab/themes/colors.dart';
import 'package:esab/utils/common.dart';
import 'package:esab/utils/snackbar_util.dart';
import 'package:esab/shared/widgets/buttons/custom_outlined_button.dart';
import 'package:esab/shared/widgets/logos/logo.dart';
import 'package:esab/shared/widgets/texts/auth_heading.dart';
import 'package:esab/shared/widgets/texts/navigate_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  VerifyEmailScreenState createState() => VerifyEmailScreenState();
}

class VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startEmailVerificationCheck();
  }

  void checkEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
      if (user.emailVerified) {
        timer?.cancel();
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/accountCreateSuccess');
        }
      }
    }
  }

  void startEmailVerificationCheck() {
    timer = Timer.periodic(const Duration(seconds: 2), (_) {
      checkEmailVerification();
    });
  }

  navigateToCrateAccount() {
    Navigator.pushNamed(context, '/createAccount');
  }

  resentEmail() async {
    final signInState = ref.watch(signInStateNotifierProvider);
    if (signInState.user != null) {
      await ref
          .read(resendEmailStateNotifierProvider.notifier)
          .resendEmail(signInState.user!.email.toString());
      final resendState = ref.watch(resendEmailStateNotifierProvider);

      if (!mounted) {
        return;
      }

      if (resendState.isEmailSent) {
        SnackbarUtils.showSnackbar(context,
            'Verification link has been sent to your email. please check!');
      }

      if (resendState.errorMessage != null) {
        SnackbarUtils.showSnackbar(
            context, resendState.errorMessage.toString());
      }
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final resendState = ref.watch(resendEmailStateNotifierProvider);

    final signInState = ref.watch(signInStateNotifierProvider);

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
                    text: AppLocalizations.of(context)!.verifyYourEmail,
                  ),
                  Center(
                    child: Image.asset(
                      AppImages.emailSentImg,
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.4,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      style: AppTextStyles.secondarySmallText,
                      children: <TextSpan>[
                        TextSpan(
                          text: AppLocalizations.of(context)!
                              .verificationEmailSentText,
                        ),
                        const TextSpan(text: ' '),
                        TextSpan(
                          text:
                              '${signInState.user?.email ?? AppLocalizations.of(context)!.yourEmail}. ',
                          style: AppTextStyles.secondarySmallText
                              .copyWith(color: AppColors.primaryColor),
                        ),
                        const TextSpan(text: ' '),
                        TextSpan(
                          text: AppLocalizations.of(context)!.checkInboxText,
                        ),
                      ],
                    ),
                  ),
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
                    child: CustomOutlinedButton(
                      text: AppLocalizations.of(context)!.resendEmail,
                      borderColor: AppColors.primaryColor,
                      textColor: AppColors.primaryColor,
                      onPressed: () {
                        resentEmail();
                      },
                      isLoading: resendState.isLoading,
                    ),
                  ),
                  const SizedBox(height: 20),
                  NavigateText(
                      questionText:
                          AppLocalizations.of(context)!.enteredWrongEmail,
                      routeText: AppLocalizations.of(context)!.updateEmail,
                      onTapCallback: () {
                        navigateToCrateAccount();
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
