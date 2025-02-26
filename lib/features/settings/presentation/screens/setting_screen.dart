import 'package:esab/features/auth/presentation/providers/auth_state_notifier_provider.dart';
import 'package:esab/features/settings/presentation/widgets/setting_row.dart';
import 'package:esab/themes/app_text_styles.dart';
import 'package:esab/themes/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../utils/snackbar_util.dart';
import '../../../home/presentation/providers/home_state_notifier_provider.dart';
import '../widgets/user_utils.dart';

class SettingScreen extends ConsumerStatefulWidget {
  const SettingScreen({super.key});

  @override
  ConsumerState<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  moveToPartDetails(part) async {
    Navigator.pushNamed(context, '/partDetails', arguments: {'part': part});
  }

  @override
  void initState() {
    super.initState();
  }


  Future<void> logout() async {
    final logoutNotifier = ref.read(logoutStateNotifierProvider.notifier);
    await logoutNotifier.logout();

    await FirebaseAuth.instance.signOut();

    if (!context.mounted) return;

    final logoutState = ref.read(logoutStateNotifierProvider);

    if (logoutState.isLoggedOut) {
      ref.read(signInStateNotifierProvider.notifier).clearState();

      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      SnackbarUtils.showSnackbar(context, AppLocalizations.of(context)!.loggedoutSuccess);
      Navigator.pushNamedAndRemoveUntil(context, '/signIn', (route) => false);
    } else {
      SnackbarUtils.showSnackbar(context, AppLocalizations.of(context)!.somethingWentWrong);
    }
  }

  Future<void> editProfilePage() async {
    Navigator.pushNamed(context, '/editProfile');
  }

  @override
  Widget build(BuildContext context) {
    final user_info = ref.watch(signInStateNotifierProvider);
    final user = ref.watch(userProvider);
    return Scaffold(
        backgroundColor: AppColors.primaryBackgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.primaryBackgroundColor,
          foregroundColor: AppColors.secondaryColor,
          elevation: 0,
          title: Text(AppLocalizations.of(context)!.settings,
              style: AppTextStyles.headerText),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey.shade800,
                        backgroundImage: user.profileImage != null ? FileImage(user.profileImage!) : null,
                        child: user.profileImage == null ? const Icon(Icons.person, size: 30) : null,
                      ),

                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.userName,softWrap: true,
                              style: AppTextStyles.headerText,
                            ),
                            Text(
                              user_info.user?.email ?? user.email, // Prefer user_info email if available
                              style: AppTextStyles.secondarySmallText,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () {
                        editProfilePage();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor),
                      child: const Text(
                        'Edit Profile',
                        style: AppTextStyles.buttonTextStyle,
                      ))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Contents',
                style: AppTextStyles.secondaryMediumText,
              ),
              const SizedBox(
                height: 10,
              ),
              Card(
                color: AppColors.cardBgColor,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      SettingsRow(
                        icon: Icons.location_on,
                        title: 'Dealer Locations',
                        onTap: () {
                          Navigator.pushNamed(context, '/dealerLocation');
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SettingsRow(
                        icon: Icons.ondemand_video_outlined,
                        title: 'Watch Tutorials',
                        onTap: () {
                          Navigator.pushNamed(context, '/tutotials');
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SettingsRow(
                        icon: Icons.language,
                        title: 'Language',
                        onTap: () {},
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SettingsRow(
                        isSwitch: true,
                        icon: Icons.notifications_sharp,
                        title: 'Notification',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'General',
                style: AppTextStyles.secondaryMediumText,
              ),
              const SizedBox(
                height: 10,
              ),
              Card(
                color: AppColors.cardBgColor,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      SettingsRow(
                        icon: Icons.help_outline,
                        title: 'How Tos',
                        onTap: () {},
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SettingsRow(
                        icon: Icons.contact_page_outlined,
                        title: 'Contact us',
                        onTap: () {
                          Navigator.pushNamed(context, '/contact-us');
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SettingsRow(
                        icon: Icons.language,
                        title: 'About',
                        onTap: () {
                          Navigator.pushNamed(context, '/about');
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SettingsRow(
                        icon: Icons.logout,
                        title: 'Logout',

                        onTap: () => logout(),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
