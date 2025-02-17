import 'package:esab/bluetooth/domain/use_cases/connect_device_use_case.dart';
import 'package:esab/bluetooth/domain/use_cases/disconnect_device_use_case.dart';
import 'package:esab/bluetooth/domain/use_cases/read_characteristic_use_case.dart';
import 'package:esab/bluetooth/domain/use_cases/write_characteristic_use_case.dart';
import 'package:esab/bluetooth/presentation/provider/state/bluetooth_device_state.dart';
import 'package:esab/di/injector.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BluetoothDeviceNotifier extends StateNotifier<BtDeviceState> {
  BluetoothDeviceNotifier() : super(BtDeviceState());
  final ConnectDeviceUseCase _connect = injector.get<ConnectDeviceUseCase>();
  final DisconnectDeviceUseCase _disConnect =
      injector.get<DisconnectDeviceUseCase>();
  final ReadCharacteristicUseCase _read =
      injector.get<ReadCharacteristicUseCase>();
  final WriteCharacteristicUseCase _write =
      injector.get<WriteCharacteristicUseCase>();


  setDevice(BluetoothDevice device, BluetoothCharacteristic? readChar,
      BluetoothCharacteristic? writeChar) async {
    print("Before setting device - Current state: ${state.device?.remoteId}");
    state = BtDeviceState(
        device: device,
        readCharacteristic: readChar,
        writeCharacteristic: writeChar);
    print("After setting device - New state: ${state.device?.remoteId}");
  }

  Future<void> enableNotifications() async {
    if (state.readCharacteristic == null) {
      print("❌ Read characteristic is null, cannot enable notifications.");
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      await state.readCharacteristic!.setNotifyValue(true);
      state.readCharacteristic!.onValueReceived.listen((value) async {
        print("📥 Received Data from Helmet: $value");
        await prefs.setInt("weldShade", value[11]);
        await prefs.setInt("cuttingShade", value[12]);
        convertBluetoothDataToJson(value);
      });

      print("✅ Notifications enabled on ${state.readCharacteristic!.uuid}");
    } catch (e) {
      print("❌ Error enabling notifications: $e");
    }
  }

  Future<void> read() async {
    if (state.readCharacteristic == null) {
      print("❌ Read characteristic is null, cannot read.");
      return;
    }

    try {
      await state.readCharacteristic!.setNotifyValue(true);
      state.readCharacteristic!.onValueReceived.listen((List<int> value) {
        print("📥 Received Data: $value");
      });
    } catch (e) {
      print("❌ Error setting up notifications: $e");
    }
  }

  Future<void> write(List<int> value) async {
    if (state.writeCharacteristic == null) {
      print("❌ Write characteristic is null, cannot send data.");
      return;
    }

    try {
      await state.writeCharacteristic!.write(value, withoutResponse: true);
      print("✅ Sent Data: $value");
    } catch (e) {
      print("❌ Error writing data: $e");
    }
  }
  Future<Map<String, dynamic>> convertBluetoothDataToJson(List<int> data) async {
    // Determine the primary mode based on data[10]
    bool isWeldingFirst = data[10] == 1;
    String firstMode = isWeldingFirst ? "Welding" : "Cutting";
    String secondMode = isWeldingFirst ? "Cutting" : "Welding";
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int? weldValue = prefs.getInt("weldShade");
    int? cuttingValue = prefs.getInt("cuttingShade", );
    // handleSelectWelding(firstMode);

    return {
      "modelId":'deviceId',
      "modelName": 'deviceName',
      "imageUrl": "assets/images/helmet_image.png",
      "adfSettings": [
        {
          "modeType": firstMode,
          "image": "assets/images/welding_img.png",
          "shade": {
            "image": "assets/images/shade_img.png",
            "min": 5.0,
            "max": 13.0,
            "default": weldValue
          },
          "sensitivity": {
            "image": "assets/images/sensitivity_img.png",
            "min": 0.0,
            "max": 5.0,
            "default": data[13].toDouble()
          },
          "delay": {
            "image": "assets/images/delay_img.png",
            "min": 0.0,
            "max": 5.0,
            "default": data[14].toDouble()
          }
        },
        {
          "modeType": secondMode,
          "image": "assets/images/cutting_img.png",
          "shade": {
            "image": "assets/images/shade_img.png",
            "min": 5.0,
            "max": 13.0,
            "default": cuttingValue
          }
        }
      ]
    };
  }

  Future<String> connect(BluetoothDevice device) async {
    if (!mounted) return 'false'; // Prevent action if disposed

    final result = await _connect.execute(device);

    if (mounted && state.device != null && result == 'true') {
      await disConnect();
    }

    return result;
  }

  Future<String> disConnect() async {
    if (!mounted) return 'false'; // Prevent action if disposed

    final result = await _disConnect.execute(state.device!);
    if (mounted) reset();

    return result;
  }


  reset() {
    state = BtDeviceState();
  }

}
