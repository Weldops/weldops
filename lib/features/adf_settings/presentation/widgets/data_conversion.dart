import 'package:shared_preferences/shared_preferences.dart';

Map<String, dynamic> convertBluetoothDataToJson(List<int> data, Map<String, dynamic> device) {
  if (data.isEmpty) {
    print("⚠️ Invalid Bluetooth data, returning defaults.");
    return getDefaultAdfSettings(device);
  }

  try {
    bool isWeldingFirst = data[10] == 1;
    double weldingShade = data[11].toDouble() ;
    double cuttingShade = data[12].toDouble()  ;
    double weldingSensitivity = data[13].toDouble()  ;
    double weldingDelay = data[14].toDouble()  ;

    if (weldingShade > 0 && cuttingShade > 0) {
      saveShadePreferences(weldingShade, cuttingShade, weldingSensitivity, weldingDelay);
    }
    return {
      "modelId": device['deviceId'],
      "modelName": device['deviceName'],
      "imageUrl": "assets/images/helmet_image.png",
      "adfSettings": [
        {
          "modeType": "Welding",
          "image": "assets/images/welding_img.png",
          "sensitivity": {
            "image": "assets/images/sensitivity_img.png",
            "min": 0.0,
            "max": 5.0,
            "default": weldingSensitivity
          },
          "shade": {
            "image": "assets/images/shade_img.png",
            "min": 5.0,
            "max": 13.0,
            "default": weldingShade / 10
          },
          "delay": {
            "image": "assets/images/delay_img.png",
            "min": 0.0,
            "max": 5.0,
            "default": weldingDelay
          }
        },
        {
          "modeType": "Cutting",
          "image": "assets/images/cutting_img.png",
          "shade": {
            "image": "assets/images/shade_img.png",
            "min": 5.0,
            "max": 13.0,
            "default": cuttingShade / 10
          }
        }
      ]
    };
  } catch (e) {
    print("❌ Error parsing Bluetooth data: $e");
    return convertBluetoothDataToJson([], device); // Return default values
  }
}

Future<void> saveShadePreferences(double welding, double cutting, double sensitivity, double delay) async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setInt("weldShade", welding.toInt());
  await prefs.setInt("cuttingShade", cutting.toInt());
  await prefs.setInt("weldingSensitivity", sensitivity.toInt());
  await prefs.setInt("weldingDelay", delay.toInt());

  print("✅ Shade preferences saved successfully.");
}

Map<String, dynamic> getDefaultAdfSettings(Map<String, dynamic> device) {
  return {
    "modelId": device['deviceId'] ?? "default",
    "modelName": device['deviceName'] ?? "default",
    "imageUrl": "assets/images/helmet_image.png",
    "adfSettings": [
      {
        "modeType": "Welding",
        "image": "assets/images/welding_img.png",
        "shade": {
          "image": "assets/images/shade_img.png",
          "min": 5.0,
          "max": 13.0,
          "default": 10.0
        },
        "sensitivity": {
          "image": "assets/images/sensitivity_img.png",
          "min": 0.0,
          "max": 5.0,
          "default": 5.0
        },
        "delay": {
          "image": "assets/images/delay_img.png",
          "min": 0.0,
          "max": 5.0,
          "default": 5.0
        }
      },
      {
        "modeType": "Cutting",
        "image": "assets/images/cutting_img.png",
        "shade": {
          "image": "assets/images/shade_img.png",
          "min": 5.0,
          "max": 13.0,
          "default": 10.0
        }
      }
    ]
  };
}
