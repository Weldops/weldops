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

class CreateAccountScreen extends ConsumerStatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  CreateAccountScreenState createState() => CreateAccountScreenState();
}

class CreateAccountScreenState extends ConsumerState<CreateAccountScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void handleCreateAccount() async {
    ref.read(createAccountStateNotifierProvider.notifier).clearErrorMessage();
    final emailError =
        CreateAccountValidator.validateEmail(emailController.text.trim());
    final passwordError =
        CreateAccountValidator.validatePassword(passwordController.text.trim());

    final confirmPasswordError = CreateAccountValidator.validateConfirmPassword(
        passwordController.text.trim(), confirmPasswordController.text.trim());

    ref.read(errorProvider.notifier).setEmailError(emailError ?? '');
    ref.read(errorProvider.notifier).setPasswordError(passwordError ?? '');
    ref
        .read(errorProvider.notifier)
        .setConfirmPasswordError(confirmPasswordError ?? '');

    if (emailError != null ||
        passwordError != null ||
        confirmPasswordError != null) {
      return;
    }

    await ref.read(createAccountStateNotifierProvider.notifier).createAccount(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

    final createAccountState = ref.watch(createAccountStateNotifierProvider);

    if (!mounted) {
      return;
    }

    print("CREATE ACCOUNT IN CONSOLE $createAccountState");
    if (createAccountState.isEmailLinkSent) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/verifyEmail', (route) => false);
      SnackbarUtils.showSnackbar(
          context, AppLocalizations.of(context)!.verificationEmailSentToast);
    }
  }

  void navigateToSignIn() {
    ref.read(errorProvider.notifier).clearErrors();
    Navigator.pushNamedAndRemoveUntil(context, '/signIn', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final errorState = ref.watch(errorProvider);

    final createAccountState = ref.watch(createAccountStateNotifierProvider);

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
                text: AppLocalizations.of(context)!.createAnAccount,
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
              SizedBox(height: screenHeight * 0.02),

              // Retype Password Field
              UnderlinedInput(
                labelText: AppLocalizations.of(context)!.retypePassword,
                controller: confirmPasswordController,
                isPassword: true,
                errorText: errorState.confirmPasswordError?.isEmpty == false
                    ? errorState.confirmPasswordError
                    : null,
              ),
              SizedBox(height: screenHeight * 0.06),
              createAccountState.errorMessage.isNotEmpty
                  ? Center(
                      child: Text(
                        createAccountState.errorMessage,
                        style: AppTextStyles.errorSmallText,
                      ),
                    )
                  : const SizedBox(),
              SizedBox(height: screenHeight * 0.02),

              // Create Account Button
              CustomButton(
                buttonText: AppLocalizations.of(context)!.createAnAccount,
                onTapCallback: () {
                  handleCreateAccount();
                },
                isLoading: createAccountState.isLoading,
              ),

              SizedBox(height: screenHeight * 0.02),

              const SocialLogins(),
              const SizedBox(
                height: 45,
              ),
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
        ),
      ),
    );
  }
}
