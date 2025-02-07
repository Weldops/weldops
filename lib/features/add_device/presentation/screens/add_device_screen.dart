import 'dart:async';
import 'package:esab/features/add_device/presentation/widgets/pair_bottom_sheet.dart';
import 'package:esab/themes/app_text_styles.dart';
import 'package:esab/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddDeviceScreen extends ConsumerStatefulWidget {
  const AddDeviceScreen({super.key});

  @override
  ConsumerState<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends ConsumerState<AddDeviceScreen> {
 // List<BluetoothDevice> _systemDevices = [];
  List<ScanResult> _scanResults = [];
  bool _isScanning = false;
  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  late StreamSubscription<bool> _isScanningSubscription;

  @override
  void initState() {
    super.initState();

    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      List<ScanResult> filteredResults = [];
      for (ScanResult x in results) {
        if (x.advertisementData.connectable) {
          filteredResults.add(x);
        }
      }
      _scanResults = filteredResults;
      if (mounted) {
        setState(() {});
      }
    });

    _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
      _isScanning = state;
      if (mounted) {
        setState(() {});
      }
    });
    onScan();
  }

  @override
  void dispose() {
    _isScanningSubscription.cancel();
    _scanResultsSubscription.cancel();
    super.dispose();
  }

  Future onScan() async {
    // try {
    //   var withServices = [Guid("180f")]; // Battery Level Service
    //   _systemDevices = await FlutterBluePlus.systemDevices(withServices);
    // } catch (e) {
     
    //   print(e);
    // }
    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    } catch (e) {
      print(e);
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.secondaryColor,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.addDevice,
            style: AppTextStyles.appHeaderText),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 24, bottom: 20, top: 20, right: 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context)!.availableDevices,
                        style: AppTextStyles.secondaryRegularText),
                    if (!_isScanning)
                      InkWell(
                        onTap: () {
                          onScan();
                        },
                        child: const Icon(
                          Icons.refresh,
                          color: AppColors.primaryColor,
                          size: 24,
                        ),
                      ),
                    if (_isScanning)
                      const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ))
                  ]),
            ),
             Expanded(
            child:ListView.builder(
              shrinkWrap: true,
              itemCount: _scanResults.length,
              itemBuilder: (context, index) {
                final device = _scanResults[index];
                return ListTile(
                  leading: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset(
                        'assets/images/helmet_image.png',
                        height: 24,
                        width: 24,
                      ),
                    ),
                  ),
                  title: Text(
                      device.device.platformName.isNotEmpty
                          ? device.device.platformName
                          : device.device.remoteId.str,
                      style: AppTextStyles.secondaryRegularText),
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        backgroundColor: AppColors.secondaryColor,
                        isScrollControlled: true,
                        builder: (context) {
                          return PairBottomSheet(device: device.device);
                        });
                  },
                );
              },
            )),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
