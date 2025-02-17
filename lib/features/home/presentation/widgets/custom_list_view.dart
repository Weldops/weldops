import 'package:esab/bluetooth/presentation/provider/bluetooth_device_state_notifier.dart';
import 'package:esab/features/home/presentation/widgets/add_new_device_card.dart';
import 'package:esab/features/home/presentation/widgets/list_device_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomListView extends ConsumerWidget {
  final List<Map<String, dynamic>> devicesList;

  const CustomListView({super.key, required this.devicesList});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;

    String getStatue(BluetoothDevice? device, Map<String, dynamic> btd) {
      String status = 'Disconnected';
      if (device != null && device.remoteId.str.toLowerCase() == btd['deviceId'].toLowerCase()) {
        status = device.isConnected
            ? AppLocalizations.of(context)!.connected
            : 'Disconnected';
      } else {
        status = 'Disconnected';
      }
      return status;
    }

    final bluetoothDevice = ref.watch(bluetoothNotifierProvider);

    handleSelectDevice(device) async {
      Navigator.pushNamed(context, '/adfSettings',
          arguments: {'device': device});
    }

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: ListView.builder(
        itemCount: devicesList.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return AddNewDeviceCard(
              height: 105,
              width: screenWidth,
              isGridView: false,
            );
          }

          final device = devicesList[index == 0 ? 0 : index - 1];
          final name = device['deviceName'];
          final status = getStatue(bluetoothDevice.device, device);

          return GestureDetector(
            onTap: () {
              handleSelectDevice(device);
            },
            child: ListDeviceCard(
              height: 105,
              width: screenWidth,
              title: name,
              status: status,
            ),
          );
        },
      ),
    );
  }
}
