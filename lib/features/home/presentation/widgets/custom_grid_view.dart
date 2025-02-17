import 'package:esab/bluetooth/presentation/provider/bluetooth_device_state_notifier.dart';
import 'package:esab/features/home/presentation/widgets/add_new_device_card.dart';
import 'package:esab/features/home/presentation/widgets/grid_device_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomGridView extends ConsumerWidget {
  final List<Map<String, dynamic>> devicesList;

  const CustomGridView({super.key, required this.devicesList});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bluetoothDevice = ref.watch(bluetoothNotifierProvider);

    String getStatue(BluetoothDevice? device, Map<String, dynamic> btd) {
      String status = 'Disconnected';
      if (device != null && device.remoteId.str.toLowerCase() == btd['deviceId'].toLowerCase()) {
        status = device.isConnected
            ? AppLocalizations.of(context)!.connected
            : 'Disconnected';
      }
      return status;
    }

    final screenWidth = MediaQuery.of(context).size.width;
    handleSelectDevice(device) async {
      Navigator.pushNamed(context, '/adfSettings',
          arguments: {'device': device});
    }

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 cards per row
          crossAxisSpacing: 10, // space between cards horizontally
          mainAxisSpacing: 10, // space between cards vertically
          childAspectRatio: 0.9, // Aspect ratio of each card
        ),
        itemCount: devicesList.length + 1,
        itemBuilder: (context, index) {
          if (index == 1) {
            return AddNewDeviceCard(
              height: 182,
              width: screenWidth * 0.5,
              isGridView: true,
            );
          }

          if (index == 0 && devicesList.length == 1) {
            final device = devicesList[0];
            final name = device['deviceName'];
            final status = getStatue(bluetoothDevice.device, device);
            return GestureDetector(
              onTap: () {
                handleSelectDevice(device);
              },
              child: GridDeviceCard(
                height: 182,
                width: screenWidth * 0.5,
                title: name,
                status: status,
              ),
            );
          }

          final deviceIndex = index >  0 ? index - 1 : index;
          final device = devicesList[deviceIndex];
          final name = device['deviceName'];
          final status = getStatue(bluetoothDevice.device, device);
          return GestureDetector(
            onTap: () {
              handleSelectDevice(device);
            },
            child: GridDeviceCard(
                height: 182,
                width: screenWidth * 0.5,
                title: name,
                status: status),
          );
        },
      ),
    );
  }
}
