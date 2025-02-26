import 'dart:async';

import 'package:esab/bluetooth/presentation/provider/bluetooth_device_state_notifier.dart';
import 'package:esab/features/auth/presentation/providers/auth_state_notifier_provider.dart';
import 'package:esab/features/home/presentation/providers/home_state_notifier_provider.dart';
import 'package:esab/features/home/presentation/widgets/custom_grid_view.dart';
import 'package:esab/features/home/presentation/widgets/custom_list_view.dart';
import 'package:esab/features/home/presentation/widgets/no_devices_view.dart';
import 'package:esab/features/parts/presentation/screens/parts_screen.dart';
import 'package:esab/features/settings/presentation/screens/setting_screen.dart';
import 'package:esab/themes/colors.dart';
import 'package:esab/utils/common.dart';
import 'package:esab/utils/snackbar_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  StreamSubscription<BluetoothConnectionState>? _connectionStateSubscription;

  @override
  void initState() {
    super.initState();

    final deviceState = ref.read(bluetoothNotifierProvider);
    if (deviceState.device != null) {
      _connectionStateSubscription =
          deviceState.device!.connectionState.listen((state) async {
        if (state == BluetoothConnectionState.disconnected) {
          ref.read(bluetoothNotifierProvider.notifier).reset();
        }
      });
    }
  }

  @override
  void dispose() {
    _connectionStateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeStateNotifierProvider);
    void _onItemTapped(int index) {
      ref.read(homeStateNotifierProvider.notifier).updateSelectedIndex(index);
    }

    List<Widget> pages = <Widget>[
      homeState.devicesList.isEmpty
          ? const NoDevicesView()
          : (homeState.isGridView
              ? CustomGridView(
                  devicesList: homeState.devicesList,
                )
              : CustomListView(
                  devicesList: homeState.devicesList,
                )),
      const PartsScreen(),
      const SettingScreen()
    ];

    handleLogout() async {
      final logoutNotifier = ref.read(logoutStateNotifierProvider.notifier);

      await logoutNotifier.logout();

      final logoutState = ref.watch(logoutStateNotifierProvider);

      if (!context.mounted) {
        return;
      }

      if (logoutState.isLoggedOut) {
        ref.read(signInStateNotifierProvider.notifier).clearState();

        SnackbarUtils.showSnackbar(
            context, AppLocalizations.of(context)!.loggedoutSuccess);
        Navigator.pushNamedAndRemoveUntil(context, '/signIn', (route) => false);
      } else {
        SnackbarUtils.showSnackbar(
            context, AppLocalizations.of(context)!.somethingWentWrong);
      }
    }

    toggleView() {
      ref.read(homeStateNotifierProvider.notifier).toggleViewMode();
    }

    return Scaffold(
        backgroundColor: AppColors.primaryBackgroundColor,
        appBar: homeState.selectedNavigationIndex == 0
            ? PreferredSize(
                preferredSize: const Size.fromHeight(80),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: AppBar(
                    title: Image.asset(
                      AppImages.weldopsLogo2,
                      height: 300,
                      width: 189,
                      fit: BoxFit.contain,
                    ),
                    actions: [
                      Image.asset(
                        AppImages.notificationIcon,
                        height: 44,
                        width: 44,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: toggleView,
                        child: Image.asset(
                          homeState.isGridView
                              ? AppImages.listView
                              : AppImages.gridView,
                          height: 44,
                          width: 44,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                    ],
                    backgroundColor: AppColors.primaryBackgroundColor,
                  ),
                ),
              )
            : null,
        body: IndexedStack(
          index: homeState.selectedNavigationIndex,
          children: pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: AppColors.primaryBackgroundColor,
          items: <BottomNavigationBarItem>[
            _buildBottomNavItem(
              icon: Icons.home,
              label: AppLocalizations.of(context)!.home,
              isSelected: homeState.selectedNavigationIndex == 0,
            ),
            _buildBottomNavItem(
              icon: Icons.build,
              label: AppLocalizations.of(context)!.parts,
              isSelected: homeState.selectedNavigationIndex == 1,
            ),
            _buildBottomNavItem(
              icon: Icons.settings,
              label: AppLocalizations.of(context)!.settings,
              isSelected: homeState.selectedNavigationIndex == 2,
            ),
          ],
          currentIndex: homeState.selectedNavigationIndex,
          unselectedItemColor: AppColors.secondaryColor,
          selectedItemColor: AppColors.secondaryColor,
          onTap: _onItemTapped,
        ));
  }

  BottomNavigationBarItem _buildBottomNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return BottomNavigationBarItem(
      icon: Stack(
        alignment: Alignment.center,
        children: [
          if (isSelected)
            Container(
                width: 66,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(50),
                )),
          Icon(icon,
              color: isSelected ? AppColors.secondaryTextColor : Colors.grey),
        ],
      ),
      label: label,
    );
  }
}
