import 'package:esab/features/auth/presentation/providers/auth_state_notifier_provider.dart';
import 'package:esab/shared/provider/error_provider.dart';
import 'package:esab/shared/widgets/buttons/custom_outlined_button.dart';
import 'package:esab/shared/widgets/inputs/underlined_input.dart';
import 'package:esab/themes/app_text_styles.dart';
import 'package:esab/themes/colors.dart';
import 'package:esab/utils/common.dart';
import 'package:esab/shared/widgets/buttons/custom_button.dart';
import 'package:esab/shared/widgets/logos/logo.dart';
import 'package:esab/shared/widgets/texts/auth_heading.dart';
import 'package:esab/shared/widgets/texts/navigate_text.dart';
import 'package:esab/validators/create_account_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgotPassword extends ConsumerStatefulWidget {
  const ForgotPassword({super.key});

  @override
  ConsumerState<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends ConsumerState<ForgotPassword> {
  bool isEmailSent = false;
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final errorState = ref.watch(errorProvider);
    final _auth = FirebaseAuth.instance;

    navigateToSignIn() {
      Navigator.pushNamedAndRemoveUntil(context, '/signIn', (route) => false);
    }

    sendResetEmail(String email) async {
      final emailError =
          CreateAccountValidator.validateEmail(emailController.text.trim());
      ref.read(errorProvider.notifier).setEmailError(emailError ?? '');

      if (emailError != null) {
        return;
      }
      try {
        await _auth.sendPasswordResetEmail(email: email);
        setState(() {
          isEmailSent = true;
        });
      } catch (e) {
        print(e);
      }
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
                    text: AppLocalizations.of(context)!.forgotYourPass,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (isEmailSent)
                    Center(
                      child: Image.asset(
                        AppImages.forgotPass,
                        width: screenWidth * 0.8,
                        height: screenHeight * 0.28,
                      ),
                    ),
                  if (isEmailSent)
                    const SizedBox(
                      height: 40,
                    ),
                  Text(
                    isEmailSent
                        ? AppLocalizations.of(context)!
                            .forgotPassSuccessMessage(
                                emailController.text.trim())
                        : AppLocalizations.of(context)!.forgotPassMessage,
                    style: AppTextStyles.secondaryRegularText,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (!isEmailSent)
                    UnderlinedInput(
                      labelText: AppLocalizations.of(context)!.emailAddress,
                      controller: emailController,
                      errorText: errorState.emailError?.isEmpty == false
                          ? errorState.emailError
                          : null,
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
                  if (!isEmailSent)
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                      child: CustomButton(
                        buttonText: AppLocalizations.of(context)!.submit,
                        onTapCallback: () {
                          sendResetEmail(emailController.text.trim());
                        },
                      ),
                    ),
                  if (isEmailSent)
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                      child: CustomOutlinedButton(
                        text: AppLocalizations.of(context)!.resendEmail,
                        onPressed: () {
                          sendResetEmail(emailController.text.trim());
                        },
                      ),
                    ),
                  const SizedBox(height: 20),
                  NavigateText(
                      questionText: AppLocalizations.of(context)!.backTo,
                      routeText: AppLocalizations.of(context)!.signIn,
                      onTapCallback: () {
                        navigateToSignIn();
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
