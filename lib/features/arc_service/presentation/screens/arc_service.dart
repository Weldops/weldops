import 'package:esab/bluetooth/presentation/provider/bluetooth_device_state_notifier.dart';
import 'package:esab/features/arc_service/presentation/widgets/arc_service_lens_card.dart';
import 'package:esab/themes/app_text_styles.dart';
import 'package:esab/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/lens_provider.dart';


class AdfService extends ConsumerWidget {
   const AdfService({super.key, required this.device});

  final Map<String, dynamic> device;

  String getStatus(BluetoothDevice? device, BuildContext context) {
    if (device?.remoteId.str == this.device['deviceId']) {
      return device!.isConnected
          ? AppLocalizations.of(context)!.connected
          : 'Disconnected';
    }
    return 'Disconnected';
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bluetoothDevice = ref.watch(bluetoothNotifierProvider);
    final status = getStatus(bluetoothDevice.device, context);
    final lensRecordsAsync = ref.watch(lensRecordsProvider);

    return Scaffold(
      backgroundColor: AppColors.primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBackgroundColor,
        foregroundColor: AppColors.secondaryColor,
        centerTitle: true,
        title: const Column(
          children: [
            Text(
              'Service log',
              style: AppTextStyles.appHeaderText,
            ),
            SizedBox(height: 10),
            Text(
              'Track and maintain the status of your lens covers.',
              style: AppTextStyles.secondaryRegularText,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: [
            Card(
              color: AppColors.cardBgColor,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  Image.asset(
                    device['imageUrl'],
                    width: 80,
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        device['deviceName'],
                        style: AppTextStyles.appHeaderText,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 8,
                            width: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: status == AppLocalizations.of(context)!.connected
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            status,
                            style: AppTextStyles.deviceStatus,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            lensRecordsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) {
                return const Center(child: Text('Failed to load records'));
              },
              data: (records) {
                return Column(
                  children: records.map((record) {
                    return LensCard(
                      id: record.id,
                      hours: record.hours,
                      imageUrl: record.imageUrl,
                      percentage: record.percentage,
                      title: record.title,
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
