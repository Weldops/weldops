import 'dart:io';

import 'package:esab/features/auth/presentation/providers/auth_state_notifier_provider.dart';
import 'package:esab/features/settings/presentation/widgets/setting_row.dart';
import 'package:esab/themes/app_text_styles.dart';
import 'package:esab/themes/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends ConsumerStatefulWidget {
  const SettingScreen({super.key});

  @override
  ConsumerState<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  String _userName = "User";
  String _email = "";
  moveToPartDetails(part) async {
    Navigator.pushNamed(context, '/partDetails', arguments: {'part': part});
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    final userName = prefs.getString('userName') ?? "User";
    final email = prefs.getString('email') ?? "";

    setState(() {
      _userName = userName;
      _email = email;
    });
  }

  Future<void> logout() async {
    print('object');
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/signIn', (route) => false);
  }

  Future<void> editProfilePage() async {
    final result = await Navigator.pushNamed(context, '/editProfile'); // Await the result
    if (result == true) {
      await _loadUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user_info = ref.watch(signInStateNotifierProvider);

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
                      const CircleAvatar(
                        radius: 30,
                        child: Icon(Icons.person),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _userName,
                            style: AppTextStyles.headerText,
                          ),
                          Text(
                            user_info.user?.email ?? _email, // Prefer user_info email if available
                            style: AppTextStyles.secondarySmallText,
                          ),
                        ],
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
