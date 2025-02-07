import 'package:esab/features/auth/presentation/providers/auth_state_notifier_provider.dart';
import 'package:esab/shared/provider/error_provider.dart';
import 'package:esab/themes/app_text_styles.dart';
import 'package:esab/themes/colors.dart';
import 'package:esab/utils/snackbar_util.dart';
import 'package:esab/validators/create_account_validator.dart';
import 'package:esab/shared/widgets/buttons/custom_button.dart';
import 'package:esab/shared/widgets/inputs/underlined_input.dart';
import 'package:esab/shared/widgets/logos/logo.dart';
import 'package:esab/features/auth/presentation/widgets/social_logins.dart';
import 'package:esab/shared/widgets/texts/auth_heading.dart';
import 'package:esab/shared/widgets/texts/navigate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends ConsumerState<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  navigateToSignUp() {
    ref.read(errorProvider.notifier).clearErrors();
    Navigator.pushNamed(context, '/createAccount');
  }

  navigateToForgotPassword() {
    Navigator.pushNamedAndRemoveUntil(
        context, '/forgotPassword', (route) => false);
  }

  void handleSignIn() async {
    ref.read(signInStateNotifierProvider.notifier).clearErrorMessage();
    final emailError =
        CreateAccountValidator.validateEmail(emailController.text.trim());
    final passwordError =
        CreateAccountValidator.validatePassword(passwordController.text.trim());

    ref.read(errorProvider.notifier).setEmailError(emailError ?? '');
    ref.read(errorProvider.notifier).setPasswordError(passwordError ?? '');

    if (emailError != null || passwordError != null) {
      return;
    }

    await ref.read(signInStateNotifierProvider.notifier).signIn(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

    final signInState = ref.watch(signInStateNotifierProvider);

    if (!mounted) return;

    if (signInState.isSignedIn) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      SnackbarUtils.showSnackbar(
          context, AppLocalizations.of(context)!.loginSuccess);
    } else {
      ref.read(errorProvider.notifier).setCommonError(signInState.errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final errorState = ref.watch(errorProvider);
    final signInState = ref.watch(signInStateNotifierProvider);
    return Scaffold(
        backgroundColor: AppColors.primaryBackgroundColor,
        body: SafeArea(
            child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top left logo
                      const Logo(),
                      SizedBox(height: screenHeight * 0.06),

                      // Header
                      AuthHeading(
                        text: AppLocalizations.of(context)!.signIn,
                      ),
                      SizedBox(height: screenHeight * 0.04),

                      // Email Field
                      UnderlinedInput(
                        labelText: AppLocalizations.of(context)!.emailAddress,
                        controller: emailController,
                        errorText: errorState.emailError?.isEmpty == false
                            ? errorState.emailError
                            : null,
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      // Password Field
                      UnderlinedInput(
                        labelText: AppLocalizations.of(context)!.password,
                        controller: passwordController,
                        isPassword: true,
                        errorText: errorState.passwordError?.isEmpty == false
                            ? errorState.passwordError
                            : null,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () {
                              navigateToForgotPassword();
                            },
                            child: Text(
                              AppLocalizations.of(context)!.forgotPassword,
                              style: AppTextStyles.secondaryRegularText,
                            )),
                      ),
                      SizedBox(height: screenHeight * 0.1),

                      signInState.errorMessage.isNotEmpty
                          ? Center(
                              child: Text(
                                signInState.errorMessage,
                                style: AppTextStyles.errorSmallText,
                                textAlign: TextAlign.center,
                              ),
                            )
                          : const SizedBox(),
                      SizedBox(height: screenHeight * 0.02),
                      // Create Account Button
                      CustomButton(
                        buttonText: AppLocalizations.of(context)!.signIn,
                        onTapCallback: () {
                          handleSignIn();
                        },
                        isLoading: signInState.isLoading,
                      ),

                      SizedBox(height: screenHeight * 0.02),

                      const SocialLogins(),
                      const SizedBox(
                        height: 45,
                      ),
                      NavigateText(
                        questionText:
                            AppLocalizations.of(context)!.dontHaveAccount,
                        routeText: AppLocalizations.of(context)!.signUp,
                        onTapCallback: () {
                          navigateToSignUp();
                        },
                      ),
                    ]))));
  }
}
