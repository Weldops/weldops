import 'package:esab/features/auth/presentation/providers/auth_state_notifier_provider.dart';
import 'package:esab/themes/app_text_styles.dart';
import 'package:esab/utils/common.dart';
import 'package:esab/utils/snackbar_util.dart';
import 'package:esab/shared/widgets/buttons/custom_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SocialLogins extends ConsumerWidget {
  const SocialLogins({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = MediaQuery.of(context).size.height;
    final googleSignInState = ref.watch(googleSignInStateNotifierProvider);

    void handleGoogleSignIn() async {
      await ref.read(googleSignInStateNotifierProvider.notifier).googleSignIn();

      final googleSignInState = ref.watch(googleSignInStateNotifierProvider);

      if (!context.mounted) {
        return;
      }

      if (googleSignInState.errorMessage.isNotEmpty) {
        SnackbarUtils.showSnackbar(context, googleSignInState.errorMessage);
        return;
      }

      if (googleSignInState.isSignedIn) {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }
    }

    void handleAppleSignIn() async {}

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.orSigninWith,
              style: AppTextStyles.secondaryRegularText,
              textAlign: TextAlign.center,
            )
          ],
        ),
        SizedBox(height: screenHeight * 0.03),
        CustomOutlinedButton(
          imagePath: AppImages.googleIcon,
          text: AppLocalizations.of(context)!.signInwithGoogle,
          onPressed: handleGoogleSignIn,
          isLoading: googleSignInState.isLoading,
        ),
        const SizedBox(
          height: 15,
        ),
        CustomOutlinedButton(
          imagePath: AppImages.appleIcon,
          text: AppLocalizations.of(context)!.signInwithApple,
          onPressed: () {
            handleAppleSignIn();
          },
        )
      ],
    );
  }
}
